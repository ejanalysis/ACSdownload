#' @name geoformat2020
#' @docType data
#' @title geographic information for ACS dataset
#' @description This data set has the format used by geographic identifier files 
#'   in the American Community Survey (ACS) 5-year summary file.
#'   The data and documentation for the 5 years ending in year X
#'   is typically available by December of the year X+1, so 2016-2020 was available by Dec 2021.
#' @details  
#'  geoformat2020 <- geoformat2019 # if they are assumed to be the same.
#' metadata <- list(ejscreen_releasedate = 'late 2022', ejscreen_version = '2.1', ACS_version = '2016-2020', ACS_releasedate = '3/17/2022')
#' # attributes(geoformat2020) <- c(attributes(geoformat2020), metadata)
#' # OR... try   attr(x, which=names(metadata[n])) <- metadata[n] 
#'  attr(geoformat2020, which = 'ejscreen_releasedate') <- 'late 2022'
#'  attr(geoformat2020, which = 'ejscreen_version') <- '2.1'
#'  attr(geoformat2020, which = 'ACS_version') <- '2016-2020'
#'  attr(geoformat2020, which = 'ACS_releasedate') <- '3/17/2022'
#'  usethis::use_data(geoformat2020)
#' 
#'  # see data at 
#' browseURL('https://www2.census.gov/programs-surveys/acs/summary_file/2019/data/5_year_seq_by_state/UnitedStates/Tracts_Block_Groups_Only/')
#' but that is not available in analogous URL for 2020.
#'
#'  ##geo files:
#'  ## browseURL('https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/geography/5yr_year_geo/')
#' setwd('~/R/ACSdownload/inst/')
#' download.file('https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/geography/5yr_year_geo/g20195us.csv', destfile = 'g20195us.csv')
#' that is the full US geo file, not what I call the geoformat file (which is tiny)
#' 
#'  2018 and 2019 lack the normal geo file documentation they used to have
#'  also, read.geo() used read.fwf() at least for older years. 2018 or 2019 might have csv not just txt format now?
#' 
#'  there is this:
#'    
#'    https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/tech_docs/ACS_2018_SF_5YR_Appendices.xls
#'    
#'     @source Table found in given year dataset, info at
#'  \url{https://www.census.gov/programs-surveys/acs/library/handbooks/geography.html}
#'  \url{https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html}
#'  \url{https://www2.census.gov/programs-surveys/acs/summary_file/2020/data/5_year_entire_sf/2020_ACS_Geography_Files.zip}
#' @keywords datasets
#' @format A data.frame
#'  \preformatted{
#'  'data.frame':	53 obs. of  5 variables:  (at least for 2019 version)
#'  $ varname    : chr  "FILEID" "STUSAB" "SUMLEVEL" "COMPONENT" ...
#'  $ description: chr  "Always equal to ACS Summary File identification" "State Postal Abbreviation" "Summary Level" "Geographic Component" ...
#'  $ size       : num  6 2 3 2 7 1 1 1 2 2 ...
#'  $ start      : num  1 7 9 12 14 21 22 23 24 26 ...
#'  $ type       : chr  "Record" "Record" "Record" "Record" ...
#'   }
#' @seealso  \code{\link{get.acs}}
NULL
