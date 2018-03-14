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
#'  #57         74 UM U.S. Minor Outlying Islands               <NA>\cr
#'  #58         78 VI         U.S. Virgin Islands               <NA>\cr
#'  Note: The function stops if any of mystates is not found in the full list that includes these,
#'  but it returns only those excluding these five above, so an invalid state like 'ZQ' causes an error but an invalid state like 'VI' is silently removed without any error.
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
  data(lookup.states, envir = environment(), package = 'proxistat');   stateinfo <- lookup.states
  # or state.abb from base datasets but that lacks DC PR VI GU etc.
  # also,
  #statenames	<- stateinfo$ftpname
  allabbs	<- tolower(stateinfo$ST)
  stateabbs <- allabbs[!(allabbs %in% c("as", "gu", "mp", "um", "vi", "us"))]
  # that leaves 52 (states+dc+pr)
  # *** now remove pr
  stateabbs <- stateabbs[stateabbs != 'pr']
  
  mystates <- tolower(mystates)
  
  # expand states specified by 50,51,52,'all'
  x51 <- allabbs[1:51]
  if ('all' %in% mystates) {mystates <- c(mystates[mystates != 'all'], stateabbs)}
  if (50 %in% mystates)    {mystates <- c(mystates[mystates != 50], x51[x51 != 'dc'])}
  if (51 %in% mystates)    {mystates <- c(mystates[mystates != 51], x51)}
  if (52 %in% mystates)    {mystates <- c(mystates[mystates != 52], x51, 'pr')}
  
  # remove duplicates:
  mystates <- unique(mystates)
  
  if (!all(mystates %in% allabbs)) {stop('not all specified states were found in list of state abbreviations')}
  
  #  remove island areas/territories ( but not  'us'?)  :
  mystates <- mystates[ mystates %in% c('us', stateabbs) ]
  
  if (testing) { mystates	<- c("dc", "de") }
  
  return(mystates)
}
