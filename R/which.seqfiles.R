#' @title Find Which Sequence Files Contain Given ACS Table(s)
#' @description
#'   The US Census Bureau provides 5-year summary file data from the American Community Survey in sequence files on their FTP site.
#'   This function reports which sequence files contain the specified tables. Used by \code{\link{get.acs}}
#' @param tables character vector, required. Defines which ACS table(s) to check, such as 'B01001'
#' @param lookup.acs data.frame, optional (if not provided then it is downloaded from Census). 
#'   Specifies what variables are in which tables and which tables are in which sequence files on the FTP site.
#' @param end.year Character element, optional, "2012" by default. Defines end year for 5-year dataset.
#' @return Returns a vector of one or more numbers stored as characters, each defining one sequence file, such as "0001".
#' @seealso \code{\link{get.acs}} and \code{\link[acs]{acs.lookup}} from the \pkg{acs} package, which does something related but is more flexible & robust. Also see \code{\link{get.acs}} which uses this.
#' @export
which.seqfiles <- function(tables, lookup.acs, end.year="2012") {
	if (missing(lookup.acs)) {lookup.acs <- get.lookup.acs(end.year)}
	these.seqfilelistnums <- unique(lookup.acs[ lookup.acs$Table.ID %in% tables, "Sequence.Number"])
	return(these.seqfilelistnums)
}
