#' @title Join US ACS data and US geo files on FIPS
#' @description Read the processed csv files of estimates and MOE (margin of error) for American Community Survey (ACS)
#'   5-year summary file data obtained from US Census FTP site, and join with geographic information from geo file.
#' @param mygeo Required geo file. See \code{\link{get.acs}} and \code{\link{get.read.geo}}
#' @param my.list.of.tables List of data tables resulting from prior steps in \code{\link{get.acs}}
#' @param folder Default is current working directory.
#' @param save.csv FALSE by default. Specifies whether to save each data table as csv format file.
#' @param testing Default is FALSE. If TRUE, prints more information.
#' @param sumlevel Default is "both", specifies if "tracts" or "blockgroups" or "both" should be used.
#' @param end.year Default is "" -- used in naming file if save.csv=TRUE
#' @return Returns a list of data.frames, where each element of the list is one ACS table, such as table B01001.
#' @seealso \code{\link{get.acs}} and \code{\link{get.read.geo}}
#' @export
join.geo.to.tablist <-
  function(mygeo,
           my.list.of.tables,
           save.csv = FALSE,
           sumlevel = 'both',
           folder = getwd(),
           testing = FALSE,
           end.year = acsdefaultendyearhere_func()) {
    #	FUNCTION TO join (merge) US data and US geo files on FIPS
    
    # Do geo join for one seqfile at a time, or actually one table at a time.
    # That is somewhat inefficient because geo merge has to be done repeatedly instead of once.
    # But it may be useful to have one file per table.
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    for (i in 1:length(my.list.of.tables)) {
      if (testing) {
        print('length of my.list.of.tables')
        print(length(my.list.of.tables))
        print('structure of it')
        print(str(my.list.of.tables))
        print('structure of mygeo')
        print(str(mygeo))
      }
      
      bigtable <- my.list.of.tables[[i]]
      
      # remove the redundant columns
      bigtable <-
        bigtable[, !(names(bigtable) %in% c("STUSAB", "SEQUENCE", "LOGRECNO"))]
      
      # NOTE - This is very slow as written, and takes too much RAM, so it can fail. Can take 5 minutes on a slow machine.
      # plyr::join is much faster than merge (& data.table merge is faster also) according to
      # http://stackoverflow.com/questions/1299871/how-to-join-data-frames-in-r-inner-outer-left-right/1300618#1300618
      
      my.list.of.tables[[i]] <-
        merge(mygeo, bigtable, by.x = "KEY", by.y = "KEY")
      
      # DROP ROWS WE DON'T NEED, IF ANY
      if (sumlevel == 'tracts') {
        my.list.of.tables[[i]] <-
          subset(my.list.of.tables[[i]],
                 my.list.of.tables[[i]]$SUMLEVEL == '140')
      }
      if (sumlevel == 'bg')     {
        my.list.of.tables[[i]] <-
          subset(my.list.of.tables[[i]],
                 my.list.of.tables[[i]]$SUMLEVEL == '150')
      }
      
      # MIGHT WANT TO DO ERROR CHECKING HERE FOR LENGTH & HOW MANY FAIL TO MATCH
      # print(overlaps(mygeo$KEY, bigtable$KEY))
      
      rm(bigtable)
      if (save.csv) {
        this.tab <- names(my.list.of.tables)[i]
        write.csv(my.list.of.tables[[i]],
                  file = file.path(
                    folder,
                    paste("ACS", end.year, "-", this.tab, ".csv", sep = "")
                  ),
                  row.names = FALSE)
        # save(bigtable, file=paste("ACS", end.year, "-", this.tab, ".RData", sep=""))
      }
    }
    return(my.list.of.tables)
  }
