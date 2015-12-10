#' @title Read and Parse NHGIS.org ACS Data Files and Codebooks
#' @description Read downloaded and unzipped csv and txt files obtained from NHGIS.org,
#'   with US Census Bureau data from the American Community Survey (ACS).
#' @details This is designed to read and parse csv and txt files
#'   obtained from NHGIS.org and already unzipped in a local folder.
#'   It only reads one set of files at a time, meaning the data and codebook files all have to be for the same set of ACS tables (a single NHGIS query)
#'   (but can be a separate data & codebook file pair for each spatial resolution like county, state, etc.)
#'   Obtaining NHGIS.org data requires an account at
#'   \url{https://data2.nhgis.org/main}, \url{https://www.nhgis.org}
#'   Data can be downloaded by selecting, for example, \cr
#'   tracts and block groups, all in US, acs2007-2011, and specifying the desired ACS Table(s). \cr
#'   Research using NHGIS data should cite it as: \cr
#'   Minnesota Population Center. National Historical Geographic Information System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
#' @param base.path Optional base path, default is getwd()
#' @param data.dir Optional path where data files are stored and output could be saved. Default is nhgiscode folder under base.path
#' @param code.dir Optional path where extra code is. Not used.
#' @param silent Optional, FALSE by default, whether to print info about progress, filenames found, etc.
#' @param savefiles Optional, FALSE by default, whether to save .RData and maybe csv files of output returned.
#' @return Returns a named list, one element per summary level found (names are, e.g., 'us', 'states', etc.).
#'   Each summary level has a list of the following: data, contextfields, fields, tables, geolevel, years, dataset \cr
#'   For example: \cr
#'   \code{
#'   summary(x[['us']])
#'                 Length Class      Mode
#'   data          279    data.frame list
#'   contextfields   3    data.frame list
#'   fields          4    data.frame list
#'   tables          4    data.frame list
#'   geolevel        1    -none-     character
#'   years           1    -none-     character
#'   dataset         1    -none-     character
#'   }
#' @seealso \code{\link{nhgisread}} used by this function. Also, for other ways to obtain ACS data see \code{\link{get.acs}}
#' @examples
#' \donotrun{
#' x <- nhgis(data.dir = '~/Desktop/nhgis0009_csv')
#' # save state data as csv
#' write.csv(x$states$data, file='statedata.csv', row.names = FALSE)
#' # Which geolevels were found (and what years)?
#' summary(x)
#' t(cbind(sapply(x, function(y) y[c('geolevel', 'years')])))
#' summary(x[['counties']])
#' # Which Census Bureau tables were found?
#' x[['states']]$tables
#' # See the data for one State
#' t(x[['states']]$data[1, ])
#' # How many counties are in each State?
#' dat <- x[['counties']]$data
#' cbind(sort(table(dat$STATE)))
#' # How many counties have population > 1 million, for each State?
#' cbind(sort(table(dat$STATE[dat$B01001.001 > 1E6])))
#' }
#' @export
nhgis <- function(base.path=getwd(), code.dir=file.path(base.path, 'nhgiscode'), data.dir=file.path(base.path, 'nhgisdata'), silent=FALSE, savefiles=FALSE) {

  warning('work in progress - not fully tested')

  # to do:
  # I don't think this works for more than one table at a time (it can read all resolutions like state, county, etc files for one table, but not 2+ tables at once)
  # could fix 2 cases below that crash.
  # could add allfields df as an output of nhgisread()

  filename.for.save <- 'nhgisout'  # "20125 ACS EJSCREEN all scales 6 tables nhgis"

  # specify my short name and the text that NHGIS uses in their filenames, for each spatial resolution
  validresolutions.filename <- c('nation', 'state', 'county', 'tract', 'blck_grp')
  validresolutions <- c('us', 'states', 'counties', 'tracts', 'bg')
  fipsvar <- c('FIPS', 'FIPS.ST', 'FIPS.COUNTY', 'FIPS.TRACT', 'FIPS.BG')

  #data.path <- data.dir
  #code.path <- code.dir
  # ********************  avoid setwd()
  #setwd(base.path)

  #	GET FILES I WANT AND PARSE & SAVE THEM IN MY FORMAT:
  filesfound <- nhgisfind( folder=data.dir, silent=silent)  # or specified folder
  # filesfound$datafiles has estimate and also MOE files right now,
  # or can be combo E/MOE files,
  # filesfound$codebooks are in separate files.

  resfound <- vector(length=length(validresolutions.filename))
  for (i in 1:length(validresolutions.filename)) {
    resfound[i] <- any(grepl(validresolutions.filename[i], filesfound$datafiles))
  }
  res  <- validresolutions[resfound]
  resf <- validresolutions.filename[resfound]
  fipsvar <- fipsvar[resfound]
  #cat("res: ", res, ' /  resf: ', resf, '\n')

  ####################################################
  # To see list of field names where every entry is NA:   names(bg$data)[analyze.stuff::na.check2(bg$data)$na.count==length(bg$data[,1])]
  # Define a function that finds which columns have only NA values for every row
  na.cols.y <- function(df) { colSums(is.na(as.data.frame(df))) == length(NROW(as.data.frame(df))) }
  #na.cols   <- function(df) { colnames(df)[na.cols.y(df)] }

  out <- list()
  # out will be a list of tables, one per resolution like state or county

  for (i in 1:length(res)) {

    # read Estimate and MOE data files (and it finds the codebooks too) for this resolution (e.g., county resolution)
    out[[i]] <- nhgisread( grep(resf[i], filesfound$datafiles, value=TRUE ),	folder=data.dir)

    # Drop the useless fields (i.e., where every entry is NA)
    # Filter field names to keep only the ones for fields we kept
    out[[i]]$data <- out[[i]]$data[ , my.cols <- !na.cols.y(out[[i]]$data) , drop=FALSE]
    my.cols <- names(out[[i]]$data)

    # THIS WAS ORIG DIFFERENT FOR US VS OTHER RES? or was that an error?:
    #if (NROW(out[[i]]$contextfields)==1) {
    #  out[[i]]$contextfields <- out[[i]]$contextfields[out[[i]]$contextfields$new %in% my.cols, drop=FALSE]
    #} else {
      out[[i]]$contextfields <- out[[i]]$contextfields[out[[i]]$contextfields$new %in% my.cols, , drop=FALSE]
    #}

    # reorder the columns in data.frame called data
    out[[i]]$data <- out[[i]]$data[ , c(
      out[[i]]$contextfields$new,
      analyze.stuff::intersperse(names(out[[i]]$data[ , out[[i]]$fields$new, drop=FALSE]))
      ), drop=FALSE]
    out[[i]]$fields <- out[[i]]$fields[ analyze.stuff::intersperse(rownames(out[[i]]$fields)), ]

    # ADD FIPS CODES TO AT LEAST bg IF NOT tracts, counties, states
    #bg$data$FIPS <-              with(bg$data,      paste(lead.zeroes(STATEA,2), lead.zeroes(COUNTYA,3), lead.zeroes(TRACTA,6), BLKGRPA, sep=""))

    if (res[i]!='us') {
      # create FIPS column
      out[[i]]$data <- data.frame(out[[i]]$data, nhgisfips(out[[i]]$data), stringsAsFactors = FALSE)
      out[[i]]$fields <- rbind(out[[i]]$fields, rep(fipsvar[i], 4))
      # should be same as names(nhgisfips(out[[i]]$data))
    } else {
      out[[i]]$data$FIPS <- NA
    }

    # put MOE on every fieldname that needs it
    is.moe <- grepl('\\.m$', out[[i]]$fields$new)
    out[[i]]$fields$long[is.moe] <- paste(out[[i]]$fields$long[is.moe], '_MOE', sep='')
  }

  # named list where names are e.g., 'us', 'states', etc.
  names(out) <- res

  if (savefiles) {
    save.image(file.path(data.dir, paste(filename.for.save, ".RData", sep="")))
    # add code to save more outputs here
  }

  return(out)

  # OLD/ OBSOLETE NONGENERIC CODE:

  #   us 		  <- nhgisread( grep("nation", filesfound$datafiles, value=TRUE ),	folder=data.dir)
  #   states	<- nhgisread( grep("state", filesfound$datafiles, value=TRUE ), 	folder=data.dir)
  #   counties<- nhgisread( grep("county", filesfound$datafiles, value=TRUE ), 	folder=data.dir)
  #   tracts 	<- nhgisread( grep("tract", filesfound$datafiles, value=TRUE ), 	folder=data.dir)  # took <15 seconds
  #   bg 		  <- nhgisread( grep("blck_grp", filesfound$datafiles, value=TRUE ), folder=data.dir) # took maybe 2 minutes?

  # Drop the useless fields (i.e., where every entry is NA)
  # Filter field names to keep only the ones for fields we kept

  #   us$data <-              us$data[ , us.cols       <- !na.cols.y(us$data) ]    # we will actually keep all of these
  #   states$data <-      states$data[ , states.cols   <- !na.cols.y(states$data) ]
  #   counties$data <-  counties$data[ , counties.cols <- !na.cols.y(counties$data) ]
  #   tracts$data <-      tracts$data[ , tracts.cols   <- !na.cols.y(tracts$data) ]
  #   bg$data <-              bg$data[ , bg.cols       <- !na.cols.y(bg$data) ]

  #   us.cols <-        names(us$data)
  # #********is there an error in this line that was introduced when commenting it:??
  #   us$contextfields <-              us$contextfields$new[us$contextfields$new %in% us.cols]
  # #***** us code here differs from...
  #   states.cols <-    names(states$data)
  #   states$contextfields <-          states$contextfields[states$contextfields$new %in% states.cols, ]
  #   counties.cols <-  names(counties$data)
  #   counties$contextfields <-      counties$contextfields[counties$contextfields$new %in% counties.cols, ]
  #   tracts.cols <-    names(tracts$data)
  #   tracts$contextfields <-          tracts$contextfields[tracts$contextfields$new %in% tracts.cols, ]
  #   bg.cols <-        names(bg$data)
  #   bg$contextfields <- bg$contextfields[bg$contextfields$new %in% bg.cols, ]

  #NOTES:
  # SETTINGS
  # e.g., "nhgis0006_ds191_20125_2012_blck_grp_codebook.txt"
  # old dir: code.dir <- "ACS - download and parse/CODE FOR ACS VIA NHGIS"
  # old data.dir	<- "ACS - download and parse/ACS DATA/NHGIS ORG as source/20125 ACS USA EJSCREEN all scales- nhgis0006_csv"
  # or data.dir <- "ACS - download and parse/ACS DOWNLOADED/NHGIS ORG as source/20115 ACS USA EJSCREEN all scales- nhgis0003_csv"
  # source(file.path(code.path, "nhgisfind.R"))
  # source(file.path(code.path, "nhgisreadcodebook.R"))
  # source(file.path(code.path, "nhgisread.R"))

  # reformat so that estimate and MOE are next to each other
  # but want to keep the context fields together:

  #   us$data     <-        us$data[ , c(us$contextfields$new,      intersperse(names(us$data[ , us$fields$new])))]
  #   states$data <-    states$data[ , c(states$contextfields$new,  intersperse(names(states$data[ , states$fields$new])))]
  #   counties$data <-counties$data[ , c(counties$contextfields$new,intersperse(names(counties$data[ , counties$fields$new])))]
  #   tracts$data <-    tracts$data[ , c(tracts$contextfields$new,  intersperse(names(tracts$data[ , tracts$fields$new])))]
  #   bg$data     <-        bg$data[ , c(bg$contextfields$new,      intersperse(names(bg$data[ , bg$fields$new])))]

  #   us$fields     <-         us$fields[ intersperse(rownames(us$fields)), ]
  #   states$fields <-     states$fields[ intersperse(rownames(states$fields)), ]
  #   counties$fields <- counties$fields[ intersperse(rownames(counties$fields)), ]
  #   tracts$fields <-     tracts$fields[ intersperse(rownames(tracts$fields)), ]
  #   bg$fields     <-         bg$fields[ intersperse(rownames(bg$fields)), ]

  #   # ADD FIPS CODES TO AT LEAST bg IF NOT tracts, counties, states
  #
  #   bg$data$FIPS <-              with(bg$data,      paste(lead.zeroes(STATEA,2), lead.zeroes(COUNTYA,3), lead.zeroes(TRACTA,6), BLKGRPA, sep=""))
  #   tracts$data$FIPS.TRACT <-    with(tracts$data,  paste(lead.zeroes(STATEA,2), lead.zeroes(COUNTYA,3), lead.zeroes(TRACTA,6), sep=""))
  #   counties$data$FIPS.COUNTY <- with(counties$data,paste(lead.zeroes(STATEA,2), lead.zeroes(COUNTYA,3), sep=""))
  #   states$data$FIPS.ST <-       with(states$data,        lead.zeroes(STATEA,2))
  #
  #   bg$fields <-      rbind(bg$fields,      rep('FIPS',       4))
  #   tracts$fields <-  rbind(tracts$fields,  rep('FIPS.TRACT', 4))
  #   counties$fields <-rbind(counties$fields,rep('FIPS.COUNTY',4))
  #   states$fields <-  rbind(states$fields,  rep('FIPS.ST',    4))

  # Could drop this field:
  # bg$data$GISJOIN <- NULL


  #   # put MOE on every fieldname that needs it
  #
  #   is.moe <- grepl('\\.m$', bg$fields$new)
  #   bg$fields$long[is.moe] <- paste(bg$fields$long[is.moe], '_MOE', sep='')
  #
  #   is.moe <- grepl('\\.m$', tracts$fields$new)
  #   tracts$fields$long[is.moe] <- paste(tracts$fields$long[is.moe], '_MOE', sep='')
  #
  #   is.moe <- grepl('\\.m$', counties$fields$new)
  #   counties$fields$long[is.moe] <- paste(counties$fields$long[is.moe], '_MOE', sep='')
  #
  #   is.moe <- grepl('\\.m$', states$fields$new)
  #   states$fields$long[is.moe] <- paste(states$fields$long[is.moe], '_MOE', sep='')
  #
  #   is.moe <- grepl('\\.m$', us$fields$new)
  #   us$fields$long[is.moe] <- paste(us$fields$long[is.moe], '_MOE', sep='')


  ################################################
  # COULD RENAME TO FRIENDLY FIELD NAMES
  ################################################

  # bg$data <- change.fieldnames(bg$data, bg$fields$new, bg$fields$long)
  # or something like this:
  # friendlynames <- c(..........)
  # bg$data <- change.fieldnames(bg$data, bg$fields$new, friendlynames)


  ########################
  # save each of these sets of tables:
  ########################
  # if (savefiles) {
  # save results:
  #setwd(data.dir)

  # first save workspace
  # save.image(file.path(data.dir, paste(filename.for.save, ".RData", sep="")))

  # make generic:
  #
  #     bg.all <- bg
  #     save(bg.all, file=paste(filename.for.save,'-bg.all.RData', sep=''))
  #     bg <- bg$data
  #     save(bg, file=paste(filename.for.save,'-bg.RData',sep=''))
  #     bg <- bg.all
  #     rm(bg.all)
  #
  # make generic
  #     write.csv( rbind(us$contextfields, us$fields[,2:4]), file=paste(filename.for.save, "-US-FIELDNAMES.csv", sep=""), row.names=FALSE)
  #     write.csv( rbind(counties$contextfields, counties$fields[,2:4]), file=paste(filename.for.save, "-counties-FIELDNAMES.csv", sep=""), row.names=FALSE)
  #     write.csv( rbind(states$contextfields, states$fields[,2:4]), file=paste(filename.for.save, "-states-FIELDNAMES.csv", sep=""), row.names=FALSE)
  #     write.csv( rbind(tracts$contextfields, tracts$fields[,2:4]), file=paste(filename.for.save, "-tracts-FIELDNAMES.csv", sep=""), row.names=FALSE)
  #     write.csv( rbind(bg$contextfields, bg$fields[,2:4]), file=paste(filename.for.save, "-bg-FIELDNAMES.csv", sep=""), row.names=FALSE)
  #
  #     # ALSO IF NEED CSV FORMAT OF EACH:
  #
  #     write.csv(us$data, file=paste(filename.for.save,"-US.csv",sep=""), row.names=FALSE)
  #     write.csv(counties$data, file=paste(filename.for.save,"-COUNTIES.csv",sep=""), row.names=FALSE)
  #     write.csv(states$data, file=paste(filename.for.save,"-STATES.csv",sep=""), row.names=FALSE)
  #     write.csv(tracts$data, file=paste(filename.for.save,"-TRACTS.csv",sep=""), row.names=FALSE)
  #     write.csv(bg$data, file=paste(filename.for.save,"-BG.csv",sep=""), row.names=FALSE)

  # could extract each table and save if need that (see examples)

}



