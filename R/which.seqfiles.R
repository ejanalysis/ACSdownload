#' @title Find Which Sequence Files Contain Given ACS Table(s)
#' @description
#'   The US Census Bureau provides 5-year summary file data from the American Community Survey in sequence files on their FTP site.
#'   This function reports which sequence files contain the specified tables. Used by \code{\link{get.acs}}
#' @param tables character vector, required. Defines which ACS table(s) to check, such as 'B01001'
#' @param lookup.acs data.frame, optional (if not provided then it is downloaded from Census).
#'   Specifies what variables are in which tables and which tables are in which sequence files on the FTP site.
#' @param end.year Character element, optional. Defines end year for 5-year dataset.
#'   Valid years are limited.
#'   Ignored if lookup.acs is specified, however. If they imply different years, the function stops with an error message.
#' @return Returns a vector of one or more numbers stored as characters, each defining one sequence file, such as "0001".
#' @seealso \code{\link{get.acs}} and \code{\link[acs]{acs.lookup}} from the \pkg{acs} package, which does something related but is more flexible & robust. Also see \code{\link{get.acs}} which uses this.
#' @export
which.seqfiles <- function(tables, lookup.acs, end.year = acsdefaultendyearhere_func()) {

  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a recent year')}
  # validyears <- 2009:2022
  # if (!(end.year %in% validyears)) {
  #   stop('invalid end.year')
  # }
  
  if (missing(lookup.acs)) {
    lookup.acs <- get.lookup.acs(end.year = end.year)
  } else {
    if (!missing(end.year)) {
      # warning('both lookup.acs and end.year were specified, so ignoring end.year and using lookup.acs')
      #  warn here if lookup.acs is for different year than end.year
      #       > sum(is.na(lookup.acs$Line.Number))
      # 	    [1] 2080
      #
      # 	    > sum(is.na(lookup.acs2009$Line.Number))
      # 	    [1] 2018
      # 	    > sum(is.na(lookup.acs2010$Line.Number))
      # 	    [1] 2036
      # 	    > sum(is.na(lookup.acs2011$Line.Number))
      # 	    [1] 1908
      # 	    > sum(is.na(lookup.acs2012$Line.Number))
      # 	    [1] 2080
      # 	    > sum(is.na(lookup.acs2013$Line.Number))
      # 	    [1] 2110
      # > sum(is.na(lookup.acs2014$Line.Number))
      # [1] 2114
      # > sum(is.na(lookup.acs2015$Line.Number))
      # [1] 2114
      # > sum(is.na(lookup.acs2016$Line.Number))
      # [1] 2116
      # > sum(is.na(lookup.acs2017$Line.Number))
      # [1] 2280
      # > sum(is.na(lookup.acs2018$Line.Number))
      # [1] 2308
      # > sum(is.na(lookup.acs2019$Line.Number))
      # [1] 2310
      # > 
      uniquetoyearlist <-
        list(
          # '2009' = 2018,
          # '2010' = 2036,
          # '2011' = 1908,
          # '2012' = 2080,
          # '2013' = 2110,
          # '2014' = 2114,
          # '2015' = 2114, 
          # '2016' = 2116, 
          # '2017' = 2280, 
          '2018' = 2308, 
          '2019' = 2310, 
          '2020' = 2324  #,  
          # '2021' = sum(is.na(lookup.acs2021$Line.Number)),  # to add
          # '2022' = sum(is.na(lookup.acs2022$Line.Number))  # to add
        )
      if (uniquetoyearlist[end.year] == 0) stop('code not yet updated in which.seqfiles.R')
      uniquetoyear <- sum(is.na(lookup.acs$Line.Number))
      if (uniquetoyearlist[end.year] != uniquetoyear) {
        warning(
          'both lookup.acs and end.year were specified, but imply different years -- ignoring end.year and using lookup.acs provided'
        )
      }
    }
  }
  these.seqfilelistnums <-
    unique(lookup.acs[lookup.acs$Table.ID %in% tables, "Sequence.Number"])
  return(these.seqfilelistnums)
}
