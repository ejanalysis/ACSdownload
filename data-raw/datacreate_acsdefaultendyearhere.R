# ---------------------------------------------------------------------------- #
# Re-create the `acsdefaultendyearhere` and `acsfirstyearavailablehere` data
# objects shipped with the package. Run with:
#
#   devtools::load_all(".")
#   source("data-raw/datacreate_acsdefaultendyearhere.R")
# ---------------------------------------------------------------------------- #


# The default ACS 5-year end year used by `get_acs_new()` and friends when the
# caller does not pass `yr`. Update after each new Census Bureau release.
acsdefaultendyearhere <- 2024
usethis::use_data(acsdefaultendyearhere, overwrite = TRUE)


# The earliest end year `get_acs_new()` can target. The package only supports
# the table-based summary file format introduced for the 2018-2022 vintage
# (released December 7, 2023), so this floor is 2022. The data object is used
# by `validate_acs_endyear()`.
acsfirstyearavailablehere <- 2022
usethis::use_data(acsfirstyearavailablehere, overwrite = TRUE)
