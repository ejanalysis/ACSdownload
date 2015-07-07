#' @title Get URL prefix for FTP site folder(s) with ACS 5-year summary file data
#'
#' @description Returns part of URL of folders (on Census Bureau FTP site) with zip file(s) based on end year.
#' @param end.year Optional end year for 5-year summary file, as character, defaulting to "2012" but ignored if url.prefix is specified
#' @return Returns character vector that is first part of URL such as "ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset"
#' @seealso \code{\link{get.acs}}, \code{\link{url.to.find.zipfile}}, \code{\link{download.geo}}
#' @export
get.url.prefix <- function(end.year="2012") {
  return(paste(
    "ftp://ftp.census.gov/acs",
    end.year,
    "_5yr/summaryfile/",
    as.character(as.numeric(end.year)-4), "-", end.year,
    "_ACSSF_By_State_By_Sequence_Table_Subset",
    sep=""
    ))
}