############################################################################################################
# done getting data # STOP HERE #
############################################################################################################

if (1==0) {
  # i.e. don't execute the following if this file was source()-ed

  ############################################################################################################
  ############################################################################################################

  ################################
  #  old EXAMPLES OF USAGE OF nhgisreadcodebook and nhgisread and nhgisfind
  ################################

  # Get functions if not already in memory
  code.path <- getwd() # or specified folder
  source(file.path(code.path, "nhgisfind.R"))
  source(file.path(code.path, "nhgisreadcodebook.R"))
  source(file.path(code.path, "nhgisread.R"))

  # get vector of filenames for estimates, moe, and codebook files found in folder
  filesfound <- nhgisfind( folder=getwd() )  # or specified folder
  filesfound$datafiles
  filesfound$codebooks

  # get old, new/short, & long field names, and table names, from the first codebook found
  x <- nhgisreadcodebook( nhgisfind()$codebooks[1] )
  x$fields
  x$tables

  # to read 1 datafile from current working directory, guessing at codebook names & MOE file,
  datafile 		<- "nhgis0003_ds184_20115_2011_county_E.csv"
  acs <- nhgisread(datafile)

  # Save csv for Excel with 2 header rows -- short and long field names:
  datafile 		<- "nhgis0003_ds184_20115_2011_county_E.csv"
  acs <- nhgisread(datafile)
  allnames.long <- c(acs$contextfields$long, acs$fields$long)
  # row 1 has long names, then blank line so table below it has a single header row of short names.
  write.table( rbind( allnames.long, rep("", length(allnames.long)), names(acs$data), acs$data),
               col.names=FALSE, row.names=FALSE, sep=",",  qmethod = "double", dec=".",
               file=paste("for xls- ", datafile))
  cbind(names(acs$data), allnames.long)

  # View table names, field names, etc.:
  datafile 		<- "nhgis0003_ds184_20115_2011_county_E.csv"
  acs <- nhgisread(datafile)
  summary(acs)
  acs$dataset; acs$geolevel; acs$years
  acs$fields
  acs$tables
  str(acs)
  t(head(acs$data,2))
  t(rbind( head(acs$data,1), c(acs$contextfields$long, acs$fields$long)))
  # or equivalently,
  cbind(c(acs$contextfields$long, acs$fields$long), t(head(acs$data,1)))

  ##################################################################
  # Extract one Census table from results 	******************
  ##################################################################
  mytab <- "C17002"
  select.table <- function(tablename, dataset) {
    dataset$geolevel  <- dataset$geolevel
    dataset$years  <- dataset$years
    dataset$dataset  <- dataset$dataset
    dataset$data <- dataset$data[ , c(dataset$contextfields$new, dataset$fields$new[dataset$fields$table==mytab]) ]
    dataset$fields <- dataset$fields[dataset$fields$table==mytab, ]
    # dataset$contextfields <- dataset$contextfields
    # add new "allfields" for convenience
    dataset$allfields <- data.frame(
      new=c(dataset$contextfields$new, dataset$fields$new),
      long=c(dataset$contextfields$long, dataset$fields$long), stringsAsFactors=FALSE)
    return(dataset)
  }
  mydf <- select.table(mytab, acs)
  ##################################################################


  # Get just the estimate column names, not MOE or other columns:
  ecols <- grep(".[0-9]{3}$", names(acs$data), value=TRUE)
  # OR
  ecols <- grep(".[0-9]{3}$", acs$fields$new,  value=TRUE)
  ecols

  # View summary stats from just one of the Census tables in a datafile:
  # (1 NHGIS data file might have >1 Census tables, depending on what was requested/ downloaded from NHGIS)
  mytab <- acs$tables$names[1]   # mytab <- "C17002"
  # for estimates only, not MOE:
  ecols <- grep(".[0-9]{3}$", names(acs$data), value=TRUE)
  t( summary(acs$data[ , grep(mytab, ecols, value=TRUE)]) )
  # for estimates and MOE:
  t( summary(acs$data[ , acs$fields$new[acs$fields$table==mytab]]) )


  # Specify both datafile and codebook file names manually, in current working directory
  datafile 		<- "nhgis0003_ds184_20115_2011_nation_E.csv"
  codebookfile	<- "nhgis0003_ds184_20115_2011_nation_E_codebook.txt"
  acs <- nhgisread(datafile, codebookfile)
  t(acs$data)

  # To specify datafile and folder but not codebook file name, MUST say folder=
  datafile 		<- "nhgis0003_ds184_20115_2011_nation_E.csv"
  myfolder <- getwd()
  acs <- nhgisread(datafile, folder=myfolder)



  ############################################################################################################
  ############################################################################################################
  ############################################################################################################

  # MY ERROR TESTS

  test.folder	<- file.path(base.path, "ACS - download and parse/ACS DOWNLOADED/NHGIS ORG as source/test")
  test.file1 		<- "nhgis0002_ds176_20105_2010_blck_grp.csv"
  test.file 		<- "nhgis0003_ds184_20115_2011_state_E.csv"
  test.fileM		<- "nhgis0003_ds184_20115_2011_state_M.csv"
  test.codebook	<- "nhgis0003_ds184_20115_2011_state_E_codebook.txt"

  # all OK
  acs <- nhgisread(test.file, folder=file.path(test.folder, "nothing missing and EM in 2 files"))


  # NOTE: US totals are different since they exclude PR, but all others have PR and are consistent with each other:
  # Check if national totals are the same across all geographic resolutions (for each estimate field)
  us 		<- nhgisread("nhgis0003_ds184_20115_2011_nation_E.csv",	folder=data.dir)
  states	<- nhgisread("nhgis0003_ds184_20115_2011_state_E.csv", 	folder=data.dir)
  counties<- nhgisread("nhgis0003_ds184_20115_2011_county_E.csv", 	folder=data.dir)
  tracts 	<- nhgisread("nhgis0003_ds184_20115_2011_tract_E.csv", 	folder=data.dir)
  bg 		<- nhgisread("nhgis0003_ds184_20115_2011_blck_grp_E.csv", 	folder=data.dir)
  ecols <- names(us$data)[grepl("[[:alnum:]]{6}\\.[[:alnum:]]{3}$", names(us$data))]
  compare.sums <- cbind(
    us=colSums(us$data[ , ecols]),
    states=colSums(states$data[ , ecols]),
    counties=colSums(counties$data[ , ecols]),
    tracts=colSums(tracts$data[ , ecols]),
    bg=colSums(bg$data[ , ecols]))
  compare.sums
  colSums(compare.sums)
  table(apply(compare.sums, 1, function(x) length(unique(x))))
  # without PR:
  unique(states$data$STATE)
  compare.noPR <- cbind(
    us=colSums(us$data[ , ecols]),
    states=colSums(states$data[states$data$STATE!="Puerto Rico", ecols]),
    bg=colSums(bg$data[bg$data$STATE!="Puerto Rico", ecols]))
  colSums(compare.noPR)


  # bad names
  acs <- nhgisread(test.file, folder="bad folder name")
  acs <- nhgisread("bad file name")
  acs <- nhgisread("bad file name", folder="bad folder name")

  # missing file

  acs <- nhgisread(test.file, folder=file.path(test.folder, "no E codebook and EM in 2 files"))
  acs <- nhgisread(test.file, folder=file.path(test.folder, "no M codebook and EM in 2 files"))
  acs <- nhgisread(test.file, folder=file.path(test.folder, "no datafile"))

  #	****** THIS CASE IS NOT TREATED WELL: IT GETS CODEBOOK FOR MOE BUT SHOULDN'T SINCE DATA FOR MOE IS MISSING
  acs <- nhgisread(test.file, folder=file.path(test.folder, "no moe"))

  acs <- nhgisread(test.file1, folder=file.path(test.folder, "no codebook and EM in 1 file"))

  #	****** THIS CASE IS NOT TREATED WELL: IT GETS CODEBOOK FOR MOE BUT SHOULDN'T SINCE DATA FOR MOE IS MISSING
  acs <- nhgisread(test.file1, folder=file.path(test.folder, "nothing missing and EM in 1 file"))

  # if ask for MOE
  acs <- nhgisread(test.fileM, folder=file.path(test.folder, "nothing missing and EM in 2 files"))

  ############################################################################################################
}
# not run

