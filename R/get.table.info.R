######################################
#	R CODE TO OBTAIN AND WORK WITH CENSUS BUREAU'S AMERICAN COMMUNITY SURVEY (ACS) 5-YEAR SUMMARY FILE DATA
#	2013-12-12
######################################

get.table.info <- function(tables.mine, end.year.here="2012") {

  # Value returned is data.frame of info about each table and also each variable in the table:
  #
  #         Table.ID Line.Number                                                 Table.Title  table.var                                           varname2
  #   7       B01001          NA                                                  SEX BY AGE       <NA>                                           SEXBYAGE
  #   8       B01001          NA                                 Universe:  Total population       <NA>                            UniverseTotalpopulation
  #   9       B01001           1                                                      Total: B01001.001                                              Total
  #   10      B01001           2                                                       Male: B01001.002                                               Male
  #   ...
  
  if (!exists("lookup.acs")) { lookup.acs <- get.lookup.acs(end.year.here) }
  table.info	<- lookup.acs[lookup.acs$Table.ID %in% tables.mine, c("Table.ID", "Line.Number", "Table.Title")]
  table.info$table.var	<- NA
  table.info$table.var[!is.na(table.info$Line.Number)]	<- with(table.info, paste(Table.ID, lead.zeroes(Line.Number, 3), sep="."))[!is.na(table.info$Line.Number)]

  # clean up field by removing spaces and colons and escaped quotation marks etc.
  table.info$varname2 <- gsub("[ :,()']", "", table.info$Table.Title)
  table.info$varname2 <- gsub("\"", "", table.info$varname2)
  
  
  
  return(table.info)
}
