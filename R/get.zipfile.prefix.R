#' @title Get first part of ACS zip file name.
#' @description Get the first part of the zipfile name for the ACS 5-year summary file datafiles on the US Census Bureau FTP site.
#' @param end.year Optional character, specifying last year of 5-year summary file data.
#' @seealso \code{\link{get.acs}}, \code{\link{get.datafile.prefix}}, \code{\link{datafile}}, \code{\link{geofile}}, \code{\link{get.zipfile.prefix}}
#' @export
get.zipfile.prefix	<- function(end.year = '2019') {
  return(get.datafile.prefix(end.year = end.year))
}
