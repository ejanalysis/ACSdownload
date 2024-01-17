#' @title Utility to Clean Names of States for get.acs
#'
#' @description
#'  Utility function used by \code{\link{get.acs}} and \code{\link{download.datafiles}}
#'
#' @details
#'  Not in FTP ACS Summary files and not returned by this function's default: \cr
#'  #53         60 AS              American Samoa               <NA>\cr
#'  #54         66 GU                        Guam               <NA>\cr
#'  #55         69 MP    Northern Mariana Islands               <NA>\cr
#'  #58         78 VI         U.S. Virgin Islands               <NA>\cr
#'  #57         74 UM U.S. Minor Outlying Islands               <NA>\cr
#'
#'  Note: The function stops if any of mystates is not found in the full list that includes these,
#'  but it returns only those excluding these five above, so an invalid state like 'ZQ' causes an error but an invalid state like 'VI' is silently removed without any error.
#'
#'  Puerto Rico (PR, FIPS 72), the District of Columbia (DC, 11), and the 50 States are in ACS 2016-2020 and Census 2020.
#'  For info on Island Areas, see https://www.census.gov/programs-surveys/decennial-census/technical-documentation/island-areas-censuses.html
#'  The 2020 Island Areas Censuses (IAC) include data for American Samoa (AS, FIPS 60), Guam (GU, 66),
#'  the Commonwealth of the Northern Mariana Islands (MP, 69), and the U.S. Virgin Islands (VI. 78),
#'  but not U.S. Minor Outlying Islands (UM, 74).
#'  The 2020 Census counted people living in the U.S. Island Areas using a long-form questionnaire. Other
#'  surveys, such as the American Community Survey (ACS), are not conducted in the Island Areas. Therefore,
#'  the Census Bureau used a long-form questionnaire to meet the Island Areas’ data needs for demographic,
#'  social, economic, and housing unit information. This long-form questionnaire was similar to the ACS
#'  questionnaire used in the 50 states, the District of Columbia, and Puerto Rico.
#'  The 2020 IAC Demographic Profile Summary File provides access to all of the data.
#'  It provides data down to the place, county subdivision, and estate (USVI only) level - not block groups.
#'  The 2020 IAC Demographic Profile Summary File data are available through
#'  the Census Bureau’s data exploration platform, data.census.gov.
#'  The 2020 IAC Demographic Profile Summary File is located on the U.S. Census Bureau’s file transfer protocol
#'  (FTP) server at <https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/.
#'  The easiest way is to start at the 2020 Island Areas Censuses Data Products webpage at
#'  www.census.gov/programs-surveys/decennial-census/decade/2020/planning-management/release/2020-islandareas-data-products.html
#'
#' @param mystates Character vector, optional.
#'   Defines which states, using 2-character abbreviations (case-insensitive), or 'all' for all available.
#'
#'   Default is 'all' which is 50 states plus DC, BUT NO LONGER PR (& not AS, GU, MP, UM, VI, US).
#'   If mystates is not specified or is 'all' then this returns the default.
#'   If mystates is specified, returns those defaults that match any of mystates.
#'   If mystates includes DC, PR, or US, those are returned, but "AS" "GU" "MP" "UM" "VI" are removed.
#'   One element of the vector can be 50, 51, or 52, where 50 represents the 50 states, 51 = 50 plus DC, or 52 = the 51 plus PR.
#'   In other words, the default could be written as c(50,'DC','PR') or as c(51,'PR') or just 52.
#'   Redundant entries are dropped, e.g., c(51,'DC') becomes 51.
#'
#' @param testing Logical value, optional, FALSE by default. LIMITS STATES TO DC AND DE if TRUE.
#' @return Returns character vector of 2-character State abbreviations, lower case.
#' @seealso \code{\link{get.acs}} and \code{\link{download.datafiles}} which use this, and \code{\link[ejanalysis]{get.state.info}} (from \pkg{ejanalysis} package) based on \code{\link[proxistat]{lookup.states}} or \code{data(lookup.states, package=proxistat)} using \pkg{proxistat} package
#' @export
clean.mystates <- function(mystates = 'all', testing = FALSE) {
  #stateinfo	<- ejanalysis::get.state.info()
  # or could use this:
  # data(lookup.states, envir = environment(), package = 'proxistat')
  stateinfo <- lookup.states # available in the proxistat package
  # or state.abb from base datasets but that lacks DC PR VI GU etc.
  # also,
  #statenames	<- stateinfo$ftpname
  allabbs	<- tolower(stateinfo$ST)
  stateabbs <-
    allabbs[!(allabbs %in% c("as", "gu", "mp", "um", "vi", "us"))]
  # that leaves 52 (states+dc+pr)
  # *** now remove pr
  stateabbs <- stateabbs[stateabbs != 'pr']

  mystates <- tolower(mystates)

  # expand states specified by 50,51,52,'all'
  x51 <- allabbs[1:51]
  if ('all' %in% mystates) {
    mystates <- c(mystates[mystates != 'all'], stateabbs)
  }
  if (50 %in% mystates)    {
    mystates <- c(mystates[mystates != 50], x51[x51 != 'dc'])
  }
  if (51 %in% mystates)    {
    mystates <- c(mystates[mystates != 51], x51)
  }
  if (52 %in% mystates)    {
    mystates <- c(mystates[mystates != 52], x51, 'pr')
  }

  # remove duplicates:
  mystates <- unique(mystates)

  if (!all(mystates %in% allabbs)) {
    stop('not all specified states were found in list of state abbreviations')
  }

  #  remove island areas/territories ( but not  'us'?)  :
  mystates <- mystates[mystates %in% c('us', stateabbs)]

  if (testing & missing(mystates)) {
    mystates	<- c("dc", "de")
  }

  return(mystates)
}
