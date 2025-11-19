
#' @title Download American Community Survey (ACS) 5-year Data Tables from Census Bureau nationwide in bulk
#' @name ACSdownload
#' @aliases ACSdownload-package
#' @description
#'    Download and parse raw data from the
#'    Census Bureau American Community Survey (ACS) 5-year survey, to get
#'    demographic data in bulk (without relying on the API).
#'    You can obtain data from the entire USA all at once (or selected FIPS), for one or more tables.
#'    This package is focused on blockgroup and tract levels of resolution.
#' @import data.table
#' @details
#'
#'  * ACSdownload is an R package that helps you download and
#'  parse large amounts of raw data from the
#'  Census Bureau American Community Survey 5-year datasets,
#'  providing demographic data at the blockgroup and tract levels of resolution.
#'  You can obtain data from the entire USA all at once using this package,
#'  for one or more tables.
#'
#'  The key function is [get_acs_new()] for ACS 2018-2022, 2019-2023, or 2020-2024.
#'
#'  For older data, which was offered in summary file sequence files not by table, see [get_acs_old()].
#'
#'  * The Census Bureau makes it easy to obtain data from one
#'  state at a time, not every block group in the US.
#'  There are over 240,000 block groups and over 85,000 tracts in the U.S.
#'
#'  * The [tidycensus package](https://walker-data.com/tidycensus/index.html)
#'  is an alternative that makes it easy to download modest amounts of ACS or decennial census or other data,
#'  (once you get a Census Bureau API key to request the data), but
#'  downloading via API is slow/awkward if you want all blockgroups nationwide for multiple tables.
#'
#'  * Also, there was a package called totalcensus that tried to
#'  offer tools to download ACS5yr tables,
#'  but as of 8/2025 that package had not been updated since 12/2023,
#'  and the late 2023 version did not work out of the box.
#'  The [CRAN version of totalcensus](https://cran.r-project.org/web/packages/totalcensus/index.html)
#'  was older than the [github version of totalcensus](https://github.com/GL-Li/totalcensus)
#'  `devtools::install_github("GL-Li/totalcensus")`
#'
#'  For 5-year data ending with year 2022, the DATA FORMAT HAS CHANGED FOR SUMMARY FILE ACS DATA.
#'  See <https://www.census.gov/programs-surveys/acs/data/summary-file/updates-to-acs-summary-file.Overview.html>
#'
#'  Several other options for obtaining Census ACS data are listed here:
#'
#'   <http://www.census.gov/programs-surveys/acs/data.html>
#'
#'   Limits on downloads via American Fact Finder, not all US tracts at once
#'   are noted here: <https://ask.census.gov/faq.php?id=5000&faqId=1653>
#'
#'   Other data sources that may be relevant include
#'
#'   - Census geodatabases at <http://www.census.gov/geo/maps-data/data/tiger-data.html>
#'
#'   - data at <http://www.census.gov/geo/maps-data/data/gazetteer.html>
#'
#' @author info@@ejanalysis.com
#' @references
#'  <https://ejanalysis.org> \cr
"_PACKAGE"
NULL
