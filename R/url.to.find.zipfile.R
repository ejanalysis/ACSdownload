#' @title Get URL(s) for FTP site folder(s) with ACS 5-year summary file data
#'
#' @description Returns URLs of folders on Census Bureau FTP site with zip files based on end year.
#' @details
#'   See help for [download.lookup.acs()] for more details on the URLs used for the data. 
#'   
#'   The zip files look like this for example: "20135dc0001000.zip" \cr
#'   \cr
#'   The 2009-2013 summary file by state-seqfile combo is in folders that look like this: \cr
#'   \cr
#'   [ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only]
#'   
#'   # also see "https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/data/5YRData/"
#'   
#'   The 2008-2012 summary file by state-seqfile combo is in folders that look like this: \cr
#'   \cr
#' 	 [http://www2.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset/Alabama/Tracts_Block_Groups_Only] \cr
#'
#'   The 2007-2011 summary file by state-seqfile combo is in folders that look like this:\cr
#'  \cr
#'   [ftp://ftp.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/] \cr
#'   URL must be the ftp site, not the http version.
#'   
#'   http version was here
#'   [http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/] \cr
#'
#' @param mystates Character vector of one or more states/DC/PR, as 2-character state abbreviations. Default is all states/DC/PR.
#' @param url.prefix Optional character element that defaults to what is returned by `[get.url.prefix](end.year)`
#' @param end.year Optional end year for 5-year summary file, as character,  but ignored if url.prefix is specified
#' @return Returns character vector that is URL(s) such as "ftp://ftp.census.gov/acs2012_5yr/summaryfile"
#' @seealso [get.acs()], [url.to.find.zipfile()], [download.geo()]
#' 
#' @export
#' 
url.to.find.zipfile <-
  function(mystates, end.year = acsdefaultendyearhere_func(), url.prefix) {
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    if (missing(mystates)) {
      # default is to get all states # which includes DC, AND "AS" "GU" "MP" "PR" "UM" "VI" "US"

      data(lookup.states, envir = environment(), package = 'proxistat')
      mystates <- lookup.states$ST
    }

    url.states <- mystates
    url.suffix <- "Tracts_Block_Groups_Only"
    if (missing(url.prefix)) {
      url.prefix <- get.url.prefix(end.year = end.year)
    }
    url <- paste(url.prefix, url.states, url.suffix, sep = "/")
    return(url)
  }
