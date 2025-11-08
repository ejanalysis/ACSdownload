#' Pick a year-specific table from among lookup.acs20xx objects
#' @description
#'   Pick a year-specific lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
#'   namely which sequence files on the FTP site contain which tables and which variables.
#' @param end.year Character, optional, like "2021", which specifies the 2016-2021 dataset.
#'   Defines which 5-year summary file to use, based on end-year.
#'   Note: Function stops with error if given end.year is not yet added to this package or is too old.
#' @return returns a data.frame
#' @seealso [get.table.info()] and [get.field.info()]. \cr
#'   Also see [acs::acs.lookup()] which does something similar but is more flexible & robust.
#'   Also see [download.lookup.acs()] to download the file from the Census FTP site.
#'   Also see [lookup.acs] [lookup.acs2021] and similar data for other years.
#'   Also see [get_acs_old()], [get.lookup.file.name()], [get.url.prefix.lookup.table()]
#'   [tidycensus::load_variables()]
#' @examples
#'  names(lookup.acs2021)
#'  names(lookup.acs)
#'
#' @export
#'
get.lookup.acs <- function(end.year = acsdefaultendyearhere_func()) {

  # Note
   #  https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only/
   #
   #  https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/user_tools/
   #
   #  data is at different URLs for different years, like:
   #
   # browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2019/data/5_year_seq_by_state/UnitedStates/Tracts_Block_Groups_Only/")
   # "https://www2.census.gov/programs-surveys/acs/summary_file/2019/data/5_year_seq_by_state/UnitedStates/Tracts_Block_Groups_Only/g20195us.txt"
   # browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2020/data/5_year_seq_by_state/UnitedStates/Tracts_Block_Groups_Only/")
   # browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/UnitedStates/Tracts_Block_Groups_Only/")
   # browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/data/5YRData/")
   # browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/ACS20225YR_Table_Shells.txt")
   # For information on this new Summary File format visit: "https://www.census.gov/programs-surveys/acs/data/summary-file.html"

  validate.end.year(end.year)
  # "Sequence_Number_and_Table_Number_Lookup.txt" for end.year=2010 through 2013, but 2009 had only .xls not .txt
  if (end.year < acsfirstyearavailablehere) {
    stop(paste0('Years prior to ', acsfirstyearavailablehere, ' are not valid. ACS 5-year file was 1st available 2005-2009, but this package now has only recent years.') )
  }

  # already has these via lazy loading as with data() - but that does not work unless library(ACSdownload) not just ACSdownload::get_acs_old()
  # nameoflookupdata <- paste('lookup.acs', end.year, sep = '')
  # if (!exists(nameoflookupdata)) {stop(nameoflookupdata, ' does not exist via data(package = "ACSdownload")')}
  nameofthelookup <- paste('yr', end.year, sep = '')
  #force(nameofthelookup) # not sure if needed?
  #data(get(nameofthelookup)) # not sure if needed? does not work like that - need value of that

  my.lookup <- switch(
    EXPR = nameofthelookup,
    # yr2017 = lookup.acs2017,
    yr2018 = lookup.acs2018,  # for ACS 2016-2020
    yr2019 = lookup.acs2019,  # for EJScreen ver.2.0; ACS 2015-2019, released Dec. 2020. In EJScreen ver.2.0
    yr2020 = lookup.acs2020,  # for EJScreen ver.2.1; ACS 2016-2020, plan was Dec. 2021 released, but delayed to 3/17/22.
    yr2021 = lookup.acs2021,   #,  #  ACS 2017-2021,  release of Dec. 2022
    yr2022 = lookup.acs2022,   # ACS 2018-2022 released Dec 2023
    yr2023 = lookup.acs2023   #   Dec 2024 release

  )
  force(my.lookup)
  # old data source was this (and that is how these were obtained and cleaned up):
  # my.lookup <- download.lookup.acs(end.year=end.year, folder=folder)
  return(my.lookup)
}
