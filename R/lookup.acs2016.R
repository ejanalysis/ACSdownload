#' @name lookup.acs2016
#' @docType data
#' @title ACS_5yr_Seq_Table_Number_Lookup.txt for 2012-2016 ACS dataset
#' @description This data set provides information about variables in tables forming the American Community Survey (ACS) 5-year summary file.
#' @usage data('lookup.acs2016')
#' @source For the 2012-2016 dataset, \url{http://www2.census.gov/programs-surveys/acs/summary_file/2016/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt}
#'   obtained July 20, 2018.
#' @keywords datasets
#' @format A data.frame with these fields: \cr
#'    'data.frame':	25074 obs. of  8 variables:
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
#' @seealso  \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust.
#'   Also see \code{\link{get.lookup.acs}} which downloads these files.
#'   Also see \code{\link{get.acs}}.
#' @examples
#'  \dontrun{
#'  data(lookup.acs2016, package='ACSdownload')
#'  # or
#'  lookup.acs <- ACSdownload::get.lookup.acs(2016)
#'  # or related info from
#'  acs::acs.lookup()
#'  }
NULL
