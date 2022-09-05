# # American Community Survey directories are located on the FTP server at www2.census.gov/programs-surveys/acs/. 
# If you are using a FTP client, the server address is ftp2.census.gov.


## start in the root folder of the package

mydir <- '~/../Downloads/acstest'
if (!dir.exists(mydir)) {
  dir.create(mydir)
}

library(ACSdownload)

 # see data at 
# browseURL('https://www2.census.gov/programs-surveys/acs/summary_file/2019/data/5_year_seq_by_state/UnitedStates/Tracts_Block_Groups_Only/')
# but that is not available in analogous URL for 2020.

###geo files:
### browseURL('https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/geography/5yr_year_geo/')
# setwd('~/R/ACSdownload/inst/')
# download.file('https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/geography/5yr_year_geo/g20195us.csv', destfile = 'g20195us.csv')
# that is the full US geo file, not what I call the geoformat file (which is tiny)

#  2018 and 2019 lack the normal geo file documentation they used to have
#  also, read.geo() used read.fwf() at least for older years. 2018 or 2019 might have csv not just txt format now?
# 
#  there is this:
#    
#    https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/tech_docs/ACS_2018_SF_5YR_Appendices.xls
 
