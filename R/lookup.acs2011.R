#' @name lookup.acs2011
#' @docType data
#' @aliases Sequence_Number_and_Table_Number_Lookup
#' @title Sequence_Number_and_Table_Number_Lookup.txt for 2007-2011 ACS dataset
#' @description This data set provides information about variables in tables forming the American Community Survey (ACS) 5-year summary file.
#' @usage data('lookup.acs2011')
#' @source For the 2007-2011 dataset, \url{ftp://ftp.census.gov/acs2011_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt}
#'   obtained July 2015. 
#' @keywords datasets
#' @format A data.frame with these fields: \cr
#'    'data.frame':	xxx obs. of  8 variables:
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
#' @seealso  \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust. 
#'   Also see \code{\link{get.lookup.acs}} which downloads these files. 
#'   Also see \code{\link{get.acs}}.
#' @examples 
#'  \dontrun{
#'  data(lookup.acs2011, package='ACSdownload')
#'  # or 
#'  lookup.acs <- ACSdownload::get.lookup.acs(2011)
#'  # or related info from
#'  acs::acs.lookup()
#'  }
NULL
