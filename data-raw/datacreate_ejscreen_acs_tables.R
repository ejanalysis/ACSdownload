######################### #
# tables needed for EJSCREEN ACS-based indicators as of EJSCREEN version 2.32 released 2024
# and also for EJAM version 2.32.003 released 11/2025,
# and also for the next two updates to use
# ACS 2019-2023 (released by Census 12/2024) https://www.census.gov/programs-surveys/acs/news/data-releases/2023/release.html
# ACS 2020-2024 (available from Census Bureau 12/2025) https://www.census.gov/programs-surveys/acs/news/data-releases/2024/release.html

ejscreen_acs_tables <- c(

  "B25034", # pre1960, for lead paint indicator (environmental not demographic per se)

  "B01001", # sex and age / basic population counts
  "B03002", # race with breakdown by hispanic ethnicity
  "B02001", # race without breakdown by hispanic ethnicity
  "B15002", # education (less than high school)
  "B23025", # unemployed
  "C17002", # low income, poor, etc.
  "B19301", # per capita income
  "B25032", # owned units vs rented units (occupied housing units, same universe as B25003)
  "B28003", # no broadband
  "B27010", # no health insurance
  "C16002", # (language category and) % of households limited English speaking (lingiso) "https://data.census.gov/table/ACSDT5Y2023.C16002"
  "B16004", # (language category and) % of residents (not hhlds) speak no English at all "https://data.census.gov/table/ACSDT5Y2023.B16004"

  "C16001", # languages detailed list: % of residents (not hhlds) speak Chinese, etc.  "https://data.census.gov/table/ACSDT5Y2023.C16001"
  # C16001 is at tract resolution only ########### #
  # B18101 is at tract resolution only ########### #
  "B18101" # disability -- at tract resolution only ########### #
)
#### #
url_acs_table(ejscreen_acs_tables)
######################### #

# see ACSdownload::acsdefaultendyearhere
# see https://ejanalysis.com for the EJAM package


endyear_used = acsdefaultendyearhere # from this package, should get updated yearly manually in datacreate_
yrs_range_guess = EJAM:::acs_yr_range(endyear_used)
release_date_guess <- paste0(endyear_used + 1, "-12-12")

metadata_here <- list(

  ejam_package_version         = c(Version = NA),     # "2.33.0"),     # change as needed ***
  ejscreen_version =     c(EJScreenVersion = NA),     # "2.33"),       # change as needed ***
  ejscreen_releasedate = c(EJScreenReleaseDate = NA), # "2026-02-01"), # change as needed ***

  # ACS 2019-2023 (released by Census 12/2024) https://www.census.gov/programs-surveys/acs/news/data-releases/2023/release.html
  # ACS 2020-2024 (available from Census Bureau 12/2025) https://www.census.gov/programs-surveys/acs/news/data-releases/2024/release.html

  acs_releasedate = c(ACSReleaseDate = release_date_guess),
  acs_version     = c(ACSVersion = yrs_range_guess), # e.g., "2019-2023"

  census_version = c(CensusVersion = "2020"),
  date_saved_in_package = Sys.Date()
)
for (i in 1:length(metadata_here)) {
  attr(ejscreen_acs_tables, names(metadata_here)[i]) <- metadata_here[[i]]
}

usethis::use_data(ejscreen_acs_tables, overwrite = TRUE)

  EJAM:::dataset_documenter(
    "ejscreen_acs_tables",
    "tables needed for EJSCREEN ACS-based indicators as of EJSCREEN version 2.32 released 2024 and also for EJAM version 2.32.003 released 11/2025"
    )
