#' @title Get URL prefix for folder(s) with ACS 5-year summary file data
#'
#' @description Returns part of URL of folders (on Census Bureau site) with zip file(s) based on end year.
#' @param end.year Optional end year for 5-year summary file, as character, but ignored if url.prefix is specified
#' @return Returns character vector that is first part of URL such as
#'      # [1] "https://www2.census.gov/programs-surveys/acs/summary_file/2021/data/5_year_seq_by_state/2020/Tracts_Block_Groups_Only"
#'  https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only
#'   "ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset"
#' @seealso [get.acs()], [url.to.find.zipfile()], [download.geo()]
#' @examples browseURL(get.url.prefix(2022))
#'
get.url.prefix <- function(end.year = acsdefaultendyearhere_func()) {

  validate.end.year(end.year)

  if (end.year == 2014) {
    return(
      'http://www2.census.gov/programs-surveys/acs/summary_file/2014/data/5_year_seq_by_state/'
    )
  }
  if (end.year %in% 2015:2020) {
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
  if (end.year == 2021) {
    return(
        # https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only/
        "https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/"
    )
  }
  if (end.year == 2022) {
    return(
      #### for 2022, geo and data are in separate folders, unlike earlier years....
        # https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/Geos20225YR.txt   is a new location /format for 2022.
        # https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/data/5YRData/acsdt5y2022-b01001.dat  is a new format for 2022.
        "https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/data/5YRData/"
    )
  }
}
