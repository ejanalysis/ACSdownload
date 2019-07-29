#' @name geoformat2017
#' @docType data
#' @title geographic information for 2013-2017 ACS dataset
#' @description This data set has the format used by geographic identifier files in the American Community Survey (ACS) 5-year summary file.
#' @source Happens to be the same as the 2016 version of this file. For the 2013-2017 dataset, \url{http://www2.census.gov/programs-surveys/acs/summary_file/2017}
#'   more specifically on pageS 11-12 in \url{https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/tech_docs/2017_SummaryFile_Tech_Doc.pdf}
#' @keywords datasets
#' @format A data.frame
#' \code{
#' 'data.frame':	53 obs. of  5 variables:
#'   $ varname    : chr  "FILEID" "STUSAB" "SUMLEVEL" "COMPONENT" ...
#'   $ description: chr  "Always equal to ACS Summary File identification" "State Postal Abbreviation" "Summary Level" "Geographic Component" ...
#'   $ size       : int  6 2 3 2 7 1 1 1 2 2 ...
#'   $ start      : int  1 7 9 12 14 21 22 23 24 26 ...
#'   $ type       : chr  "Record" "Record" "Record" "Record" ...
#'   }
#' @seealso  \code{\link{get.acs}}
NULL
