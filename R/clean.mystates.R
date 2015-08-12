#' @title Utility to Clean Names of States for get.acs
#'
#' @description
#'  Utility function used by \code{\link{get.acs}}
#'
#' @details
#'  Not in FTP ACS Summary files and not returned by this function: \cr
#'  #53         60 AS              American Samoa               <NA>\cr
#'  #54         66 GU                        Guam               <NA>\cr
#'  #55         69 MP    Northern Mariana Islands               <NA>\cr
#'  #57         74 UM U.S. Minor Outlying Islands               <NA>\cr
#'  #58         78 VI         U.S. Virgin Islands               <NA>\cr
#'  Note: The function stops if any of mystates is not found in the full list that includes these,
#'  but it returns only those excluding these five above, so an invalid state like 'ZQ' causes an error but an invalid state like 'VI' is silently removed without any error.
#' @param mystates Character vector, required. Defines which states, using 2-character abbreviations (case-insensitive), or 'all' for all available.
#' @param testing Logical value, optional, FALSE by default. LIMITS STATES TO DC AND DE if TRUE.
#' @return Returns character vector of 2-character State abbreviations. Does not remove duplicates.
#'   If mystates is not specified or is 'all' or has any NULL values, returns 50 States plus DC and PR and US (for totals).
#'   If mystates is specified, returns those defaults that match any of mystates.
#'   If mystates includes DC, PR, or US, those are returned, but "AS" "GU" "MP" "UM" "VI" are removed.
#' @seealso \code{\link{get.acs}} which uses this, and \code{\link[ejanalysis]{get.state.info}} (from \pkg{ejanalysis} package) based on \code{\link[proxistat]{lookup.states}} or \code{data(lookup.states, package=proxistat)} using \pkg{proxistat} package
#' @export
clean.mystates <- function(mystates, testing=FALSE) {

  # default is to get all states # which includes DC, and "US" and "PR" and "AS" "GU" "MP" "UM" "VI"
  # ****But then some island areas are removed below.
  #stateinfo	<- ejanalysis::get.state.info()
  # or could use this:
  data(lookup.states, envir = environment(), package='proxistat');   stateinfo <- lookup.states
  # or state.abb from base datasets but that lacks DC PR VI GU etc.
  # also,
  #statenames	<- stateinfo$ftpname
  stateabbs	<- tolower(stateinfo$ST)

  if (missing(mystates)) {mystates <- stateabbs}
  if (testing) { mystates	<- c("dc", "de") }
  mystates <- tolower(mystates)
  if ('all' %in% mystates | any(is.null(mystates))) {mystates <- stateabbs}
  if (!all(mystates %in% stateabbs)) {stop('not all specified states were found in list of state abbreviations')}
  mystates <- mystates[!(mystates %in% c("as", "gu", "mp", "um", "vi"))]
  return(mystates)
}
