#' @title Assemble FIPS Code from State, County, Tract, Blockgroup Portions
#' @description Helper function for reading demographic data files downloaded from NHGIS.org
#' @details This can also be used more generically in other contexts, by specifying appropriate parameters.
#' @param x Data.frame or matrix with appropriate colnames, containing portions of FIPS code in separate columns.
#' @param validfields Optional, default is colnames used in datasets downloaded from NHGIS.org as of 8/2015 for ACS data.
#'   Defaults: c("STATEA", "COUNTYA", "TRACTA", "BLKGRPA")
#' @param fullname  Optional, default is based on default for validfields parameter:
#'   c("FIPS.ST", "FIPS.COUNTY", "FIPS.TRACT", "FIPS.BG"). Specifies colname for the output,
#'   which depends on how many cols of fips portions are in x.
#' @param leadz Optional, default is based on default for validfields parameter: c(2, 3, 6, 1)
#'   Defines total number of characters in correctly formatted portions of FIPS, such as 2 for State FIPS (e.g., "01").
#' @return A 1-column data.frame with same number of rows as x. Provides assembled FIPS for each row.
#' @seealso \code{\link{nhgis}}, \code{\link{nhgisread}}, \code{\link[ejanalysis]{clean.fips}}
#' @examples
#' x <- structure(list(STATEA = structure(c(2L, 3L, 1L),
#' .Label = c("10", "8", "9"), class = "factor"),
#' COUNTYA = structure(1:3, .Label = c("1", "10", "100"), class = "factor"),
#' TRACTA = structure(c(2L, 1L, 2L), .Label = c("000006", "123456"), class = "factor"),
#' BLKGRPA = c("1", "2", "3"), data = c(0, 0, 0)),
#' .Names = c("STATEA", "COUNTYA", "TRACTA", "BLKGRPA", "data"),
#' row.names = c(NA, -3L), class = "data.frame")
#' x
#' nhgisfips(x[ , 1, drop=FALSE])
#' nhgisfips(x[ , 1:2], fullname=c('stfips', 'countyfips', 'tractfips', 'bgfips'))
#' nhgisfips(x[ , 1:3])
#' nhgisfips(x[ , 1:4])
#' nhgisfips(x)
#' @export
nhgisfips <- function(x,
                      validfields=c('STATEA', 'COUNTYA', 'TRACTA', 'BLKGRPA'),
                      fullname = c('FIPS.ST', 'FIPS.COUNTY', 'FIPS.TRACT', 'FIPS.BG'),
                      leadz = c(2, 3, 6, 1) ) {

  # leadz is correct total nchar() for this portion of fips, including leading zeroes

  ishere <- validfields %in% colnames(x)
  xfipscols <- x[ , validfields[ishere], drop=FALSE]
  ishere <- !(colSums(is.na(xfipscols))==NROW(xfipscols))
  xfipscols <- x[ , validfields[ishere], drop=FALSE]
  fieldnamesok <- paste(as.numeric(ishere), collapse='') %in% c('1000', '1100', '1110', '1111')
  if (!fieldnamesok) {stop('failed to find appropriate fieldnames in x, such as ', paste(validfields, collapse=' '))}

  FIPS <- mapply(FUN=analyze.stuff::lead.zeroes, xfipscols, leadz[ishere])
  FIPS <- apply(FIPS, 1, FUN = function(z) paste(z, collapse=''))
  # return as a 1-column data.frame
  FIPS <- data.frame(FIPS, stringsAsFactors = FALSE)
  colnames(FIPS) <- fullname[sum(ishere)]
  return(FIPS)
}

