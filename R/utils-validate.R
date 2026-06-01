# ---------------------------------------------------------------------------- #
# Input validators used by get_acs_new() and friends. Centralizing them means:
#   * we fail fast with a useful error before any HTTP call
#   * the rules are documented in one place
#   * tests can exercise each rule without spinning up downloads.
# ---------------------------------------------------------------------------- #


#' Validate the vector of ACS table codes
#'
#' Census ACS table codes are an uppercase letter (`B` or `C`), five digits,
#' an optional race/ethnicity suffix letter (A-I), and an optional `PR`
#' suffix for the Puerto Rico Community Survey variants (e.g. `B05001PR`,
#' `B06004APR`). This validator normalizes input to uppercase character and
#' rejects anything that does not match the canonical pattern.
#'
#' @param tables character vector of table codes
#' @returns the uppercased character vector
#' @keywords internal
#' @noRd
validate_acs_tables <- function(tables) {
  if (length(tables) == 0L) {
    stop("`tables` must contain at least one ACS table code")
  }
  tables <- as.character(tables)
  if (anyNA(tables) || any(nchar(tables) == 0L)) {
    stop("`tables` cannot contain NA or empty strings")
  }
  # B/C, 5 digits, optional race suffix (A-I), optional Puerto Rico suffix (PR).
  bad <- !grepl("^[BC][0-9]{5}[A-I]?(PR)?$", toupper(tables))
  if (any(bad)) {
    stop("invalid ACS table code(s): ",
         paste(tables[bad], collapse = ", "),
         "\nExpected pattern: B or C followed by 5 digits, an optional ",
         "race suffix A-I, and an optional Puerto Rico suffix PR ",
         "(e.g. \"B01001\", \"C16001\", \"B03002H\", \"B05001PR\", ",
         "\"B06004APR\")")
  }
  toupper(tables)
}


#' Validate the `fiveorone` argument
#'
#' Accepts character or numeric scalar 1 or 5; only 5 is well tested.
#' Returns the value as a length-1 character.
#'
#' @param fiveorone scalar 1 or 5
#' @returns length-1 character "1" or "5"
#' @keywords internal
#' @noRd
validate_fiveorone <- function(fiveorone) {
  if (length(fiveorone) != 1L) {
    stop("`fiveorone` must be a single value, got length ", length(fiveorone))
  }
  x <- as.character(fiveorone)
  if (!x %in% c("1", "5")) {
    stop("`fiveorone` must be 1 or 5, got: ", deparse(fiveorone))
  }
  x
}


#' Validate (and normalize) the `fips` argument shape
#'
#' Permits one of three shapes:
#'   * `NULL`                        -- no row filtering
#'   * a single recognized type name -- single-string from `.supported_fipstypes()`
#'   * a vector of fips codes         -- numeric or character; all one geography
#'     type (same canonical width)
#'
#' For a vector of fips codes this returns the codes with canonical Census
#' widths restored (e.g. numeric `1001` becomes `"01001"`), so the downstream
#' `fips %in% ...` filter in [get_acs_new()] matches the GEO_ID-derived fips
#' (which always carry their leading zeros).
#'
#' Mixing a type-name string with fips codes (e.g.
#' `c("blockgroup", "010010201001")`) is rejected.
#'
#' @param fips the user-supplied `fips` argument
#' @returns `NULL`, the type name unchanged, or the normalized fips vector
#' @keywords internal
#' @noRd
validate_fips_arg <- function(fips) {

  if (is.null(fips)) return(fips)

  # Coerce non-character input safely. as.character() switches to scientific
  # notation for some numerics (e.g. as.character(100000) == "1e+05"), which
  # would corrupt a fips code; format(scientific = FALSE) avoids that.
  if (!is.character(fips)) {
    fips <- format(fips, scientific = FALSE, trim = TRUE)
  }

  is_type_name <- fips %in% .supported_fipstypes()
  if (any(is_type_name)) {
    if (!all(is_type_name)) {
      stop("`fips` mixes a known geography type name with other values; ",
           "pass either a single type name (e.g. \"blockgroup\") OR a ",
           "vector of fips codes, not both.")
    }
    if (length(fips) > 1L) {
      stop("can get only one type of geography / sumlevel at a time, ",
           "such as 'blockgroup'")
    }
    return(fips)
  }

  # Vector of fips codes: must be all numeric digits ...
  bad <- !grepl("^[0-9]+$", fips)
  if (any(bad)) {
    stop("`fips` contains values that are neither a recognized geography ",
         "type name nor numeric fips codes: ",
         paste(utils::head(unique(fips[bad]), 5), collapse = ", "),
         if (sum(bad) > 5) ", ..." else "")
  }

  # ... and are normalized to canonical Census widths. Numeric fips that lost
  # their leading zeros (e.g. 1001 -> "01001" for an Alabama county) must be
  # restored here, or the get_acs_new() filter would compare "1001" to the
  # GEO_ID-derived "01001" and return zero rows. fips_lead_zero_acs() also
  # NA-flags impossible widths (3, 8, 9, 13, ...). Suppress its 11-character
  # ambiguity warning -- tract-level pulls are legitimately 11 characters.
  normalized <- suppressWarnings(fips_lead_zero_acs(fips, quiet = TRUE))
  if (any(is.na(normalized))) {
    stop("`fips` contains codes with an invalid number of digits (after ",
         "restoring leading zeros): ",
         paste(utils::head(unique(fips[is.na(normalized)]), 5), collapse = ", "),
         ". Valid Census fips widths are 2 (state), 5 (county), 7 (place/city), ",
         "11 (tract), 12 (blockgroup), 15 (block).")
  }
  fips <- normalized

  # All codes must be one geography type (same width). A mix of widths
  # (e.g. a 5-digit county and an 11-digit tract) would otherwise pass through
  # to get_acs_new(), which filters every matching SUMLEVEL and, with the
  # default return_list_not_merged = TRUE, would hand back a table mixing
  # geography levels. Check this AFTER normalization so leading-zero loss in
  # only some codes (e.g. c("1001", "01001")) does not look like a mix.
  widths <- unique(nchar(fips))
  if (length(widths) > 1L) {
    stop("`fips` mixes codes of differing widths (",
         paste(sort(widths), collapse = ", "),
         " characters), which implies more than one geography type. ",
         "Request one geography type at a time: pass fips codes that are ",
         "all the same length (e.g. all 5-digit county or all 12-digit ",
         "blockgroup codes), or a single type name such as \"blockgroup\".")
  }
  fips
}
