#' @title Get first part of ACS datafile name.
#' @description Get the first part of the datafile name for the ACS 5-year summary file datafiles on the US Census Bureau FTP site.
#' @param end.year Optional character, such as "2012", specifying last year of 5-year summary file data.
#' @seealso [get.acs()], [datafile()], [geofile()], [get.zipfile.prefix()]
#' @export
get.datafile.prefix	<- function(end.year = acsdefaultendyearhere_func()) {
  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
  return(paste(end.year, "5", sep = ""))
}
