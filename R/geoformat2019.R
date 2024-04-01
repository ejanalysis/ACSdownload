#' @name geoformat2019
#' @docType data
#' @title geographic information for ACS dataset
#' @description This data set has the format used by geographic identifier files 
#'   in the American Community Survey (ACS) 5-year summary file.
#'   The data and documentation for the 5 years ending in year X
#'   is typically available by December of the year X+1, so 2015-2019 was available by Dec 2020.
#' @source Table found in given year dataset, info at
#'  <https://www.census.gov/programs-surveys/acs/library/handbooks/geography.html>
#'  <https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html>
#'  <https://www2.census.gov/programs-surveys/acs/summary_file/2020/data/5_year_entire_sf/2020_ACS_Geography_Files.zip>
#' @keywords datasets
#' @format A data.frame
#'  \preformatted{
#'  'data.frame':	53 obs. of  5 variables:
#'  $ varname    : chr  "FILEID" "STUSAB" "SUMLEVEL" "COMPONENT" ...
#'  $ description: chr  "Always equal to ACS Summary File identification" "State Postal Abbreviation" "Summary Level" "Geographic Component" ...
#'  $ size       : num  6 2 3 2 7 1 1 1 2 2 ...
#'  $ start      : num  1 7 9 12 14 21 22 23 24 26 ...
#'  $ type       : chr  "Record" "Record" "Record" "Record" ...
#'   }
#' @seealso  [get.acs()]
NULL
