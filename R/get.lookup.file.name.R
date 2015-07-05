#' @title Get name of Census file with Sequence and Table Numbers for ACS 5-year summary file data
#'
#' @description Returns name of text file provided by US Census Bureau, 
#'   such as Sequence_Number_and_Table_Number_Lookup.txt, which provides the 
#'   sequence numbers (file numbers) and table numbers for data in the American Community Survey (ACS) 5-year summary file.
#' @param end.year Not yet implemented, but will be optional end year for 5-year summary file, as character, defaulting to "2012"
#' @return Returns character element that is name of file such as "Sequence_Number_and_Table_Number_Lookup.txt"
#' @seealso \code{\link{get.acs}}
#' @export
get.lookup.file.name	<- function(end.year="2012") {
  return("Sequence_Number_and_Table_Number_Lookup.txt")
  #	Can modify later to handle other end years and/or 1/3/5 year files.
}
