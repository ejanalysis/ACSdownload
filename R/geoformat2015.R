#' @name geoformat2015
#' @docType data
#' @title geographic information for 2011-2015 ACS dataset
#' @description This data set has the format used by geographic identifier files in the American Community Survey (ACS) 5-year summary file.
#' @source For the 2011-2015 dataset, \url{http://www2.census.gov/programs-surveys/acs/summary_file/2015}
#'   more specifically on page 12 of 22 in \url{https://www2.census.gov/programs-surveys/acs/summary_file/2015/documentation/tech_docs/2015_SummaryFile_Tech_Doc.pdf}
#'   obtained July 20, 2018.
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
