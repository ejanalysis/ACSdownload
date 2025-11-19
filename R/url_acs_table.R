
#' get URL(s) of ACS 5-year table(s) for general info or for FIPS code(s) (blockgroup or tract) at census.gov
#'
#' @param tables "C16002" or c("B01001","C17002") for example
#' @param fips "34023001419" for example (or NULL or "" for general info)
#' @param yr 2023 for example
#' @param fiveorone can be 1 or 5
#' @examples url_acs_table()
#'   # browseURL(url_acs_table(tables = "C17002", yr = 2022))
#'   # Census 2020 tables are at e.g., "https://data.census.gov/table/DECENNIALPL2020.P1"
#' @returns one or more urls, as character vector
#'
#' @export
#'
url_acs_table <- function(tables = ejscreen_acs_tables, fips = NULL, yr = acsdefaultendyearhere, fiveorone=5) {

  if (is.null(fips) || any(nchar(fips) == 0)) {
    # just general info on the table(s)
    urls <- paste0("https://data.census.gov/table/ACSDT", fiveorone,"Y", yr, ".", tables)

  } else {
    ######################################## #
    # ftype <- EJAM::fipstype(fips) # or...
    ftype <- fipstype_simplified(fips)
    ######################################## #
    sumlevel <- ftype
    sumlevel[ftype %in% "blockgroup"] <- 150
    sumlevel[ftype %in% "tract"] <- 140

    urls <- paste0("https://data.census.gov/table?q=", tables,"&g=", sumlevel,"0000US", fips,"&y=", yr)
  }
  return(urls)
}
####################################### ######################################## #
fipstype_simplified = function(fips) {
  # for a more robust version of this function see EJAM::fipstype() that handles 11-character case correctly
  ftype <- rep(NA, length(fips))
  fips <- fips_lead_zero_simplified(fips = fips) # fips <- EJAM::fips_lead_zero(fips = fips) # cleans them so each is NA or a valid nchar() string
  n <- nchar(fips, keepNA = FALSE)
  ftype[n == 15] <- "block"
  ftype[n == 12] <- "blockgroup"
  ftype[n == 11] <- "tract" ## once correctly added the leading zero if approp.
  ftype[n ==  7] <- "city" ## a place/city/town/CDP/etc. as in censusplaces$placename or $fips  # e.g, 5560500 is Oshkosh, WI
  ftype[n ==  5] <- "county"
  ftype[!is.na(fips) & nchar(fips) ==  2] <- "state"
  return(ftype)
}
####################################### ######################################## #
fips_lead_zero_simplified = function(fips)  {
  # for a more robust version of this function see EJAM::fips_lead_zero() that handles 11-character case correctly
  fips[nchar(fips, keepNA = FALSE) == 0]	<- NA
  fips[nchar(fips, keepNA = FALSE) == 1]	<- paste0("0", fips[nchar(fips, keepNA = FALSE) == 1])
  fips[nchar(fips, keepNA = FALSE) == 3]	<- NA
  fips[nchar(fips, keepNA = FALSE) == 4]	<- paste0("0", fips[nchar(fips, keepNA = FALSE) == 4])
  fips[nchar(fips, keepNA = FALSE) == 6]	<- paste0("0", fips[nchar(fips, keepNA = FALSE) == 6])
  fips[nchar(fips, keepNA = FALSE) == 8]	<- NA
  fips[nchar(fips, keepNA = FALSE) == 9]	<- NA

  # 11  AMBIGUOUS CASE:  tract with all 11 digits OR  blockgroup with missing zero and hence not 12   !
  #    if it is the former, we would want to leave it alone - assumed that here
  #    if it is the latter, we would want to add a leading zero here !! for a more robust version of this function see EJAM::fips_lead_zero()

  fips[nchar(fips, keepNA = FALSE) == 10]	<- paste0("0", fips[nchar(fips, keepNA = FALSE) == 10])
  fips[nchar(fips, keepNA = FALSE) == 13]	<- NA
  fips[nchar(fips, keepNA = FALSE) == 14]	<- paste0("0", fips[nchar(fips, keepNA = FALSE) == 14])
  fips[nchar(fips, keepNA = FALSE) >= 16]	<- NA
  suppressWarnings({fips[is.na(as.numeric(fips))] <- NA})
  return(fips)
}
####################################### ######################################## #
