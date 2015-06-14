#' @title Get name(s) of data file(s) for ACS 5-year summary file data
#'
#' @description Returns name(s) of data file(s) based on state(s), a sequence file number, and end year.
#' @param state.abbrev Required vector of 2-character state abbreviation(s)
#' @param seqfilenum Required single sequence file number used by ACS 5-year summary file
#' @param end.year Optional end year for 5-year summary file, as character, defaulting to "2012"
#' @return Returns character element that is name of data file such as e20105de0017000 or m20105de0017000
#' @seealso \code{\link{get.acs}}
#' @export
datafile <- function(state.abbrev, seqfilenum, end.year='2012') {

  # datafile name examples:
  #	e20105de0017000
  #	m20105de0017000
  
  datafile.prefix 	<- get.datafile.prefix(end.year=end.year)

  datafile.prefix.e <- paste("e", datafile.prefix, sep="")
  datafile.states <- tolower(state.abbrev)
  datafile.seqfilenum <- seqfilenum
  datafile.suffix <- "000.txt"
  datafile <- paste(datafile.prefix.e, datafile.states, datafile.seqfilenum, datafile.suffix, sep="")
  return(datafile)
}
