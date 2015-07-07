#' @title Get field names etc for ACS tables
#' @description
#'  Get info on tables from US Census Bureau for American Community Survey 5-year summary file.
#' @param tables Required vector of tables such as "B01001"
#' @param end.year Last year of 5-year summary file such as '2012' (default)
#' @param table.info.only TRUE by default. See \code{\link{get.field.info}}
#' @return data.frame of information about each table and each variable in table. 
#' @seealso \code{\link{get.acs}}, \code{\link{get.table.info}}, \code{\link{get.table.info2}} and \code{\link{get.field.info}}
#' @export
get.table.info2 <- function(tables, end.year='2012', table.info.only=TRUE) {

  if (missing(tables)) {stop('Must specify tables as a vector of character string table IDs, such as B01001')}

  return( get.field.info(tables=tables, end.year=end.year, table.info.only=table.info.only) )

}
