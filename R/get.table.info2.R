get.table.info2 <- function(tables, end.year.here='2012') {

  if (missing(tables)) {stop('Must specify tables as a vector of character string table IDs, such as B01001')}

  return( get.field.info(tables=tables, end.year.here=end.year.here, table.info.only=TRUE) )

}
