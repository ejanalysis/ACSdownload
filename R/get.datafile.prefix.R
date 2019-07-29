#' @title Get first part of ACS datafile name.
#' @description Get the first part of the datafile name for the ACS 5-year summary file datafiles on the US Census Bureau FTP site.
#' @param end.year Optional character, such as "2012", specifying last year of 5-year summary file data.
#' @seealso \code{\link{get.acs}}, \code{\link{datafile}}, \code{\link{geofile}}, \code{\link{get.zipfile.prefix}}
#' @export
get.datafile.prefix	<- function(end.year = '2017') {
  return(paste(end.year, "5", sep = ""))
}
