#' @title Get first part of ACS datafile name.
#' @description Get the first part of the datafile name for the ACS 5-year summary file datafiles on the US Census Bureau FTP site.
#' @param end.year Optional character, such as "2012", specifying last year of 5-year summary file data.
#' @seealso [get_acs_old()], [datafile()], [geofile()], [get.zipfile.prefix()]
#'
get.datafile.prefix	<- function(end.year = acsdefaultendyearhere) {
  validate.end.year(end.year)
  return(paste(end.year, "5", sep = ""))
}
