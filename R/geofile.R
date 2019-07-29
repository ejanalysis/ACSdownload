#' @title Get name(s) of GEO txt file(s) with geo information for ACS
#' @description
#'  Get name of text file used by US Census Bureau with geographic information for American Community Survey.
#'  That geo file can be used to join data file(s) to FIPS/GEOID/NAME/SUMLEVEL/CKEY.
#' @param mystates vector of character 2-letter State abbreviations specifying which are needed
#' @param end.year end.year of 5-year summary file such as '2018'
#' @return Character vector of file names, example: "g20105md.txt"
#'   Note this is only needed once per state, not once per seqfile. (It might even be available as a single US file?)
#' @seealso \code{\link{get.acs}} and \code{\link{download.geo}} which uses this
#' @export
geofile <- function(mystates, end.year = '2017') {
  if (missing(mystates)) {
    #mystates <- ejanalysis::get.state.info(fields='ST')
    data(lookup.states, package = 'proxistat', envir = environment())
    mystates <- lookup.states$ST
  }
  datafile.prefix <- get.datafile.prefix(end.year = end.year)
  geofile.prefix =	paste("g", datafile.prefix, sep = "")
  geofile.states = 	tolower(mystates)
  geofile.suffix = 	".txt"
  geofile = paste(geofile.prefix, geofile.states, geofile.suffix, sep =
                    "")
  return(geofile)
}
