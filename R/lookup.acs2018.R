#' @name lookup.acs2018
#' @docType data
#' @title ACS_5yr_Seq_Table_Number_Lookup.txt for ACS dataset
#' @description This data set provides information about variables
#'   in tables forming the American Community Survey (ACS) 5-year summary file.
#'   The data and documentation for the 5 years ending in year X
#'   is typically available by December of the year X+1, so 2014-2018 would be available by Dec 2019.
#'   @details 
#'   # example of how data was imported after download
#' # 
#' # setwd('~/R/ACSdownload/inst/')
#' # download.file('https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt', destfile = 'ACS_5yr_Seq_Table_Number_Lookup-2018.txt')
#' # lookup.acs2018 <- readr::read_csv('ACS_5yr_Seq_Table_Number_Lookup-2018.txt')
#' # lookup.acs2018 <- data.frame(lookup.acs2018, stringsAsFactors = FALSE)
#' # setwd('~/R/ACSdownload/data')
#' # save(lookup.acs2018, file = 'lookup.acs2018.rdata')
#' @keywords datasets
#' @format A data.frame with these fields: \cr
#'    'data.frame':	approx 25074 obs. of approx  8 variables:
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
#'  lookup.acs <- ACSdownload::get.lookup.acs(2018)
#'  # or related info from
#'  acs::acs.lookup()
#'  }
NULL
