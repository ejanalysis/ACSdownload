# ---------------------------------------------------------------------------- #
# Geography-name helpers and the convenience wrapper that returns both
# geographies and ACS table data.
#
# These functions read the Census Geos<yr>5YR.txt sidecar file, which lists
# the human-readable names for every geography included in a given vintage's
# table-based summary file release.
# ---------------------------------------------------------------------------- #


#' Read the geography names (and fips/SUMLEVEL) for a Census ACS vintage
#'
#' Downloads the Geos<yr>5YR.txt sidecar from the table-based summary file
#' release, attaches a `fips` column, and optionally filters by a geography
#' type name (e.g. "blockgroup") or a vector of specific fips codes.
#'
#' @param yr end year of the 5-year ACS summary file (e.g. 2024 for the
#'   2020-2024 survey released by Census Bureau Jan. 2026)
#' @param fips one of: a single geography type name ("blockgroup", "tract",
#'   "county", "state", "city", "REGION", "MSA", "CSA", "Urban Area",
#'   "Congressional District", "ZCTA", or
#'   "American Indian Area/Alaska Native Area/Hawaiian Home Land"),
#'   or a vector of specific fips codes, or NULL for no filtering
#' @returns a data.table with columns STUSAB, SUMLEVEL, GEO_ID, fips
#' @keywords internal
get_acs_new_geos <- function(
    yr = acsdefaultendyearhere,
    fips = "blockgroup") {

  url_geos <- paste0(
    "https://www2.census.gov/programs-surveys/acs/summary_file/",
    yr, "/table-based-SF/documentation/Geos", yr, "5YR.txt"
  )
  geos <- data.table::fread(url_geos)

  # Add fips column up front so it can be referenced by the filters below.
  geos[, fips := fips_from_geoid(GEO_ID)]

  if (!is.null(fips)) {
    if (fips[1] %in% .supported_fipstypes()) {
      sumlevel <- sumlevel_from_fipstype(fips)
      geos <- geos[SUMLEVEL %in% sumlevel, ]
    } else {
      fipscodes_requested <- fips
      geos <- geos[fips %in% fipscodes_requested, ]
    }
  }

  geos <- geos[, .(STUSAB, SUMLEVEL, GEO_ID, fips)]
  return(geos)
}


#' Get geography names and ACS 5-year data together
#'
#' Convenience wrapper: calls [get_acs_new()] for the table data and
#' [get_acs_new_geos()] for the geography names, and returns both as a list.
#'
#' @param tables vector of ACS table codes (e.g. c("B01001", "B03002")), or
#'   NULL to use [get_acs_new()]'s default
#' @param fips see [get_acs_new()]
#' @param yr end year of the 5-year ACS summary file
#' @param fiveorone 1 or 5; only 5 is tested
#' @returns list with elements `geos` (a data.table of geography names) and
#'   `dat` (whatever [get_acs_new()] returned)
#' @keywords internal
get_acs_new_both <- function(
    tables = NULL,
    fips = "blockgroup",
    yr = acsdefaultendyearhere,
    fiveorone = 5) {

  if (is.null(tables)) {
    dat <- get_acs_new(fips = fips, yr = yr, fiveorone = fiveorone)
  } else {
    dat <- get_acs_new(fips = fips, yr = yr, fiveorone = fiveorone, tables = tables)
  }
  geos <- get_acs_new_geos(fips = fips, yr = yr)
  return(list(geos = geos, dat = dat))
}
