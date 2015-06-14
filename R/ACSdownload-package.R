#' @docType package
#' @title Obtain American Community Survey Summary File Data Tables from Census Bureau FTP Site
#' @name ACSdownload
#' @aliases ACSdownload-package
#' @description 
#'   This R package helps you download and parse raw data from the 
#'   Census Bureau American Community Survey 5-year Summary Files, 
#'   providing demographic data at the block and tract levels of resolution.
#'   You can obtain data from the entire USA all at once using this package, for one or more tables.
#'   Typically the Census Bureau makes it easy to obtain data from one state at a time,
#'   not every block group in the US. There are roughly 220,000 block groups in the US,
#'   and around 74,000 tracts. Other data sources that may be relevant include Census geodatabases at  
#'   \url{http://www.census.gov/geo/maps-data/data/tiger-data.html} and data at 
#'   \url{http://www.census.gov/geo/maps-data/data/gazetteer.html}
#'   \cr\cr
#' @seealso \pkg{acs} package for downloading more modest amounts of ACS data and working with it.
#' @author info@@ejanalysis.com <info@@ejanalysis.com>
#'
#' @references
#'
#' \url{http://ejanalysis.github.io}\cr
#' \url{http://www.ejanalysis.com}\cr
#'
NULL
