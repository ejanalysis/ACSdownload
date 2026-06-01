# ---------------------------------------------------------------------------- #
# Functions for parsing Census GEO_ID strings and FIPS codes.
#
# These helpers are intentionally self-contained so that the public
# functions in get_acs_new.R do not depend on the EJAM package.
# Where a richer version exists in EJAM (e.g. EJAM::fips_lead_zero(),
# EJAM::fipstype()) it is referenced in the function-level comment.
# ---------------------------------------------------------------------------- #


#' Extract the 3-character SUMLEVEL code from a Census GEO_ID
#'
#' Census GEO_ID strings begin with a 3-character SUMLEVEL code (e.g. "150"
#' for blockgroup) followed by a 4-character suffix, then "US", then the
#' fips code.
#'
#' @param geoid character vector of Census GEO_ID strings
#' @returns character vector of the first three characters of each geoid
#' @keywords internal
#' @noRd
sumlevel_from_geoid <- function(geoid) {
  sumlevel <- gsub("^(...).*US(.*)", "\\1", geoid)
  return(sumlevel)
}


#' Extract the FIPS code substring (everything after "US") from a Census GEO_ID
#'
#' Census GEO_ID strings have the form "<sumlevel><suffix>US<fips>", e.g.
#' "1500000US010010201001" for a blockgroup. SUMLEVEL is authoritative for the
#' geography type, so this function deliberately does **not** cross-check
#' against a digit-count heuristic -- several geography types (ZCTA, MSA,
#' Urban Area, Congressional District, ...) have fips widths that collide with
#' other types and would be wrongly flagged as invalid.
#'
#' @param geoid character vector of Census GEO_ID strings
#' @returns character vector of fips codes; NA for inputs without an "US"
#'   delimiter or with no characters after "US"
#' @keywords internal
#' @noRd
fips_from_geoid <- function(geoid) {
  has_us <- grepl("US", geoid, fixed = TRUE)
  fips <- gsub("^.*US(.*)", "\\1", geoid)
  fips[!has_us] <- NA
  fips[!is.na(fips) & nchar(fips) == 0] <- NA
  return(fips)
}


#' Add leading zeros to FIPS codes whose leading zeros were lost
#'
#' Valid 2-digit Census state/territory FIPS codes
#'
#' The 50 states, DC (11), and the territories ACS publishes (PR = 72, plus
#' 60/66/69/74/78). Used to sanity-check and disambiguate fips codes. Matches
#' the set in `EJAM:::stateinfo2$FIPS.ST`.
#'
#' @returns character vector of 2-character state FIPS codes
#' @keywords internal
#' @noRd
.valid_state_fips <- function() {
  c("01", "02", "04", "05", "06", "08", "09", "10", "11", "12", "13",
    "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25",
    "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36",
    "37", "38", "39", "40", "41", "42", "44", "45", "46", "47", "48",
    "49", "50", "51", "53", "54", "55", "56", "60", "66", "69", "72",
    "74", "78")
}


#' List of valid 11-character tract FIPS, from EJAM if it is installed
#'
#' Returns `unique(substr(EJAM::blockgroupstats$bgfips, 1, 11))` when the EJAM
#' package and its `blockgroupstats` data are available, otherwise `NULL`.
#' Used as the authoritative input to [`.disambiguate_11digit_fips()`] for
#' resolving the tract-vs-blockgroup ambiguity. Kept out of the default code
#' path so results are reproducible whether or not EJAM is installed.
#'
#' @returns character vector of 11-character tract fips, or `NULL`
#' @keywords internal
#' @noRd
.ejam_tract_fips <- function() {
  if (!requireNamespace("EJAM", quietly = TRUE)) return(NULL)
  bgs <- tryCatch(get("blockgroupstats", envir = asNamespace("EJAM")),
                  error = function(e) NULL)
  if (is.null(bgs)) {
    e <- new.env()
    bgs <- tryCatch({
      utils::data("blockgroupstats", package = "EJAM", envir = e)
      get("blockgroupstats", envir = e)
    }, error = function(e) NULL)
  }
  if (is.null(bgs) || !"bgfips" %in% names(bgs)) return(NULL)
  unique(substr(as.character(bgs$bgfips), 1, 11))
}


