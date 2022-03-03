#' @docType package
#' @title Obtain American Community Survey Summary File Data Tables from Census Bureau FTP Site
#' @name ACSdownload
#' @aliases ACSdownload-package
#' @description
#'   This R package helps you download and parse (huge) raw data from the
#'   Census Bureau American Community Survey 5-year Summary Files,
#'   providing demographic data at the block and tract levels of resolution.
#'   You can obtain data from the entire USA all at once using this package, 
#'     for one or more tables.
#'   Key function is \code{\link{get.acs}}, and 
#'     also see \code{\link{set.needed}}, \code{\link{nhgis}},
#'   and also see data(\link{lookup.acs2019})
#'   HOWEVER, DATA FORMAT IS CHANGING FOR SUMMARY FILE ACS DATA:
#'   SEE \url{https://www.census.gov/programs-surveys/acs/data/summary-file/updates-to-acs-summary-file.Overview.html}
#' @details Typically the Census Bureau makes it easy to obtain data from one state at a time,
#'   not every block group in the US. There are roughly 220,000 block groups in the US,
#'   and around 74,000 tracts.
#'   The key function in this package is \code{\link{get.acs}} \cr\cr
#'   For ACS documentation, see \url{http://www.census.gov/programs-surveys/acs.html} \cr
#'   Several options for obtaining Census ACS data are now listed here: \cr
#'   \url{http://www.census.gov/programs-surveys/acs/data.html} \cr
#'   Limits on downloads via American Fact Finder (not all US tracts at once) 
#'     are noted here: \url{https://ask.census.gov/faq.php?id=5000&faqId=1653} \cr
#'   Other data sources that may be relevant include Census geodatabases at \cr
#'   \url{http://www.census.gov/geo/maps-data/data/tiger-data.html} and data at \cr
#'   \url{http://www.census.gov/geo/maps-data/data/gazetteer.html}. 
#'     Also see the help for \code{\link{get.acs}} \cr\cr
#' @seealso \pkg{\link[tidycensus]{tidycensus}} to use a key to request ACS 
#'   or Decennial Census data, but is slow if you want all blockgroups in a state or nationwide.
#'   \pkg{proxistat} package for block group points (lat lon), or
#'   \pkg{acs} package (\url{http://cran.r-project.org/web/packages/acs/index.html})
#'   which lets one obtain more limited amounts of ACS data
#'   but provides better tools for working with the data once obtained.
#' @author info@@ejanalysis.com <info@@ejanalysis.com>
#' @references
#'  \url{http://ejanalysis.github.io} \cr
#'  \url{http://www.ejanalysis.com} \cr
NULL
