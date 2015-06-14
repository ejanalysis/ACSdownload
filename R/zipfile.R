#' @title Get name(s) of zip file(s) for ACS 5-year summary file data
#'
#' @description Returns name(s) of zip file(s) based on state(s), a sequence file number, a prefix, and end year.
#' @param state.abbrev Required vector of 2-character state abbreviation(s)
#' @param seqfilenum Required single sequence file number used by ACS 5-year summary file
#' @param end.year Optional end year for 5-year summary file, as character, defaulting to "2012"
#' @param zipfile.prefix Optional character element, defaults to value looked up based on end.year.
#' @return Returns character element that is name of zip file such as "20115dc0113000.zip"
#' @seealso \code{\link{get.acs}}
#' @export
zipfile <- function(mystates, seqfilenum, zipfile.prefix, end.year='2012') {

    # zip FILENAME example
  # 	20115dc0113000.zip
  if (missing(zipfile.prefix)) {zipfile.prefix    <- get.zipfile.prefix(end.year) }  
  zipfile.states <- tolower(mystates)
  zipfile.seqfilenum <- seqfilenum
  zipfile.suffix <- "000.zip"
  zipfile <- paste(zipfile.prefix, zipfile.states, zipfile.seqfilenum, zipfile.suffix, sep="")
  return(zipfile)
}