#' Disambiguate 11-digit FIPS codes (complete tract vs blockgroup-missing-zero)
#'
#' An 11-digit value is ambiguous: it may be a complete 11-character tract, or
#' a 12-character blockgroup whose leading zero was lost. Two disambiguation
#' strategies are applied, mirroring `EJAM::fips_lead_zero()`:
#'
#' 1. **Authoritative table** (if `tract_fips` is supplied): a value present in
#'    the known-tract list stays a tract; otherwise it is treated as a
#'    blockgroup missing its leading zero (prepend "0").
#' 2. **State-FIPS heuristic** (the deterministic default): a blockgroup only
#'    loses a leading zero when its state code is 0X (states 01-09), so the
#'    blockgroup reading is plausible only if `paste0("0", first_digit)` is a
#'    valid state; the tract reading is plausible only if the first two digits
#'    are a valid state. When exactly one reading is plausible, use it; when
#'    both are (e.g. state 40 tract vs state 04 blockgroup), default to tract;
#'    when neither is, return NA.
#'
#' @param x character vector of exactly-11-digit fips codes
#' @param tract_fips optional character vector of valid 11-char tract fips
#'   (e.g. from [`.ejam_tract_fips()`]); when NULL, use the heuristic
#' @param quiet if FALSE, warn about values left ambiguous by the heuristic
#' @returns character vector: tracts unchanged, blockgroups zero-prefixed to
#'   12 chars, impossible values NA
#' @keywords internal
#' @noRd
.disambiguate_11digit_fips <- function(x, tract_fips = NULL, quiet = TRUE) {

  valid_states <- .valid_state_fips()
  tract_ok <- substr(x, 1, 2) %in% valid_states                 # as a tract
  bg_ok    <- paste0("0", substr(x, 1, 1)) %in% valid_states    # as a bg-missing-0

  if (!is.null(tract_fips)) {
    is_tract <- x %in% tract_fips
    out <- ifelse(is_tract, x, paste0("0", x))
    # If it is neither a known tract nor a plausible blockgroup state, it is junk.
    out[!is_tract & !bg_ok & !tract_ok] <- NA_character_
    return(out)
  }

  out <- ifelse(tract_ok & !bg_ok, x,
         ifelse(bg_ok & !tract_ok, paste0("0", x),
         ifelse(tract_ok & bg_ok,  x,                # ambiguous -> assume tract
                                   NA_character_)))
  if (!quiet && any(tract_ok & bg_ok)) {
    warning(sum(tract_ok & bg_ok), " fips are 11 digits and ambiguous ",
            "between a complete tract and a blockgroup missing a leading ",
            "zero; assuming tract. Pass blockgroups as full 12-character ",
            "codes, or supply a tract list, to resolve this.")
  }
  out
}


