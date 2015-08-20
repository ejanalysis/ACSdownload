#' @title Find NHGIS ACS Files on Disk
#' @description Look in specified path to find any
#'   downloaded and unzipped csv and txt files from NHGIS.ORG,
#'   with American Community Survey (ACS) data from the US Census Bureau.
#' @details This is designed to get a list of filenames that match the format of csv and txt files
#'   obtained from NHGIS.org and already unzipped in a local folder.
#'   Obtaining NHGIS.org data requires an account at
#'   \url{https://data2.nhgis.org/main}, \url{https://www.nhgis.org}
#'   Data can be downloaded by selecting, for example, \cr
#'   block groups, all in US, acs2007-2011, and specifying the desired ACS Table(s).
#'   Research using NHGIS data should cite it as: \cr
#'   Minnesota Population Center. National Historical Geographic Information System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
#' @param folder Optional path to look in. Default is getwd().
#' @param silent Optional, default is FALSE. Prints filenames if TRUE.
#' @return A named list with datafiles= a vector of one or more filenames (estimates and also MOE files) and
#'   codebooks= a vector of one or more filenames. The function also prints the information unless silent=TRUE.
#' @seealso \code{\link{nhgis}}, \code{\link{nhgisread}}
#' @export
nhgisfind <- function(folder=getwd(), silent=FALSE) {

  datafiles 		<- list.files(path=folder, pattern="^nhgis.*csv$")
  codebookfiles <- list.files(path=folder, pattern="^nhgis.*codebook\\.txt$")

  if (!silent) {
    cat("-----------------------\n")
    cat("Looking for NHGIS files in \n")
    cat(folder); cat("\n")
    cat("-----------------------\n")
  }
  if (length(datafiles)==length(codebookfiles)) {
    if (!silent) {
      cat("Folder contains these data and codebook files:\n")
      cat("  \n")
      print(cbind(DATA=sort(datafiles), CODEBOOKS=sort(codebookfiles))); cat("\n")
      cat("-----------------------\n")
    }
  } else {
    warning("# of data and codebook files don't match!\n")
    if (!silent) {
      cat("Folder contains these codebook files:\n")
      print(datafiles)
      cat("-----------------------\n")
      cat("Folder contains these codebook files:\n")
      print(codebookfiles)
      cat("-----------------------\n")
    }
  }

  return(list(datafiles=datafiles, codebooks=codebookfiles))
}

