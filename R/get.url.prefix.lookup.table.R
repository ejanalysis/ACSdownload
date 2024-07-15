#' @title Get URL (without filename) for ACS 5-year summary file data
#'
#' @description Returns first part of URL(s) of folders (on Census Bureau FTP site) with zip file(s) based on end year.
#' @param end.year Optional end year for 5-year summary file, as character, like '2022'
#' @return Returns character element that is first part of URL such as
#'   "https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/"
#' @seealso [get.acs()], [get.lookup.acs()], [get.lookup.file.name()]
#'
get.url.prefix.lookup.table	<- function(end.year = acsdefaultendyearhere_func()) {

  validate.end.year(end.year)

  # url20 = file.path(urlbase, "2020/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt")
  # url21 = file.path(urlbase, "2021/sequence-based-SF/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt")
  # url21 = file.path(urlbase, "2021/table-based-SF/documentation/ACS20215YR_Table_Shells.txt")
  # url22 = file.path(urlbase, "2022/table-based-SF/documentation/ACS20225YR_Table_Shells.txt")

  urlbase = "https://www2.census.gov/programs-surveys/acs/summary_file/"


  if (end.year == 2014) {
    return(
      'http://www2.census.gov/programs-surveys/acs/summary_file/2014/documentation/user_tools/'
    )
  }

  if (end.year < 2021) {
    urlend = "/documentation/user_tools/"
  }
  if (end.year == 2021) {
    urlend <-
      # "/table-based-SF/documentation/"
      "/sequence-based-SF/documentation/user_tools/"
  }
  if (end.year > 2021) {
    urlend = "/table-based-SF/documentation/"
  }

  urlfull = paste0(urlbase, end.year, urlend)

  return(urlfull)
}
