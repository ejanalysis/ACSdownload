# ---------------------------------------------------------------------------- #
# Package-level defaults for which ACS 5-year vintage to target by default,
# plus a self-contained estimator used when EJAM is not installed.
# ---------------------------------------------------------------------------- #


#' Default end year of 5-year ACS datasets this package targets
#'
#' Used as the default for `yr` arguments throughout the package. Update via
#' the script in `data-raw/datacreate_acsdefaultendyearhere.R` after each new
#' Census Bureau release.
#'
#' See ACS release news:
#'   * 2020-2024 (released January 29, 2026): <https://www.census.gov/programs-surveys/acs/news/data-releases/2024/release-schedule.html>
#'   * 2019-2023 (released December 12, 2024): <https://www.census.gov/programs-surveys/acs/news/data-releases/2023/release.html>
#'
#' @docType data
#' @name acsdefaultendyearhere
NULL


#' Earliest end year of 5-year ACS datasets `get_acs_new()` can target
#'
#' The table-based summary file format was introduced for the 2018-2022
#' vintage, so the floor is 2022.
#'
#' @docType data
#' @keywords internal
#' @name acsfirstyearavailablehere
NULL


#' Estimate the latest ACS 5-year end year Census Bureau has published
#'
#' Mirrors the `guess_census_has_published = TRUE` branch of
#' [EJAM::acs_endyear()]. Prefers `EJAM::acs_endyear()` when the EJAM
#' package is installed, falling back to a self-contained estimator that
#' uses the typical Census release lag (~1 year after the survey period
#' ends) and the known release dates of recent vintages.
#'
#' Use this when you want today's "best guess" of which vintage's
#' `summary_file/<yr>/` directory should exist on www2.census.gov.
#'
#' @param guess_as_of optional `Date` to estimate as-of; defaults to today
#' @returns a single character year like `"2024"` for the 2020-2024 ACS
#'   5-year survey
#' @seealso `EJAM::acs_endyear()`
#' @export
acs_endyear_like_ejam <- function(guess_as_of = Sys.Date()) {

  # Prefer EJAM's own estimator when EJAM is installed AND it provides
  # acs_endyear(). We resolve it dynamically from EJAM's namespace (rather
  # than via EJAM::acs_endyear) because some EJAM builds keep acs_endyear
  # unexported -- the dynamic lookup works either way, and avoids a hard
  # dependency on it being exported. Falls through to the local estimator
  # otherwise.
  if (requireNamespace("EJAM", quietly = TRUE) &&
      exists("acs_endyear", envir = asNamespace("EJAM"), inherits = FALSE)) {
    ejam_acs_endyear <- get("acs_endyear", envir = asNamespace("EJAM"))
    out <- tryCatch(
      as.character(ejam_acs_endyear(
        guess_as_of = guess_as_of,
        guess_census_has_published = TRUE
      )),
      error = function(e) NULL
    )
    if (!is.null(out)) return(out)
  }

  # Self-contained estimator. Tracks the actual release dates Census Bureau
  # has published for recent vintages; for any date after the last known
  # release, fall back to "previous-end-year + typical lag" math.
  if (!inherits(guess_as_of, "Date")) {
    guess_as_of <- tryCatch(as.Date(guess_as_of),
                            error = function(e) Sys.Date())
  }

  # Known Census-published releases (most-recent first). Add new entries
  # here as Census announces them.
  known <- data.frame(
    release_date = as.Date(c("2026-01-29", "2024-12-12", "2023-12-07",
                             "2022-12-08", "2021-12-09")),
    end_year     = c("2024", "2023", "2022", "2021", "2020"),
    stringsAsFactors = FALSE
  )

  hits <- known[known$release_date <= guess_as_of, , drop = FALSE]
  if (nrow(hits) > 0) {
    return(hits$end_year[which.max(hits$release_date)])
  }

  # Pre-2021 fallback: typical lag was ~12 months from end-of-survey to release.
  approx_end_year <- as.integer(format(guess_as_of, "%Y")) - 2L
  as.character(approx_end_year)
}


#' Validate that the requested ACS end year is one this package can target
#'
#' Centralized check used by [get_acs_new()] and related functions. Accepts
#' character or numeric inputs in the range
#' `[acsfirstyearavailablehere, current_year + 1]` and returns the year as
#' a length-1 character string. Stops on invalid input.
#'
#' @param yr requested ACS end year
#' @returns length-1 character year
#' @keywords internal
#' @noRd
validate_acs_endyear <- function(yr) {

  if (length(yr) != 1L || is.na(yr)) {
    stop("`yr` must be a single non-NA value, got: ", deparse(yr))
  }
  yr_chr <- as.character(yr)
  yr_num <- suppressWarnings(as.integer(yr_chr))
  if (is.na(yr_num)) {
    stop("`yr` must be parseable as an integer year, got: ", deparse(yr))
  }

  floor_yr <- tryCatch(as.integer(acsfirstyearavailablehere),
                       error = function(e) 2022L)
  ceiling_yr <- as.integer(format(Sys.Date(), "%Y")) + 1L

  if (yr_num < floor_yr || yr_num > ceiling_yr) {
    stop("`yr` ", yr_num, " is outside the supported range [",
         floor_yr, ", ", ceiling_yr, "]. The table-based summary file ",
         "format starts at ", floor_yr, ".")
  }
  yr_chr
}
