#' @title Infer Sequence file numbers based on ACS 5-yr filenames in folder
#' @description Helper function to look for unzipped csv files of estimates for American Community Survey (ACS)
#'   5-year summary file data obtained from US Census FTP site, based on pattern matching, and infer seqfile numbers
#'   based on those filenames.
#' @param folder Default is current working directory.
#' @return Returns a character vector of unique sequence file numbers
#' @seealso [read.concat.states()] which uses this
#'
getseqnumsviafilenames <- function(folder = getwd()) {

  # infer nums based on what filenames are found in folder

  is.datafilename <-
    function(x) {
      grepl(pattern = '[em]20[0-9][0-9]5[a-z][a-z][0-9]*\\.txt', x)
    }
  found.efiles.not.us <- list.files(path = folder)
  found.efiles.not.us <-
    found.efiles.not.us[is.datafilename(found.efiles.not.us)]
  mynums <-  unique(substr(found.efiles.not.us, 9, 12))
  #allnums <- ***
  #mynums <- mynums[mynums %in% allnums]
  return(mynums)
}