#' Add leading zeros to FIPS codes whose leading zeros were lost
#'
#' Numeric FIPS codes lose their leading zeros when stored as numerics
#' (e.g. Alabama "01" becomes 1). This helper restores them to the
#' canonical Census widths: state=2, county=5, place=7, tract=11,
#' blockgroup=12, block=15.
#'
#' 11-digit inputs are ambiguous between a complete tract and a blockgroup
#' that lost its leading zero; they are resolved by
#' [`.disambiguate_11digit_fips()`] (state-FIPS heuristic by default, or an
#' authoritative tract list if `tract_fips` is supplied).
#'
#' @param fips character vector of fips codes
#' @param quiet logical; if FALSE, warn about NA-ed and still-ambiguous inputs
#' @param tract_fips optional character vector of valid 11-char tract fips for
#'   authoritative 11-digit disambiguation (see [`.ejam_tract_fips()`])
#' @returns character vector of length-normalized fips codes
#' @seealso EJAM::fips_lead_zero()
#' @keywords internal
#' @noRd
fips_lead_zero_acs <- function(fips, quiet = TRUE, tract_fips = NULL) {

  just_numerals <- function(x) !grepl("[^0123456789]", x)

  fips[!just_numerals(fips)] <- NA
  fips[nchar(fips, keepNA = FALSE) == 0] <- NA
  fips[nchar(fips, keepNA = FALSE) == 1] <- paste0("0", fips[nchar(fips, keepNA = FALSE) == 1])
  fips[nchar(fips, keepNA = FALSE) == 3] <- NA
  fips[nchar(fips, keepNA = FALSE) == 4] <- paste0("0", fips[nchar(fips, keepNA = FALSE) == 4])
  fips[nchar(fips, keepNA = FALSE) == 6] <- paste0("0", fips[nchar(fips, keepNA = FALSE) == 6])
  fips[nchar(fips, keepNA = FALSE) == 8] <- NA
  fips[nchar(fips, keepNA = FALSE) == 9] <- NA

  # Resolve the 11-digit tract/blockgroup ambiguity BEFORE promoting 10-digit
  # tracts to 11 (so freshly-promoted values are not re-examined).
  is11 <- nchar(fips, keepNA = FALSE) == 11
  if (any(is11)) {
    fips[is11] <- .disambiguate_11digit_fips(fips[is11],
                                             tract_fips = tract_fips,
                                             quiet = quiet)
  }

  fips[nchar(fips, keepNA = FALSE) == 10] <- paste0("0", fips[nchar(fips, keepNA = FALSE) == 10])
  fips[nchar(fips, keepNA = FALSE) == 13] <- NA
  fips[nchar(fips, keepNA = FALSE) == 14] <- paste0("0", fips[nchar(fips, keepNA = FALSE) == 14])
  fips[nchar(fips, keepNA = FALSE) >= 16] <- NA

  suppressWarnings({ fips[is.na(as.numeric(fips))] <- NA })

  if (!quiet && anyNA(fips)) {
    warning(sum(is.na(fips)),
            " fips had invalid number of characters (digits) or were NA values")
  }
  return(fips)
}


#' Classify a FIPS code as block, blockgroup, tract, city, county, or state
#'
#' Based solely on digit count (after restoring leading zeros). Cannot
#' distinguish a 5-digit ZCTA from a 5-digit county code, or a 5-digit MSA
#' code; downstream callers that also know the SUMLEVEL should prefer it.
#'
#' @param fips character vector of fips codes
#' @returns character vector of fipstype labels, or NULL if input is empty
#' @seealso EJAM::fipstype() for a version that handles 11-char ambiguity
#' @keywords internal
#' @noRd
fipstype_acs <- function(fips) {

  if (length(fips) == 0 || !is.vector(fips) || !is.atomic(fips)) {
    return(NULL)
  }
  ftype <- rep(NA, length(fips))
  suppressWarnings({
    fips <- fips_lead_zero_acs(fips = fips)
  })
  n <- nchar(fips, keepNA = FALSE)
  ftype[n == 15] <- "block"
  ftype[n == 12] <- "blockgroup"
  ftype[n == 11] <- "tract"
  ftype[n == 7]  <- "city"
  ftype[n == 5]  <- "county"  ## 5-digit ZCTAs collide with counties here
  ftype[!is.na(fips) & nchar(fips) == 2] <- "state"

  if (anyNA(ftype)) {
    warning("NA returned for ", sum(is.na(ftype)),
            " fips that do not seem to be block, blockgroup, tract, city/CDP, ",
            "county, or state FIPS (expected widths with leading zeros are ",
            "15, 12, 11, 7, 5, 2 respectively)")
  }
  return(ftype)
}
