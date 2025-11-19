#' @title Get first part of ACS zip file name.
#' @description Get the first part of the zipfile name for the ACS 5-year summary file datafiles on the US Census Bureau FTP site.
#' @param end.year Optional character, specifying last year of 5-year summary file data.
#' @seealso [get_acs_old()], [get.datafile.prefix()], [datafile()], [geofile()], [get.zipfile.prefix()]
#'
get.zipfile.prefix	<- function(end.year = acsdefaultendyearhere) {
  return(get.datafile.prefix(end.year = end.year))
}
