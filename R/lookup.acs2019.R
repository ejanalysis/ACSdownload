#' @name lookup.acs2019
#' @docType data
#' @title ACS_5yr_Seq_Table_Number_Lookup.txt for ACS dataset
#' @description This data set provides information about variables
#'   in tables forming the American Community Survey (ACS) 5-year summary file.
#'   The data and documentation for the 5 years ending in year X
#'   is typically available by December of the year X+1, so 2015-2019 was available by Dec 2020.
#' \preformatted{
#'  # example of how data was imported after download
#'  # 
#'  # setwd('./inst/')
#'  # download.file('https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt', destfile = 'ACS_5yr_Seq_Table_Number_Lookup.txt')
#'  # lookup.acs2019 <- readr::read_csv('ACS_5yr_Seq_Table_Number_Lookup.txt')
#'  # lookup.acs2019 <- data.frame(lookup.acs2019, stringsAsFactors = FALSE)
#'  # save(lookup.acs2019, file = './data/lookup.acs2019.rdata') # or usethis::use_data(lookup.acs2019)
#' }
#' @keywords datasets
#' @format A data.frame with these fields: \cr
#'    'data.frame':	 29501 obs. of 9 variables:
#'   \itemize{
#'     \item $ File.ID               : chr  "ACSSF"  ...
#'     \item $ File.ID                : chr  "ACSSF" "ACSSF" "ACSSF" "ACSSF" ...
#'     \item $ Table.ID               : chr  "B01001" "B01001" "B01001" "B01001" ...
#'     \item $ Sequence.Number        : chr  "0001" "0001" "0001" "0001" ...
#'     \item $ Line.Number            : num  NA NA 1 2 3 4 5 6 7 8 ...
#'     \item $ Start.Position         : num  7 NA NA NA NA NA NA NA NA NA ...
#'     \item $ Total.Cells.in.Table   : chr  "49 CELLS" NA NA NA ...
#'     \item $ Total.Cells.in.Sequence: num  NA NA NA NA NA NA NA NA NA NA ...
#'     \item $ Table.Title            : chr  "SEX BY AGE" "Universe:  Total population" "Total:" "Male:" ...
#'     \item $ Subject.Area           : chr  "Age-Sex" NA NA NA ...
#'   }
#' @seealso  \code{\link[acs]{acs.lookup}} which does something similar but is more flexible & robust.
#'   Also see \code{\link{get.lookup.acs}} which downloads these files.
#'   Also see \code{\link{get.acs}}.
#' @examples
#'  \dontrun{
#'  data(lookup.acs2019, package='ACSdownload')
#'  # or
#'  lookup.acs <- ACSdownload::get.lookup.acs(2019)
#'  # or related info from
#'  acs::acs.lookup()
#'  }
NULL
