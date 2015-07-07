#' @title Download File with Information about ACS 5-Year Summary File Tables
#'
#' @description
#'   Download and read lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
#'   namely which sequence files on the FTP site contain which tables and which variables.
#' @details  
#'   Note that lookup may already be in memory from prior work and is not downloaded again if named lookup.acs.
#'   Code was developed late 2013 through mid 2015.
#'   \cr\cr
#'   The source of this lookup table is, for example, 
#'   \url{ftp://ftp.census.gov/acs2012_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt}
#'   \cr\cr
#'   Note: The \pkg{acs} package provides a more powerful version of this, called \code{\link[acs]{acs.lookup}}
#' 
#' @param end.year Character, optional, '2012' by default, which specifies the 2008-2012 dataset.
#'   Defines which 5-year summary file to use, based on end-year. 
#' @param folder Optional path to where to download file to, defaults to current working directory.
#' @return By default, returns lookup.acs if that was already in memory, but typically returns
#'   a data.frame with these fields:
#'   \itemize{
#'     \item Table ID
#'     \item Sequence Number
#'     \item Line Number
#'     \item Start Position
#'     \item Total Cells in Table
#'     \item Total Cells in Sequence
#'     \item Table Title
#'     \item Subject Area
#'   }
#'   \cr
#'   For ACS 2008-2012: \cr
#'   length(my.lookup[,1]) \cr
#'   [1] 24741\cr
#'   names(my.lookup)\cr
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"         "Line.Number"             "Start.Position"\cr
#'   [6] "Total.Cells.in.Table"    "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"\cr
#' @seealso \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust. 
#'   Also see \code{data(lookup.acs)}. Also see \code{\link{get.acs}} which uses this.
#' @examples 
#'  \dontrun{
#'  lookup.acs <- get.lookup.acs()
#'  }
#' @export
get.lookup.acs <- function(end.year="2012", folder=getwd()) {
  
  my.url.prefix.lookup.table <- get.url.prefix.lookup.table(end.year)  # paste("ftp://ftp.census.gov/acs", end.year, "_5yr/summaryfile/", sep="") # but lacking last /
  my.lookup.file.name <- get.lookup.file.name(end.year) # "Sequence_Number_and_Table_Number_Lookup.txt"
  
  # Use the working directory to download the file.
  if ( !exists("lookup.acs") ) {
    if (!file.exists(file.path(folder, my.lookup.file.name)) | file.size(file.path(folder, my.lookup.file.name))==0 ) {
      cat("  Downloading lookup table with table and variable names from", paste( my.url.prefix.lookup.table, my.lookup.file.name, sep=""),"\n")
      try(download.file( 
        paste( my.url.prefix.lookup.table, my.lookup.file.name, sep=""), 
        file.path(folder, my.lookup.file.name) 
      ))
      if (!file.exists(file.path(folder, my.lookup.file.name)) | file.size(file.path(folder, my.lookup.file.name))==0) {stop('Failed to download lookup table of variable names by table')}
      # could add error checking here to verify it was downloaded correctly
    }
    cat("  Reading lookup table with table and variable names\n")	
    # [File ID,]Table ID,Sequence Number,  Line Number,Start Position,  Total Cells in Table,  Total Cells in Sequence,  Table Title,Subject Area
    my.lookup <- read.csv(file.path(folder, my.lookup.file.name), stringsAsFactors=FALSE, colClasses=c(
      "character", "character", "character", "numeric", "numeric", "character", "numeric", "character", "character"))
    my.lookup$File.ID <- NULL	
    
    # could add error checking here to verify it was read from disk correctly ***
    
    return(my.lookup)
  } else {return(lookup.acs)}
}
