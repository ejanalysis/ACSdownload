#' @title Get Information about ACS 5-Year Summary File Tables
#' @description
#'   Get lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
#'   namely which sequence files on the FTP site contain which tables and which variables.
#'   NOTE: This uses lazy loading from data(lookup.acs2013) and similarly for other years.
#' @details
#'   Now folders are like:
#'   https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only/
#'   https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/user_tools/
#'
#'   The source of this lookup table was, for example,
#'   \url{ftp://ftp.census.gov/acs2012_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt}
#'   and for 2014 is \url{http://www2.census.gov/programs-surveys/acs/summary_file/2014/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt}
#'   Note 2014 file lacks leading zeroes on Sequence Number field, so those were added before saving as .RData file as data for package.
#'    via lookup.acs2014$Sequence.Number <- analyze.stuff::lead.zeroes(lookup.acs2014$Sequence.Number, 4)
#' @param end.year Character, optional, like '2012', which specifies the 2008-2012 dataset.
#'   Defines which 5-year summary file to use, based on end-year.
#'   Can be 2009 or later. Data for end.year='2014' was released December 2015, for example.
#'   Note: Function stops with error if given end.year is not yet added to this package.
#' @param folder Ignored (leftover from when this was like download.lookup.acs)
#' @return By default, returns a data.frame with these fields:
#'   \code{
#'      $ Table.ID               : chr  "B00001" "B00001" "B00001" "B00002" ...
#'      $ Sequence.Number        : chr  "0001" "0001" "0001" "0001" ...
#'      $ Line.Number            : num  NA NA 1 NA NA 1 NA NA 1 2 ...
#'      $ Start.Position         : num  7 NA NA 8 NA NA 7 NA NA NA ...
#'      $ Total.Cells.in.Table   : chr  "1 CELL" "" "" "1 CELL" ...
#'      $ Total.Cells.in.Sequence: num  NA NA NA 2 NA NA NA NA NA NA ...
#'      $ Table.Title            : chr  "UNWEIGHTED SAMPLE COUNT OF THE POPULATION" "Universe:  Total population" "Total" "UNWEIGHTED SAMPLE HOUSING UNITS" ...
#'      $ Subject.Area           : chr  "Unweighted Count" "" "" "Unweighted Count" ...
#'   }
#'   For ACS 2008-2012: \cr
#'   \code{
#'   length(my.lookup[,1])
#'   [1] 24741
#'   names(my.lookup)
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"         "Line.Number"             "Start.Position"
#'   [6] "Total.Cells.in.Table"    "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"
#'   }
#' @seealso \code{\link{get.table.info}} and \code{\link{get.field.info}}. \cr
#'   Also see \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust.
#'   Also see \code{\link{download.lookup.acs}} to download the file from the Census FTP site.
#'   Also see \code{data(lookup.acs2013)} and similar data for other years.
#'   Also see \code{\link{get.acs}}, \code{\link{get.lookup.file.name}}, \code{\link{get.url.prefix.lookup.table}}
#' @examples
#'  \dontrun{
#'  lookup.acs <- get.lookup.acs()
#'  }
#' @export
get.lookup.acs <- function(end.year = '2017',
                           folder = getwd()) {
  # "Sequence_Number_and_Table_Number_Lookup.txt" for end.year=2010 through 2013, but 2009 had only .xls not .txt
  if (end.year < 2009) {
    stop(
      'Years prior to 2009 are not valid. ACS 5-year file was not available until 2005-2009, end.year=2009.'
    )
  }
  if (end.year == 2009)  {
    warning('2005-2009 dataset originally used an xls file for this information, not fully tested here.')
  }
  if (end.year > substr(Sys.time(),1,4)) {
    warning(
      'That end.year ', end.year, ' seems to be in the future '
    )
  }

  # already has these via lazy loading as with data() - but that does not work unless library(ACSdownload) not just ACSdownload::get.acs()
  # nameoflookupdata <- paste('lookup.acs', end.year, sep = '')
  # if (!exists(nameoflookupdata)) {stop(nameoflookupdata, ' does not exist via data(package = "ACSdownload")')}
  nameofthelookup <- paste('yr', end.year, sep = '')
  #force(nameofthelookup) # not sure if needed?
  #data(get(nameofthelookup)) # not sure if needed? does not work like that - need value of that

  my.lookup <- switch(
    EXPR = nameofthelookup,
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
    yr2020 = lookup.acs2020
  )
  force(my.lookup)
  # old data source was this (and that is how these were obtained and cleaned up):
  # my.lookup <- download.lookup.acs(end.year=end.year, folder=folder)
  return(my.lookup)
}
