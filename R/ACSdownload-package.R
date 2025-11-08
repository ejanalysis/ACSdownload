
#' @title Obtain American Community Survey Summary File Data Tables from Census Bureau FTP Site
#' @name ACSdownload
#' @aliases ACSdownload-package
#' @description
#'   THIS PACKAGE MAY BE MOSTLY OBSOLETE NOW THAT SOME CRAN PACKAGES OFFER MOST OF THESE TOOLS.
#' @import data.table
#' @details
#'
#'  * ACSdownload is an R package that helps you download and
#'  parse huge raw data from the
#'  Census Bureau American Community Survey 5-year Summary Files,
#'  providing demographic data at the block and tract levels of resolution.
#'  You can obtain data from the entire USA all at once using this package,
#'  for one or more tables. Some key functions are [get_acs_old()], [set.needed()], and [nhgis()].
#'  \cr\cr
#'  * The [tidycensus package](https://walker-data.com/tidycensus/index.html)
#'  makes it easy to download some ACS or decennial census or other data,
#'  (once you get a Census Bureau API key to request the data), but
#'  downloading via API is slow/awkward if you want all blockgroups nationwide.
#'  \cr\cr
#'  * Also, there was a package called totalcensus that tried to
#'  offer tools to download ACS5yr tables,
#'  but as of 8/2025 that package had not been updated since 12/2023,
#'  and the late 2023 version did not work out of the box.
#'  The [CRAN version of totalcensus](https://cran.r-project.org/web/packages/totalcensus/index.html)
#'  was older than the [github version of totalcensus](https://github.com/GL-Li/totalcensus)
#'  `devtools::install_github("GL-Li/totalcensus")`
#'  \cr\cr
#'  * The Census Bureau makes it easy to obtain data from one
#'  state at a time, not every block group in the US.
#'  There are over 240,000 block groups and over 85,000 tracts in the U.S. \cr
#'  \cr
#'  HOWEVER, THE DATA FORMAT HAS CHANGED FOR SUMMARY FILE ACS DATA: \cr
#'  (https://www.census.gov/programs-surveys/acs/data/summary-file/updates-to-acs-summary-file.Overview.html) \cr
#'  \cr
#'  Several options for obtaining Census ACS data are now listed here: \cr
#'   (http://www.census.gov/programs-surveys/acs/data.html) \cr
#'   Limits on downloads via American Fact Finder, not all US tracts at once
#'   are noted here: (https://ask.census.gov/faq.php?id=5000&faqId=1653) \cr
#'   Other data sources that may be relevant include Census geodatabases at \cr
#'   (http://www.census.gov/geo/maps-data/data/tiger-data.html) and data at \cr
#'   (http://www.census.gov/geo/maps-data/data/gazetteer.html).
#'
#' @author info@@ejanalysis.com
#' @references
#'  (https://ejanalysis.org) \cr
"_PACKAGE"
NULL
