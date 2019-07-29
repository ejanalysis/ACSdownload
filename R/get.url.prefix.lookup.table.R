#' @title Get first part of name(s) of URL(s) for ACS 5-year summary file data
#'
#' @description Returns first part of URL(s) of folders (on Census Bureau FTP site) with zip file(s) based on end year.
#' @param end.year Optional end year for 5-year summary file, as character, like '2018'
#' @return Returns character element that is first part of URL such as "ftp://ftp.census.gov/acs2012_5yr/summaryfile/"
#' @seealso \code{\link{get.acs}}, \code{\link{get.lookup.acs}}, \code{\link{get.lookup.file.name}}
#' @export
get.url.prefix.lookup.table	<- function(end.year = '2017') {
  #if (end.year < 2009) {stop('Years prior to 2009 are not valid. ACS 5-year file was not available until 2005-2009, end.year=2009.')}
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
