
# Earliest end.year of ACS 5 year survey data available
# (according to this package, or best guess)

acsdefaultendyearhere_func <- function() {

  if (exists("acsdefaultendyearhere")) {
    yr <- acsdefaultendyearhere
    if (!validate.end.year(yr)) {
      stop("unable to confirm that", yr, "is a valid end.year for 5yr ACS data")
    }
  } else {
    yr <- guess_end_year() # does validate.end.year
  }
  return(as.numeric(yr))
}
############

guess_end_year = function(guess_as_of = Sys.Date()) {

  end.year <- try( EJAM:::acsendyear(

    # guess_always = TRUE,
    guess_census_has_published = TRUE,
    guess_as_of = guess_as_of))

  if (inherits(end.year, "try-error")) {
    warning("To be accurate, guess_end_year() or  acsdefaultendyearhere_  func() requires the EJAM package be installed. See https://ejanalysis.com for info on the EJAM pkg")
    lag_yrs_endyr_to_census_publishes <- 0.9452055 # 1- 20/365 # like EJAM:::acsendyear(), based on typical 12/11/20xx release date approx.
    return(
      as.numeric(
      substr(  guess_as_of - 365 * lag_yrs_endyr_to_census_publishes, 1, 4)
    )
    )
  }
  return(as.numeric(end.year))
}
############
