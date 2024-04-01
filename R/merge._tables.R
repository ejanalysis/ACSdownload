#' @title Concatenate several ACS data tables into one big table
#'
#' @description Concatenate several ACS data tables into one big table
#' @param my.list.of.tables Required list of data tables from prior steps in [get.acs()]
#' @return Returns one big data.frame with all columns of all input tables
#' @seealso [get.acs()]
#' @export
merge_tables <- function(my.list.of.tables) {
  # fields already removed:
  # "STATE", "COUNTY", "TRACT", "BLKGRP", "LOGRECNO"
  # nondata fields remaining (but not at front of table):
  # "KEY"  "STUSAB"       "SUMLEVEL"     "GEOID"        "FIPS"
  dupecols <- c("KEY", "SUMLEVEL", "FIPS", "STUSAB", "GEOID")
  # ASSUME THEY ALL HAVE THE SAME EXACT SET OF KEY VALUES, TO AVOID merge() and just use cbind
  merged.tables <-
    my.list.of.tables[[1]][order(my.list.of.tables[[1]]$KEY), dupecols]
  keycount <- length(merged.tables$KEY)
  
  for (i in 1:length(my.list.of.tables)) {
    if (length(my.list.of.tables[[i]]$KEY) != keycount) {
      stop("Table lengths don't match")
    }
    othercols <-
      names(my.list.of.tables[[i]])[!(names(my.list.of.tables[[i]]) %in% dupecols)]
    merged.tables <-
      cbind(merged.tables, my.list.of.tables[[i]][order(my.list.of.tables[[i]]$KEY) , othercols])
  }
  return(merged.tables)
  gc()
}
