##################### ###################### #

# script to update datasets each year

##################### #

# specify end.year for 5year ACS data ####

### generally this will be correct:
lastyear <- as.numeric(substr(as.character(Sys.Date()), 1, 4)) - 1
end.year <- lastyear - 1 # published Dec 2023 means survey end date was 2022
### or could want to use an earlier year as default !
# end.year <- 2022
validate.end.year(end.year)

# check if this is available yet:
browseURL(dirname(paste0(get.url.prefix.lookup.table(end.year), get.lookup.file.name(end.year))))


# metadata to be stored as attributes of data object
met = list(
  date_updated          = as.character(Sys.Date()),
  date_saved_in_package = as.character(Sys.Date()),
  date_downloaded       = as.character(Sys.Date()),
  acs_releasedate =     paste0(end.year, "-12"),  #"2023-12-07",
  acs_version =         paste0(end.year - 4, "-", end.year), # "2018-2022",
  end.year = end.year
)

acsdefaultendyearhere <- end.year

acsfirstyearavailablehere <- 2018

for (i in 1:length(met)) {
  attr(acsdefaultendyearhere, which = names(met)[i]) <- met[[i]]
}

cbind(attributes(acsdefaultendyearhere))

# save those for package ####
usethis::use_data(acsfirstyearavailablehere, overwrite = TRUE)
usethis::use_data(acsdefaultendyearhere, overwrite = TRUE)
##################### #

# download new lookup.acs ####
# info on ACS variable names and ACS tables

lookup.acs <- ACSdownload::download.lookup.acs(end.year = end.year)

## if EJAM pkg is installed:
# lookup.acs2022 <- EJAM:::metadata_add(lookup.acs2022, metadata = met)
## which would essentially do this:
for (i in 1:length(met)) {
  attr(lookup.acs, which = names(met)[i]) <- met[[i]]
}
# update the default, lookup.acs
# and also save the copy with a year-specific name
newname = paste0("lookup.acs", end.year)
assign(newname, lookup.acs)
# save lookup.acs for package ####
usethis::use_data(lookup.acs, overwrite = TRUE)
text_to_do <- paste0("usethis::use_data(", newname, ", overwrite=TRUE)")
eval(parse(text = text_to_do))
## usethis::use_data(lookup.acs2022, overwrite = TRUE)


rm(text_to_do, newname, lookup.acs, i, met, end.year, lastyear)

 ############################################## #
# > head(lookup.acs2022)
# Table.ID Line Indent  Unique.ID          Label      Title         Universe Type
# 1   B01001    1      0 B01001_001         Total: Sex by Age Total population  int
# 2   B01001    2      1 B01001_002          Male: Sex by Age Total population  int
# 3   B01001    3      2 B01001_003  Under 5 years Sex by Age Total population  int
# 4   B01001    4      2 B01001_004   5 to 9 years Sex by Age Total population  int
# 5   B01001    5      2 B01001_005 10 to 14 years Sex by Age Total population  int
# 6   B01001    6      2 B01001_006 15 to 17 years Sex by Age Total population  int

#   # See [https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/]
