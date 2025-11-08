#' @title Get name of Census file with Sequence and Table Numbers for ACS 5-year summary file data
#'
#' @description Returns name of text file provided by US Census Bureau,
#'   such as Sequence_Number_and_Table_Number_Lookup.txt, which provides the
#'   sequence numbers (file numbers) and table numbers for data in the American Community Survey (ACS) 5-year summary file.
#' @param end.year Not yet implemented, but will be optional end year for 5-year summary file, as character
#' @return Returns character element that is name of file such as "Sequence_Number_and_Table_Number_Lookup.txt"
#' @seealso [get_acs_old()], [get.lookup.acs()], [get.url.prefix.lookup.table()]. Also see `data(lookup.acs)`.
#'
#' @export
#'
get.lookup.file.name	<- function(end.year = acsdefaultendyearhere_func()) {

  validate.end.year(end.year)

  if (end.year >= 2021) {
    return(paste0("ACS", end.year,"5YR_Table_Shells.txt"))
  }

  if (end.year > 2009) {
    if (end.year == 2014) {
      return('ACS_5yr_Seq_Table_Number_Lookup.txt')
    } else {
      return('ACS_5yr_Seq_Table_Number_Lookup.txt')
      # return("Sequence_Number_and_Table_Number_Lookup.txt")
    }
  } else {
    stop('invalid end.year')
  }

  #	For other end years (and possibly 1 or 3 year files at some point? those lack block groups):
  # 2009 ftp://ftp.census.gov//acs2009_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.xls ******
  # 2010 ftp://ftp.census.gov//acs2010_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt
  # 2011 ftp://ftp.census.gov//acs2011_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt
  # 2012 ftp://ftp.census.gov//acs2012_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt
  # 2013 ftp://ftp.census.gov//acs2013_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt
  #
  # 2014 http://www2.census.gov/programs-surveys/acs/summary_file/2014/data/5_year_seq_by_state/ACS_5yr_Seq_Table_Number_Lookup.txt
  #  not on ftp site yet as of early Dec 3, 2015.
  #
  # 2015 expected December 2016

}
