#' Build data.census.gov URLs for one or more ACS 5-year tables
#'
#' Produces URLs to either general information about a table or a
#' table-for-fips view.
#'
#' @param tables one or more table codes like "B01001" or c("B01001", "C17002")
#' @param fips optional vector of fips codes such as "34023001419"; NULL or
#'   empty string means "just the general info URL for each table"
#' @param yr end year of the 5-year ACS summary file
#' @param fiveorone 1 or 5
#' @returns character vector of URLs, one per (table x fips) pair
#' @examples
#'   url_acs_table()
#'   # browseURL(url_acs_table(tables = "C17002", yr = 2024))
#' @seealso `EJAM::url_acs_table_info()` for a richer EJSCREEN-aware variant
#' @export
url_acs_table <- function(tables = ejscreen_acs_tables,
                          fips = NULL,
                          yr = acsdefaultendyearhere,
                          fiveorone = 5) {

  if (is.null(fips) || any(nchar(fips) == 0)) {
    urls <- paste0("https://data.census.gov/table/ACSDT",
                   fiveorone, "Y", yr, ".", tables)
  } else {
    # Pick a SUMLEVEL based on the fips type. Only blockgroup and tract are
    # mapped here -- those are the resolutions data.census.gov accepts in
    # this URL form. Other fipstypes fall through with NA, which produces a
    # broken URL on purpose to surface unsupported callers.
    ftype <- fipstype_acs(fips)
    sumlevel <- ftype
    sumlevel[ftype %in% "blockgroup"] <- 150
    sumlevel[ftype %in% "tract"]      <- 140

    urls <- paste0("https://data.census.gov/table?q=", tables,
                   "&g=", sumlevel, "0000US", fips, "&y=", yr)
  }
  return(urls)
}
