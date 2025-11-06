##################### ###################### #

# script to update datasets each year
# info on ACS variable names and ACS tables
##################### ###################### #

# Starting with the 2022 data release, the Table-Based Format is the only format available.
# https://www.census.gov/programs-surveys/acs/data/summary-file.html
#
# The Table-Based ACS Summary File contains three file types:
#
#  1. Table Labels - Description of each line item in a table for 1-year or 5-year data release
#
# Example File Name: ACS20211YR_Table_Shells.txt or      ACS20215YR_Table_Shells.txt
# Example: B01001_003 = “SEX BY AGE - Total Males Under 5 Years”
#
# 2. Geography Labels - All geography labels for 1-year or 5-year data release
#
# Example File Name: Geos20211YR.txt or Geos20215YR.txt
# Example: 0400000US06 = “California”
#
# 3. Data Files - Data (including estimates, margins of error, and geographies) organized by table ID for 1-year or 5-year release
# Folder: 1YRData, 5YRData
# Example: The file acsdt1y2021-b01001.dat, variable B01001_E003      for 0400000US06 = 1,129,355

##################### #
## do this first:

devtools::load_all()
##################### #
set_metadata = function(lookup.this, end.this = end.year) {
  # metadata to be stored as attributes of data object
  met = list(
    date_updated          = as.character(Sys.Date()),
    date_saved_in_package = as.character(Sys.Date()),
    date_downloaded       = as.character(Sys.Date()),
    acs_releasedate =     paste0(end.this, "-12"),  #"2023-12-07",
    acs_version =         paste0(end.this - 4, "-", end.this), # "2018-2022",
    end.year = end.this
  )
  for (i in 1:length(met)) {
    attr(lookup.this, which = names(met)[i]) <- met[[i]]
  }
  return(lookup.this)
}
###################### #

# YEAR ####

## specify end.year for 5year ACS data
### generally this will be correct:
lastyear <- as.numeric(substr(as.character(Sys.Date()), 1, 4)) - 1
end.year <- lastyear - 1 # published Dec 2023 means survey end date was 2022
###################### #
# check if url/year available yet:
cat("end.year will be", end.year, "\n")
validate.end.year(end.year)
browseURL(dirname(paste0(get.url.prefix.lookup.table(end.year), get.lookup.file.name(end.year))))
###################### #

## acsdefaultendyearhere (save in package) ####

acsdefaultendyearhere <- end.year
acsdefaultendyearhere <- set_metadata(acsdefaultendyearhere)
cbind(attributes(acsdefaultendyearhere))
usethis::use_data(acsdefaultendyearhere, overwrite = TRUE)

acsfirstyearavailablehere <- 2018
usethis::use_data(acsfirstyearavailablehere, overwrite = TRUE)
############################################################## #

# DOWNLOAD ####

lookup.acs <- download.lookup.acs(end.year = end.year)

  # to re-download older lookup.acs

# lookup.acs2019 <- download.lookup.acs(end.year = 2019)
# lookup.acs2020 <- download.lookup.acs(end.year = 2020)
# lookup.acs2021 <- download.lookup.acs(end.year = 2021)

# METADATA ####

lookup.acs     = set_metadata(lookup.acs, end.year)

# lookup.acs2019 = set_metadata(lookup.acs2019, 2019)
# lookup.acs2020 = set_metadata(lookup.acs2020, 2020)
# lookup.acs2021 = set_metadata(lookup.acs2021, 2021)

# USE IN PACKAGE ####

usethis::use_data(lookup.acs, overwrite = TRUE)

## usethis::use_data(lookup.acs2019, overwrite = TRUE)
## usethis::use_data(lookup.acs2020, overwrite = TRUE)
## usethis::use_data(lookup.acs2021, overwrite = TRUE)


# and also save the copy with a year-specific name
newname = paste0("lookup.acs", end.year)
assign(newname, lookup.acs)
text_to_do <- paste0("usethis::use_data(", newname, ", overwrite=TRUE)")
eval(parse(text = text_to_do))

##################### ###################### #

rm(text_to_do, newname, lookup.acs, i, met, end.year, lastyear)

 ############################################## #

head(lookup.acs2019)
head(lookup.acs2020)
head(lookup.acs2021)

# Table.ID Line Indent  Unique.ID          Label      Title         Universe Type
# 1   B01001    1      0 B01001_001         Total: Sex by Age Total population  int
# 2   B01001    2      1 B01001_002          Male: Sex by Age Total population  int
# 3   B01001    3      2 B01001_003  Under 5 years Sex by Age Total population  int
# 4   B01001    4      2 B01001_004   5 to 9 years Sex by Age Total population  int
# 5   B01001    5      2 B01001_005 10 to 14 years Sex by Age Total population  int
# 6   B01001    6      2 B01001_006 15 to 17 years Sex by Age Total population  int

#   # See https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/
