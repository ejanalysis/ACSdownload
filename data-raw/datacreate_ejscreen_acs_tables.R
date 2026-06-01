# ---------------------------------------------------------------------------- #
# Re-create the `ejscreen_acs_tables` data object shipped with the package.
#
# Authoritative source: EJAM's `tables_ejscreen_acs` on the ACS2024 branch.
# Whenever EJAM updates its list, mirror it here. Run with:
#
#   devtools::load_all(".")
#   source("data-raw/datacreate_ejscreen_acs_tables.R")
# ---------------------------------------------------------------------------- #


# Mirror of EJAM::tables_ejscreen_acs (ACS2024 branch, EJAM 2.5.0, 2026-05-25).
# Keep the order matching EJAM so downstream code that indexes by position
# behaves identically against either package.
ejscreen_acs_tables <- c(

  # BLOCK GROUP-resolution tables used by EJSCREEN
  "B25034", # pre-1960 housing, for lead paint indicator (environmental)
  "B01001", # sex and age / basic population counts
  "B03002", # race with hispanic ethnicity
  "B02001", # race without hispanic ethnicity
  "B15002", # education
  "B23025", # unemployed
  "C17002", # low income, poverty-ratio population universe, etc.
  "B17017", # households below poverty level
  "B19301", # per capita income
  "B25032", # owned units vs rented units (occupied housing units; same
            # universe as B25003)
  "B28002", # no broadband internet subscription
  "B27010", # no health insurance (Census-defined civilian noninstitutionalized
            # population universe)
  "C16002", # household language by limited-English-speaking status;
            # `lingiso` and limited-English household language breakdowns
  "B16004", # language category and % of residents (not households) speaking
            # no English at all

  # TRACT-only tables that EJSCREEN repeats onto each blockgroup in the tract.
  # When `fips = "blockgroup"`, these filter to zero rows and are dropped from
  # any merged result.
  "C16001", # detailed languages spoken (tract only)
  "B18101"  # disability (tract only)
)


# Provenance/metadata attributes mirroring EJAM's conventions.
endyear_used      <- 2024  # acsdefaultendyearhere (Phase 6)
yrs_range_guess   <- paste0(endyear_used - 4L, "-", endyear_used)
release_date_guess <- "2026-01-29"  # actual 2020-2024 ACS release date

metadata_here <- list(
  ejam_package_version  = c(Version = NA_character_),
  ejscreen_version      = c(EJScreenVersion = NA_character_),
  ejscreen_releasedate  = c(EJScreenReleaseDate = NA_character_),
  acs_releasedate       = c(ACSReleaseDate = release_date_guess),
  acs_version           = c(ACSVersion = yrs_range_guess),
  census_version        = c(CensusVersion = "2020"),
  date_saved_in_package = as.character(Sys.Date())
)
for (i in seq_along(metadata_here)) {
  attr(ejscreen_acs_tables, names(metadata_here)[i]) <- metadata_here[[i]]
}

usethis::use_data(ejscreen_acs_tables, overwrite = TRUE)
