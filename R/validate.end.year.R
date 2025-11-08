############### #

## check if end.year is plausible, and if the census.gov site has corresponding directory

## see  acsdefaultendyearhere_func()  for guess of what the latest end.year is right now

validate.end.year = function(end.year) {

  # is end.year the right format at all?
  if (length(end.year) != 1) {stop('end.year must be a single value, length 1, not NULL')}
  suppressWarnings({end.year <- as.numeric(end.year)})
  if (any(is.na(end.year))) {stop('end.year must be a number, not text, empty, NA, etc.')}
  stopifnot(is.atomic(end.year))
  if (round(end.year) != end.year) {stop("end.year must be an integer")}

  # is end.year in range that seems plausible?
  if (!exists("acsfirstyearavailablehere")) {acsfirstyearavailablehere <- 2018} # was 2018 in ACSdownload pkg but formats changed completely in 2022 dataset ACS5yr
  thisyear <- data.table::year(Sys.Date())
  year_seems_plausible <- end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1))
  if (!year_seems_plausible) {
    stop('end.year must be a plausible year')
  } else {

    # now check if census bureau website has a directory that matches that year

    urlx <- get.url.prefix.lookup.table(end.year)
    url_seems_ok <- url_online_census(urlx)
    if (!url_seems_ok) {
      stop('Expected URL for end.year ', end.year, ' cannot be reached: ', urlx)
      # "https://www2.census.gov/programs-surveys/acs/summary_file/2023/table-based-SF/documentation/"
      # browseURL(dirname(paste0(get.url.prefix.lookup.table(end.year), get.lookup.file.name(end.year))))
    }
  }
  return(TRUE)
}
############### #

offline_census = function (url = "census.gov") {

  hasinternet = !is.null(curl::nslookup(url, error = FALSE))
  return(!hasinternet)
}
############### #

url_online_census = function (url = "census.gov") {

  # if (missing(url)) {
  #   stop("must specify a URL to check")
  # }
  if (length(url) > 1) {
    stop("can only check one URL at a time using url_online_census()")
  }
  if (offline_census()) {
    warning("Cannot check URL when offline -- internet connection does not seem to be available")
    return(NA)
  }
  x <- httr2::request(url)
  junk <- capture.output({
    x <- try(httr2::req_perform(x), silent = TRUE)
  })
  if (inherits(x, "try-error")) {
    return(FALSE)
  }
  if (!("status_code" %in% names(x))) {
    return(FALSE)
  }
  if (x$status_code != 200) {
    return(FALSE)
  }
  else {
    return(TRUE)
  }
}
############### #
