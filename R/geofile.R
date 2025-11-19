#' @title Get name(s) of GEO txt file(s) with geo information for ACS
#' @description
#'  Get name of text file used by US Census Bureau with geographic information for American Community Survey.
#'  That geo file can be used to join data file(s) to FIPS/GEOID/NAME/SUMLEVEL/CKEY.
#' @param mystates vector of character 2-letter State abbreviations specifying which are needed
#' @param end.year end.year of 5-year summary file such as '2021'
#' @return Character vector of file names, example: "g20215md.txt"
#'   Note this is only needed once per state, not once per seqfile. (It might even be available as a single US file?)
#' @seealso [get_acs_old()] and [download.geo()] which uses this
#'
geofile <- function(mystates, end.year = acsdefaultendyearhere) {

  validate.end.year(end.year)

  if (missing(mystates)) {
    # mystates <- proxistat::lookup.states$ST
    mystates <- c(
      "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL",
      "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
      "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM",
      "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN",
      "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY",
      "PR",
      "VI", "AS", "GU", "MP"
      # , "UM",
      )
    # , "US")
  }

  #
  # "https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/Geos20225YR.txt"

  datafile.prefix <- get.datafile.prefix(end.year = end.year)
  geofile.prefix =	paste("g", datafile.prefix, sep = "")
  geofile.states = 	tolower(mystates)
  geofile.suffix = 	".txt"
  geofile = paste(geofile.prefix, geofile.states, geofile.suffix, sep =
                    "")
  return(geofile)
}
