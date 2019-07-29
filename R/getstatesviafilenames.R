#' @title Infer US States based on ACS 5-yr filenames in folder
#' @description Helper function to look for unzipped csv files of estimates for American Community Survey (ACS)
#'   5-year summary file data obtained from US Census FTP site, based on pattern matching, and infer State abbreviations
#'   based on those filenames.
#' @param folder Default is current working directory.
#' @return Returns a vector of unique upper case US State abbreviations
#' @seealso \code{\link{read.concat.states}} which uses this
#' @export
getstatesviafilenames <- function(folder = getwd()) {
  # infer states based on what filenames are found in folder
  #getstatesviafilenames <- function(folder=getwd(), seqfilelistnums, end.year = '2017' ) {
  is.datafilename <-
    function(x) {
      grepl(pattern = '[em]20[0-9][0-9]5[a-z][a-z][0-9]*\\.txt', x)
    }
  found.efiles.not.us <- list.files(path = folder)
  found.efiles.not.us <-
    found.efiles.not.us[is.datafilename(found.efiles.not.us)]
  mystates <- toupper(unique(substr(found.efiles.not.us, 7, 8)))
  allstates.no.us <-
    gsub('US', '', ejanalysis::get.state.info(fields = 'ST'))
  mystates <- mystates[mystates %in% allstates.no.us]
  return(mystates)
  
  # older version that gave more exact check based on supplied year and sequence file numbers:
  #       allstates.no.us <- gsub('US', '', ejanalysis::get.state.info(fields = 'ST'))
  #       all.efiles.not.us <- datafile(allstates.no.us, seqfilelistnums[1], end.year = end.year)
  #       mystates <- unique(allstates.no.us[all.efiles.not.us %in% list.files(path = folder)] )
  #       return(mystates)
  # to use old version: #mystates <- getstatesviafilenames(folder = folder, seqfilelistnums = seqfilelistnums.mine, end.year = end.year )
}
