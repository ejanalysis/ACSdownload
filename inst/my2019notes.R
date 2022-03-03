# # American Community Survey directories are located on the FTP server at www2.census.gov/programs-surveys/acs/. 
# If you are using a FTP client, the server address is ftp2.census.gov.

# this worked at least: download.file('https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt', destfile = 'ACS_5yr_Seq_Table_Number_Lookup.txt')


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


# to create newer format files, started to try this:
if (1=0) {
  geoformat2018 <- geoformat2017  # assume it did not change
  geoformat2018 <- edit(geoformat2018) # if want to view or edit
  
  geoformat2019 <- geoformat2018  # assume it did not change- seems to work for 2018 and 2019 files.
  
  setwd('~/R/ACSdownload/data')
  save(geoformat2018, file = 'geoformat2018.rdata')
  save(geoformat2019, file = 'geoformat2019.rdata')
  
  # geo is created via get.read.geo which uses download.geo and read.geo and then does some cleanup.
  library(ACSdownload)
  
  ############### seems to work for 2018 and 2019 files.
  yr = 2019
  download.geo(c('de', 'dc'), end.year = yr, folder = '~/R/junk', testing = TRUE)
  g1 <- read.geo(c('de', 'dc'), end.year = yr, folder = '~/R/junk')
  
  
}
