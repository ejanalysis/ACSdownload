#' @name lookup.acs
#' @docType data
#' @aliases Sequence_Number_and_Table_Number_Lookup
#' @title Sequence_Number_and_Table_Number_Lookup.txt for 2008-2012 ACS dataset
#' @description This data set provides a variety of health indicators for each US county.
#' @usage data('lookup.acs')
#' @source \url{ftp://ftp.census.gov/acs2012_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt}
#'   obtained July 2015
#' @keywords datasets
#' @format A data.frame with these fields: \cr
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
#'   length(lookup.acs[,1]) \cr
#'   [1] 24741\cr
#'   names(lookup.acs)\cr
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"         "Line.Number"             "Start.Position"\cr
#'   [6] "Total.Cells.in.Table"    "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"\cr
#'    \cr
#'    'data.frame':	24741 obs. of  8 variables:
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
#' @seealso \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust. 
#'   Also see \code{\link{get.lookup.acs}}. 
#'   Also see \code{\link{get.acs}}.
#' @examples 
#'  \dontrun{
#'  data(lookup.acs, package='ACSdownload')
#'  # or 
#'  lookup.acs <- ACSdownload::get.lookup.acs()
#'  # or related info from
#'  acs::acs.lookup()
#'  }
NULL