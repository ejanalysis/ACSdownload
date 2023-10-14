install.packages("totalcensus")
# devtools::install_github("GL-Li/totalcensus")

file.create("~/Documents/acs21")
dir("~/Documents/acs21")

library(totalcensus)
# set_path_to_census("~/Documents/acs21") # this is buggy - failed to do it right
# so manually added a line to .Renviron  
# usethis::edit_r_environ()  # added this line:
#   PATH_TO_CENSUS='/Users/markcorrales/Documents/acs21'

states_DC <- sort(c(state.abb, 'DC'))
home_national <- read_acs5year(
  year = 2021,
  states = states_DC,   # all 50 states plus DC
  table_contents = "home_value = B25077_001",
  summary_level = "block group"
)
