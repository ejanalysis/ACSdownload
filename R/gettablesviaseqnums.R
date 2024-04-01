#' @title Look up ACS table IDs of tables in given sequence number files
#' @description Helper function to look for which American Community Survey (ACS) tables are in given sequence files
#'   as obtained from the US Census FTP site.
#' @param x Required character vector of table IDs such as "B01001"
#' @param end.year Optional character variable providing the end year of the 5-year ACS survey,
#'   to ensure the proper sequence file to table ID matching is used.
#' @return Returns a character vector of table IDs such as "B01001"
#' @seealso [read.concat.states()] which uses this, and [get.lookup.acs()] which is used by this
#' @export
gettablesviaseqnums <- function(x, end.year = acsdefaultendyearhere_func()) {
  lookup.acs <- get.lookup.acs(end.year = end.year)
  
  unique(lookup.acs$Table.ID[as.numeric(lookup.acs$Sequence.Number) %in% as.numeric(x)])
}
