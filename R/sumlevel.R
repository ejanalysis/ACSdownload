# ---------------------------------------------------------------------------- #
# Conversions between Census SUMLEVEL codes and human-readable fipstype names.
#
# These two functions are inverses of each other and are the canonical place
# to look up the supported geography types.
# ---------------------------------------------------------------------------- #


#' Get the SUMLEVEL code (e.g. "040", "150") from a fipstype string (e.g.
#' "state", "blockgroup")
#'
#' SUMLEVEL strings extracted from a Census GEO_ID are always 3 characters
#' (e.g. "020", "040", "150"), so this function returns 3-character strings
#' to match that width.
#'
#' Supported types (case-insensitive): state, county, city, tract,
#' blockgroup, REGION, American Indian Area/Alaska Native Area/Hawaiian
#' Home Land, MSA, CSA, Urban Area, Congressional District, ZCTA.
#' The "block" type has no Census SUMLEVEL and returns NA.
#'
#' @param ftype character vector of fipstype strings; case-insensitive
#' @returns character vector of 3-character SUMLEVEL codes, NA for unsupported
#' @seealso [fipstype_from_sumlevel()]
#'
#' Census reference: <https://www.census.gov/programs-surveys/acs/geography-acs/reference-materials.2023.html>
#' (ACS_2023_5-Year_Geocount file).
#'
#' @export
sumlevel_from_fipstype <- function(ftype) {

  ftype <- tolower(ftype)
  sumlevel <- rep(NA, length(ftype))

  sumlevel[ftype %in% "state"]      <- "040"
  sumlevel[ftype %in% "county"]     <- "050"
  sumlevel[ftype %in% "city"]       <- "160"
  sumlevel[ftype %in% "tract"]      <- "140"
  sumlevel[ftype %in% "blockgroup"] <- "150"

  sumlevel[ftype %in% tolower("REGION")] <- "020"
  sumlevel[ftype %in% tolower("American Indian Area/Alaska Native Area/Hawaiian Home Land")] <- "250"
  sumlevel[ftype %in% tolower("MSA")] <- "310"
  sumlevel[ftype %in% tolower("CSA")] <- "330"
  sumlevel[ftype %in% tolower("Urban Area")] <- "400"
  sumlevel[ftype %in% tolower("Congressional District")] <- "500"
  sumlevel[ftype %in% tolower("ZCTA")] <- "860"

  # "block" has no Census SUMLEVEL; leave as NA.
  sumlevel[ftype %in% "block"] <- NA

  return(sumlevel)
}


#' Convert SUMLEVEL codes (e.g. "040", "150") to fipstype strings (e.g.
#' "state", "blockgroup")
#'
#' Inverse of [sumlevel_from_fipstype()]. Accepts SUMLEVEL as character or
#' numeric. Returns NA for codes the package does not recognize.
#'
#' @param sumlevel character or numeric vector of SUMLEVEL codes
#' @returns character vector of fipstype strings
#' @seealso [sumlevel_from_fipstype()]
#'
#' @export
fipstype_from_sumlevel <- function(sumlevel) {

  x <- rep(NA, length(sumlevel))
  sumlevel <- as.numeric(sumlevel)

  x[sumlevel %in% 40]  <- "state"
  x[sumlevel %in% 50]  <- "county"
  x[sumlevel %in% 160] <- "city"
  x[sumlevel %in% 140] <- "tract"
  x[sumlevel %in% 150] <- "blockgroup"

  x[sumlevel %in% 20]  <- "REGION"
  x[sumlevel %in% 250] <- "American Indian Area/Alaska Native Area/Hawaiian Home Land"
  x[sumlevel %in% 310] <- "MSA"
  x[sumlevel %in% 330] <- "CSA"
  x[sumlevel %in% 400] <- "Urban Area"
  x[sumlevel %in% 500] <- "Congressional District"
  x[sumlevel %in% 860] <- "ZCTA"

  return(x)
}


#' Vector of geography type names that `get_acs_new()` recognizes as a
#' single-type "fips" argument (case-sensitive on call sites).
#'
#' Centralized so that get_acs_new() and get_acs_new_geos() cannot drift
#' out of sync.
#'
#' @keywords internal
#' @noRd
.supported_fipstypes <- function() {
  c("block", "blockgroup", "tract", "city", "county", "state",
    "REGION", "American Indian Area/Alaska Native Area/Hawaiian Home Land",
    "MSA", "CSA", "Urban Area", "Congressional District", "ZCTA")
}
