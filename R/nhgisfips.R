nhgisfips <- function(x,
                      validfields=c('STATEA', 'COUNTYA', 'TRACTA', 'BLKGRPA'),
                      fullname = c('FIPS.ST', 'FIPS.COUNTY', 'FIPS.TRACT', 'FIPS.BG'),
                      leadz = c(2, 3, 6, 1) ) {

  # leadz is correct total nchar() for this portion of fips, including leading zeroes

  ishere <- validfields %in% colnames(x)
  fieldnamesok <- paste(as.numeric(ishere), collapse='') %in% c('1000', '1100', '1110', '1111')
  if (!fieldnamesok) {stop('failed to find appropriate fieldnames in x, such as ', paste(validfields, collapse=' '))}

  FIPS <- mapply(FUN=lead.zeroes, x[ , validfields[ishere], drop=FALSE], leadz[ishere])
  FIPS <- apply(FIPS, 1, FUN = function(z) paste(z, collapse=''))
  # return as a 1-column data.frame
  FIPS <- data.frame(FIPS, stringsAsFactors = FALSE)
  colnames(FIPS) <- fullname[sum(ishere)]
  return(FIPS)
}

