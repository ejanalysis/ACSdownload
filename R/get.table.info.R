#' @title Obsolete/ older version of get.table.info2
#' @description
#'  Get info on tables from US Census Bureau for American Community Survey 5-year summary file.
#' @param tables Required vector of tables such as "B01001"
#' @param end.year Last year of 5-year summary file such as '2012' (default)
#' @param table.info.only TRUE by default. See \code{\link{get.field.info}}
#' @param moe FALSE by default. If TRUE, returns MOE versions of field names and descriptions.
#' @return data.frame of information about each table and each variable in table.
#' @return data.frame of information about each table and each variable in table: \cr
#'   Table.ID, Line.Number, Table.Title, table.var, varname2 \cr\cr
#'     # Value returned is data.frame of info about each table and also each variable in the table:\cr
#'
#'         Table.ID Line.Number                                                 Table.Title  table.var                                           varname2\cr
#'   7       B01001          NA                                                  SEX BY AGE       <NA>                                           SEXBYAGE\cr
#'   8       B01001          NA                                 Universe:  Total population       <NA>                            UniverseTotalpopulation\cr
#'   9       B01001           1                                                      Total: B01001.001                                              Total\cr
#'   10      B01001           2                                                       Male: B01001.002                                               Male\cr
#' @seealso \code{\link{get.acs}}, \code{\link{get.table.info}}, \code{\link{get.table.info2}} and \code{\link{get.field.info}}
#' @export
get.table.info <- function(tables, end.year="2012", table.info.only=TRUE, moe=FALSE) {

  return( get.table.info2(tables = tables, end.year = end.year, table.info.only = table.info.only, moe = moe) )

  if (1==0) {
    # old code archived:
    if (!exists("lookup.acs")) { lookup.acs <- get.lookup.acs(end.year) }
    table.info	<- lookup.acs[lookup.acs$Table.ID %in% tables, c("Table.ID", "Line.Number", "Table.Title")]
    table.info$table.var	<- NA
    table.info$table.var[!is.na(table.info$Line.Number)]	<- with(table.info, paste(Table.ID, analyze.stuff::lead.zeroes(Line.Number, 3), sep="."))[!is.na(table.info$Line.Number)]

    # clean up field by removing spaces and colons and escaped quotation marks etc.
    table.info$varname2 <- gsub("[ :,()']", "", table.info$Table.Title)
    table.info$varname2 <- gsub("\"", "", table.info$varname2)

    return(table.info)
  }
}
