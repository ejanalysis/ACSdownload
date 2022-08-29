#' @title Get Information about ACS 5-Year Summary File Tables
#' @description
#'   Get lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
#'   namely which sequence files on the FTP site contain which tables and which variables.
#'   NOTE: This uses lazy loading from datasets in the package.
#' @details
#'   Now folders are or were like:
#'   https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only/
#'   https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/user_tools/
#'
#' @param end.year Character, optional, like '2020', which specifies the 2016-2020 dataset.
#'   Defines which 5-year summary file to use, based on end-year.
#'   Note: Function stops with error if given end.year is not yet added to this package or is too old.
#' @return returns a data.frame  
#'   \code{
#'   dim(lookup.acs2020)
#'   [1] 30326     9
#'   names(lookup.acs2020)
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"        
#'   [4] "Line.Number"             "Start.Position"          "Total.Cells.in.Table"   
#'   [7] "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"           
#'   }
#' @seealso \code{\link{get.table.info}} and \code{\link{get.field.info}}. \cr
#'   Also see \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust.
#'   Also see \code{\link{download.lookup.acs}} to download the file from the Census FTP site.
#'   Also see \code{data(lookup.acs2020)} and similar data for other years.
#'   Also see \code{\link{get.acs}}, \code{\link{get.lookup.file.name}}, \code{\link{get.url.prefix.lookup.table}}
#' @examples
#'  \dontrun{
#'  lookup.acs <- get.lookup.acs()
#'  }
#' @export
get.lookup.acs <- function(end.year = acsdefaultendyearhere_func()) {
  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a recent year')}
  # "Sequence_Number_and_Table_Number_Lookup.txt" for end.year=2010 through 2013, but 2009 had only .xls not .txt
  if (end.year < acsfirstyearavailablehere) {
    stop(paste0('Years prior to ', acsfirstyearavailablehere, ' are not valid. ACS 5-year file was 1st available 2005-2009, but this package now has only recent years.') )
  }
   
  # already has these via lazy loading as with data() - but that does not work unless library(ACSdownload) not just ACSdownload::get.acs()
  # nameoflookupdata <- paste('lookup.acs', end.year, sep = '')
  # if (!exists(nameoflookupdata)) {stop(nameoflookupdata, ' does not exist via data(package = "ACSdownload")')}
  nameofthelookup <- paste('yr', end.year, sep = '')
  #force(nameofthelookup) # not sure if needed?
  #data(get(nameofthelookup)) # not sure if needed? does not work like that - need value of that

  my.lookup <- switch(
    EXPR = nameofthelookup,
    # yr2009 = lookup.acs2009,
    # yr2010 = lookup.acs2010,
    # yr2011 = lookup.acs2011,
    # yr2012 = lookup.acs2012,
    # yr2013 = lookup.acs2013,
    # yr2014 = lookup.acs2014,
    # yr2015 = lookup.acs2015,
    # yr2016 = lookup.acs2016,
    # yr2017 = lookup.acs2017,
    yr2018 = lookup.acs2018,
    yr2019 = lookup.acs2019,
    yr2020 = lookup.acs2020,
    yr2021 = lookup.acs2021,
    yr2022 = lookup.acs2022
  )
  force(my.lookup)
  # old data source was this (and that is how these were obtained and cleaned up):
  # my.lookup <- download.lookup.acs(end.year=end.year, folder=folder)
  return(my.lookup)
}
