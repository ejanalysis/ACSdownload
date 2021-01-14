#' @title Get URL(s) for FTP site folder(s) with ACS 5-year summary file data
#'
#' @description Returns URL(s) of folders (on Census Bureau FTP site) with zip file(s) based on end year.
#' @details
#'   See help for \link{download.lookup.acs} for more details on the URLs used for the data. \cr
#'   The zip files look like this for example: "20135dc0001000.zip" \cr
#'   \cr
#'   The 2009-2013 summary file by state-seqfile combo is in folders that look like this: \cr
#'   \cr
#'   \url{ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only} \cr
#'   \cr
#'   The 2008-2012 summary file by state-seqfile combo is in folders that look like this: \cr
#'   \cr
#' 	 \url{http://www2.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset/Alabama/Tracts_Block_Groups_Only} \cr
#'
#'   The 2007-2011 summary file by state-seqfile combo is in folders that look like this:\cr
#'  \cr
#'   \url{ftp://ftp.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/} \cr
#'   \url{http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/} \cr
#'   URL must be the ftp site, not the http version.
#'
#'   But 2010-2014 was on http only, not ftp, as of mid Dec 3 2015 release day.
#'
#' @param mystates Character vector of one or more states/DC/PR, as 2-character state abbreviations. Default is all states/DC/PR.
#' @param url.prefix Optional character element that defaults to what is returned by \code{\link{get.url.prefix}(end.year)}
#' @param end.year Optional end year for 5-year summary file, as character,  but ignored if url.prefix is specified
#' @return Returns character vector that is URL(s) such as "ftp://ftp.census.gov/acs2012_5yr/summaryfile"
#' @seealso \code{\link{get.acs}}, \code{\link{url.to.find.zipfile}}, \code{\link{download.geo}}
#' @export
url.to.find.zipfile <-
  function(mystates, end.year = '2019', url.prefix) {
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(2009:(thisyear - 1)))) {stop('end.year must be a plausible year such as 2017')}
    
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
