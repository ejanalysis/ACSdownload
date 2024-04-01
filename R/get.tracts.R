#' @title Get just the Census tracts part of existing ACS data
#' @description Helper function to return just the tract resolution part of a dataset in [get.acs()]
#' @param merged.tables.mine Required set of tables in format used by [get.acs()]
#' @return subset of the inputs, same format
#' @seealso [get.acs()], [get.bg()]
get.tracts <- function(merged.tables.mine) {
  return(merged.tables.mine[merged.tables.mine$SUMLEVEL == "140" ,])
  #	FUNCTION TO split tracts and block groups into 2 files based on SUMLEVEL code 140 or 150
  #rm(merged.tables.mine)
}
