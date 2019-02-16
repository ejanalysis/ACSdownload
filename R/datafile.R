#' @title Get name(s) of data file(s) for ACS 5-year summary file data
#'
#' @description Returns name(s) of data file(s) based on state(s), a sequence file number, and end year.
#' @param state.abbrev Required vector of one or more 2-character state abbreviations like "DC"
#' @param seqfilenum Required sequence file number(s) used by ACS 5-year summary file (can be a single value like "0022" or a vector)
#' @param end.year Optional end year for 5-year summary file, as character, defaulting to "2012"
#' @return Returns character element that is name of data file such as e20105de0017000 or m20105de0017000
#' @seealso \code{\link{get.acs}}
#' @export
datafile <- function(state.abbrev, seqfilenum, end.year = '2012') {
  # datafile name examples:
  #	e20105de0017000
  #	m20105de0017000
  
  datafile.prefix 	<- get.datafile.prefix(end.year = end.year)
  
  datafile.prefix.e <- paste("e", datafile.prefix, sep = "")
  datafile.states <- tolower(state.abbrev)
  datafile.seqfilenum <- seqfilenum
  datafile.suffix <- "000.txt"
  x <-
    expand.grid(datafile.states, datafile.seqfilenum, stringsAsFactors = FALSE)
  x <- paste(x[, 1], x[, 2], sep = '')
  datafile <- paste(datafile.prefix.e, x, datafile.suffix, sep = "")
  #datafile <- paste(datafile.prefix.e, datafile.states, datafile.seqfilenum, datafile.suffix, sep="") # was not vectorized on seqfilenum
  return(datafile)
}
