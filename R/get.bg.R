#' @title Get just the Census block group part of existing ACS data
#' @description Helper function to return just the block group resolution part of a dataset in [get.acs()]
#' @param merged.tables.mine Required set of tables in format used by [get.acs()]
#' @return subset of the inputs, same format
#' @seealso [get.acs()], [get.tracts()]
get.bg <- function(merged.tables.mine) {
  return(merged.tables.mine[merged.tables.mine$SUMLEVEL == "150" ,])
  #	FUNCTION TO split tracts and block groups into 2 files based on SUMLEVEL code 140 or 150
  #rm(merged.tables.mine)
}
