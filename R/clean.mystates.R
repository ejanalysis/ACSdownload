#' @title Utility to Clean Names of States for get.acs
#'
#' @description
#'  Utility function used by \code{\link{get.acs}}
#' 
#' @details 
#'  Not in FTP ACS Summary files: \cr
#'  #53         60 AS              American Samoa               <NA>\cr
#'  #54         66 GU                        Guam               <NA>\cr
#'  #55         69 MP    Northern Mariana Islands               <NA>\cr
#'  #57         74 UM U.S. Minor Outlying Islands               <NA>\cr
#'  #58         78 VI         U.S. Virgin Islands               <NA>\cr
#' 
#' @param mystates Character vector, required. Defines which states, using 2-character abbreviations (case-insensitive), or 'all' for all available.
#' @param testing Logical value, optional, FALSE by default. LIMITS STATES TO DC AND DE if TRUE.
#' @return Returns character vector of 2-character State abbreviations. Default is 50 States plus DC and PR and US total.
#' @seealso \code{\link{get.acs}} which uses this, and \code{data(lookup.states, package=proxistat)} using \pkg{proxistat} package
#' @export
clean.mystates <- function(mystates, testing=FALSE) {
  
  # default is to get all states # which includes DC, AND "AS" "GU" "MP" "PR" "UM" "VI" "US"
  # But then some island areas are removed below.
  #stateinfo	<- ejanalysis::get.state.info()
  # or could use this:
  data(lookup.states, envir = environment(), package='proxistat');   stateinfo <- lookup.states
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
