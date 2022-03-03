#' @title Get name(s) of zip file(s) for ACS 5-year summary file data
#'
#' @description Returns name(s) of zip file(s) based on state(s), a sequence file number, a prefix, and end year.
#' @param mystates Required vector of 2-character state abbreviation(s)
#' @param seqfilenum Required single sequence file number used by ACS 5-year summary file
#' @param end.year Optional end year for 5-year summary file, as character, like '2018'
#' @param zipfile.prefix Optional character element, defaults to value looked up based on end.year.
#' @return Returns character element that is name of zip file such as "20115dc0113000.zip"
#' @seealso \code{\link{get.acs}}
#' @export
zipfile <-
  function(mystates,
           seqfilenum,
           zipfile.prefix,
           end.year = acsdefaultendyearhere_func()) {
    # zip FILENAME example
    # 	20115dc0113000.zip
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    if (missing(zipfile.prefix)) {
      zipfile.prefix    <- get.zipfile.prefix(end.year)
    }
    zipfile.states <- tolower(mystates)
    zipfile.seqfilenum <- analyze.stuff::lead.zeroes(seqfilenum,4)
    zipfile.suffix <- "000.zip"
    zipfile <-
      paste(zipfile.prefix,
            zipfile.states,
            zipfile.seqfilenum,
            zipfile.suffix,
            sep = "")
    return(zipfile)
  }
