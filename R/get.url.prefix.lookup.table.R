#' @title Get first part of name(s) of URL(s) for ACS 5-year summary file data
#'
#' @description Returns first part of URL(s) of folders (on Census Bureau FTP site) with zip file(s) based on end year.
#' @param end.year Optional end year for 5-year summary file, as character, like '2018'
#' @return Returns character element that is first part of URL such as "ftp://ftp.census.gov/acs2012_5yr/summaryfile/"
#' @seealso [get.acs()], [get.lookup.acs()], [get.lookup.file.name()]
#' @export
get.url.prefix.lookup.table	<- function(end.year = acsdefaultendyearhere_func()) {
  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
  if (end.year == 2014) {
    return(
      'http://www2.census.gov/programs-surveys/acs/summary_file/2014/documentation/user_tools/'
    )
  }
  return(paste(
    "https://www2.census.gov/programs-surveys/acs/summary_file/",
    end.year,
    "/documentation/user_tools/",
    sep = ""
  ))
}
