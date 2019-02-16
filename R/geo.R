#' @name geo
#' @docType data
#' @title downloaded saved geographic information for 5-year summary file ACS dataset ending in given year
#' @description See \code{\link{get.read.geo}}. This data set is a geographic identifier file from the American Community Survey (ACS) 5-year summary file.
#' @source \url{http://www2.census.gov/programs-surveys/acs}
#' @keywords datasets
#' @format A data.frame
#' \code{
#' 'data.frame':	e.g., maybe 294334 obs. of 5  variables: 
#'  $ STUSAB  : chr  "AL" "AL" "AL" "AL" ...
#'  $ SUMLEVEL: chr  "140" "140" "140" "140" ...
#'  $ GEOID   : chr  "14000US01001020100" "14000US01001020200" "14000US01001020300" "14000US01001020400" ...
#'  $ FIPS    : chr  "01001020100" "01001020200" "01001020300" "01001020400" ...
#'  $ KEY     : chr  "al0004656" "al0004657" "al0004658" "al0004659" ...
#'   }
#' @seealso  \code{\link{get.read.geo}}  \code{\link{geofile}}  \code{\link{download.geo}}
NULL
