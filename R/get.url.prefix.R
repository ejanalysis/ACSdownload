#' @title Get URL prefix for FTP site folder(s) with ACS 5-year summary file data
#'
#' @description Returns part of URL of folders (on Census Bureau FTP site) with zip file(s) based on end year.
#' @param end.year Optional end year for 5-year summary file, as character, but ignored if url.prefix is specified
#' @return Returns character vector that is first part of URL such as "ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset"
#' @seealso \code{\link{get.acs}}, \code{\link{url.to.find.zipfile}}, \code{\link{download.geo}}
#' @export
get.url.prefix <- function(end.year = '2019') {
  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(2009:(thisyear - 1)))) {stop('end.year must be a plausible year such as 2017')}
  
  if (end.year == 2014) {
    return(
      'http://www2.census.gov/programs-surveys/acs/summary_file/2014/data/5_year_seq_by_state/'
    )
  } else {
    return(
      paste(
        "https://www2.census.gov/programs-surveys/acs/summary_file/",
        #  https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/geography/5yr_year_geo/
        end.year,
        "/data/5_year_seq_by_state",
        sep = ""
      )
    )
    
  }
}
