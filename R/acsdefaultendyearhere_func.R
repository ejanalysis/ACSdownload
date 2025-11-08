#' Earliest end.year of ACS 5 year survey data available (according to this package, or best guess)
#'
#' @export
#'
acsdefaultendyearhere_func <- function() {

  if (exists("acsdefaultendyearhere")) {
    yr <- acsdefaultendyearhere
    if (!validate.end.year(yr)) {
      stop("unable to confirm that", yr, "is a valid end.year for 5yr ACS data")
    }
  } else {
    yr <- guess_end_year() # does validate.end.year
  }
  return(yr)
}
############

guess_end_year = function() {

  # note there is better, related code in EJAM::acsendyear() that can estimate latest acs version based on likely release date and also when ejscreen might get updated using that

  ## specify end.year for 5year ACS data
  ### generally this will be correct:
  lastyear <- as.numeric(substr(as.character(Sys.Date()), 1, 4)) - 1
  end.year <- lastyear - 1 # published Dec 2023 means survey end date was 2022, e.g.
  # in other words, year now minus 2 years gives endyear of acs that is latest published.

  # check if url/year available yet:
  if (validate.end.year(end.year)) {
    cat("end.year will be", end.year, "\n")
    return(end.year)
  } else {
    stop("cannot infer valid end.year for 5yr ACS data")
  }
}
############
