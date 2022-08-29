#' @name lookup.acs2020
#' @docType data
#' @title ACS_5yr_Seq_Table_Number_Lookup.txt for ACS dataset
#' @description This data set provides information about variables
#'   in tables forming the American Community Survey (ACS) 5-year summary file.
#'   The data and documentation for the 5 years ending in year X
#'   is typically available by December of the year X+1, so 2016-2020 was planned for Dec 2021 but actually out March 2022.
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
#' @format A data.frame   \cr
#'   \code{
#'   dim(lookup.acs2020)
#'   [1] 30326     9
#'   names(lookup.acs2020)
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"        
#'   [4] "Line.Number"             "Start.Position"          "Total.Cells.in.Table"   
#'   [7] "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"           
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
