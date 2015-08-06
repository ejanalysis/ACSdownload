#' @title Get Information about ACS 5-Year Summary File Tables
#'
#' @description
#'   Get lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
#'   namely which sequence files on the FTP site contain which tables and which variables.
#'   NOTE: This uses lazy loading from data(lookup.acs2013) and similarly for other years.
#' @details
#'   The source of this lookup table was, for example,
#'   \url{ftp://ftp.census.gov/acs2012_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt}
#'   \cr\cr
#' @param end.year Character, optional, '2012' by default, which specifies the 2008-2012 dataset.
#'   Defines which 5-year summary file to use, based on end-year.
#'   Can be 2009 or later. Data for end.year='2014' is released December 2015, for example.
#'   Note: Function stops with error if given end.year is not yet added to this package.
#' @param folder Ignored (leftover from when this was like download.lookup.acs)
#' @return By default, returns a data.frame with these fields:
#'   \itemize{
#'     \item $ Table.ID               : chr  "B00001" "B00001" "B00001" "B00002" ...
#'     \item $ Sequence.Number        : chr  "0001" "0001" "0001" "0001" ...
#'     \item $ Line.Number            : num  NA NA 1 NA NA 1 NA NA 1 2 ...
#'     \item $ Start.Position         : num  7 NA NA 8 NA NA 7 NA NA NA ...
#'     \item $ Total.Cells.in.Table   : chr  "1 CELL" "" "" "1 CELL" ...
#'     \item $ Total.Cells.in.Sequence: num  NA NA NA 2 NA NA NA NA NA NA ...
#'     \item $ Table.Title            : chr  "UNWEIGHTED SAMPLE COUNT OF THE POPULATION" "Universe:  Total population" "Total" "UNWEIGHTED SAMPLE HOUSING UNITS" ...
#'     \item $ Subject.Area           : chr  "Unweighted Count" "" "" "Unweighted Count" ...
#'   }
#'   \cr
#'   For ACS 2008-2012: \cr
#'   length(my.lookup[,1]) \cr
#'   [1] 24741\cr
#'   names(my.lookup)\cr
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"         "Line.Number"             "Start.Position"\cr
#'   [6] "Total.Cells.in.Table"    "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"\cr
#' @seealso \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust.
#'   Also see \code{\link{download.lookup.acs}} to download the file from the Census FTP site.
#'   Also see \code{data(lookup.acs2013)} and similar data for other years.
#'   Also see \code{\link{get.acs}}, \code{\link{get.lookup.file.name}}, \code{\link{get.url.prefix.lookup.table}}
#' @examples
#'  \dontrun{
#'  lookup.acs <- get.lookup.acs()
#'  }
#' @export
get.lookup.acs <- function(end.year="2012", folder=getwd()) {

  # "Sequence_Number_and_Table_Number_Lookup.txt" for end.year=2010 through 2013, but 2009 had only .xls not .txt
  if (end.year < 2009) {stop('Years prior to 2009 are not valid. ACS 5-year file was not available until 2005-2009, end.year=2009.')}
  if (end.year==2009)  {warning('2005-2009 dataset used an xls file for this information, not fully tested here.')}
  if (end.year > 2013) {warning('end.year of 2014 or later may not be available yet -- 2010-2014 dataset is expected in December 2015.')}

  # just get these via lazy loading as with data()
  my.lookup <- switch(EXPR = paste('yr', end.year,sep=''),
                      yr2009 = lookup.acs2009,
                      yr2010 = lookup.acs2010,
                      yr2011 = lookup.acs2011,
                      yr2012 = lookup.acs2012,
                      yr2013 = lookup.acs2013,
                      yr2014 = lookup.acs2014,
                      yr2015 = lookup.acs2015,
                      yr2016 = lookup.acs2016,
                      yr2017 = lookup.acs2017,
                      yr2018 = lookup.acs2018,
                      yr2019 = lookup.acs2019,
                      yr2020 = lookup.acs2020)
  # NOTE THAT WILL CRASH IF THE GIVEN YEAR OF DATA IS NOT YET AVAILABLE FROM CENSUS AND ADDED TO THIS PACKAGE.

  # old data source was this (and that is how these were obtained and cleaned up):
  # my.lookup <- download.lookup.acs(end.year=end.year, folder=folder)

  return(my.lookup)
}

