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
#' @param testing Logical value, optional, FALSE by default. Prints more information if TRUE.
#' @return Returns character vector of 2-character State abbreviations. Default is 50 States plus DC and PR and US total.
#' @seealso \code{\link{get.acs}} which uses this, and \code{\link[proxistat]{lookup.states}} or \code{\link{get.state.info}}
#' @export
clean.mystates <- function(mystates, testing=FALSE) {
  
  require(proxistat)
  data(lookup.states, envir = environment())
  stateinfo <- lookup.states
  #stateinfo	<- get.state.info()
  
  statenames	<- stateinfo$ftpname
  stateabbs	<- tolower(stateinfo$ST) # stateabbs may be used later also. it is all states.
  
  if (testing) { mystates	<- c("dc", "de") }
  mystates <- tolower(mystates)
  if ('all' %in% mystates | any(is.null(mystates))) {mystates <- stateabbs}
  mystates <- mystates[!(mystates %in% c("as", "gu", "mp", "um", "vi"))]
  return(mystates)  
}
