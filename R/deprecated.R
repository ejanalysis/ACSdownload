# ---------------------------------------------------------------------------- #
# Deprecation shims for functions removed in the v3.0.0 refactor.
#
# These exist purely so that callers who upgrade from 2.x get a clear,
# actionable error pointing at the replacement, instead of a bare
# "could not find function" from R. Remove in a future minor release once
# the ecosystem has migrated.
# ---------------------------------------------------------------------------- #


#' Defunct: download ACS data in the pre-2022 sequence-file format
#'
#' `get_acs_old()` and the entire sequence-file code path were removed in
#' ACSdownload 3.0.0. Use [get_acs_new()], which reads the Census Bureau's
#' table-based summary file format (available for end year 2022 and later).
#'
#' If you specifically need the old sequence-file format for an end year of
#' 2021 or earlier, install the final 2.x release:
#' `remotes::install_github("ejanalysis/ACSdownload@v2.4.0-pre-refactor")`.
#'
#' @param ... ignored
#' @returns This function always stops with an error.
#' @keywords internal
#' @export
get_acs_old <- function(...) {
  stop(
    "get_acs_old() was removed in ACSdownload 3.0.0.\n",
    "Use get_acs_new() for end year 2022 and later (the table-based ",
    "summary file format).\n",
    "If you need the pre-2022 sequence-file format, install the final 2.x ",
    "release:\n",
    "  remotes::install_github(\"ejanalysis/ACSdownload@v2.4.0-pre-refactor\")",
    call. = FALSE
  )
}
