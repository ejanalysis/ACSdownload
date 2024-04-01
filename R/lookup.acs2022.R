#' @name lookup.acs2022
#' @docType data
#' @title ACS_5yr_Seq_Table_Number_Lookup.txt for ACS dataset
#' @details
#'   WORK IN PROGRESS BECAUSE  Formats available changed! 
#'   
#'   ACS2018-2022 does not offer sequence file style downloads.
#'   Now available only by table, requiring a different approach to download
#'   data.
#'   The format of the lookup.acs2022 file is new so the older code 
#'   for prior years will not work.
#'   
#'     lookup.acs2022 <- read.delim("ACSdownload/inst/ACS20225YR_Table_Shells.txt", sep = "|")
#'     
#'     usethis::use_data(lookup.acs2022)
#'   
#'   See [https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/]
#' @seealso [lookup.acs] and  [acs::acs.lookup()] [tidycensus::load_variables()] [get.lookup.acs()] [get.acs()]
NULL
