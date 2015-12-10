#' @name geoformat2014
#' @docType data
#' @title geographic information for 2010-2014 ACS dataset
#' @description This data set has the format used by geographic identifier files in the American Community Survey (ACS) 5-year summary file.
#' @source For the 2010-2014 dataset, \url{http://www2.census.gov/programs-surveys/acs/summary_file/2014}
#'   obtained December 3, 2015.
#' @keywords datasets
#' @format A data.frame
#' \code{
#' 'data.frame':	53 obs. of  3 variables:
#'   $ varname: chr  "FILEID" "STUSAB" "SUMLEVEL" "COMPONENT" ...
#'   $ size   : num  6 2 3 2 7 1 1 1 2 2 ...
#'   $ start  : num  1 7 9 12 14 21 22 23 24 26 ...
#'   }
#' @seealso  \code{\link{get.acs}}
NULL
