#' @title Read NHGIS.org ACS Data Files and Codebooks
#' @description Helper function used by \code{\link{nhgis}} to read downloaded and unzipped csv and txt files obtained from NHGIS.org,
#'   with US Census Bureau data from the American Community Survey (ACS).
#' @param datafile Names of files
#' @param codebookfile Optional name(s) of codebook files. Default is to infer from datafile
#' @param folder Optional path where files are found. Default is getwd()
#' @return Returns a named list: data, contextfields, fields, tables, geolevel, years, dataset
#' @seealso  \code{\link{nhgis}} which uses this, \code{\link{nhgisreadcodebook}} for reading codebook files,
#'   \code{\link{get.acs}}, \code{\link{get.datafile.prefix}}, \code{\link{datafile}}, \code{\link{geofile}}, \code{\link{get.zipfile.prefix}}
#' @export
nhgisread <-
  function(datafile,
           codebookfile = gsub("\\.csv", "_codebook.txt", datafile),
           folder = getwd()) {
    ################################### #
    #	FUNCTION TO READ NHGIS ACS FILE
    ################################### #
    
    ############### #
    #	R CODE TO PARSE ACS BLOCKGROUP DATA FILES DOWNLOADED FROM NHGIS.ORG
    #	Log in with an account at
    #	https://data2.nhgis.org/main
    #	https://www.nhgis.org
    #	and select, e.g., block groups, all in US, acs2007-2011, and specify all needed ACS Tables.
    #
    # Research using NHGIS data should cite it as:
    # Minnesota Population Center. National Historical Geographic Information System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
    ############### #
    
    # NOTE THAT A BLANK ENTRY IS A JAM VALUE, and that will be read here as NA.
    #Users should be aware that NHGIS has modfied the original format of the ACS data
    #to replace "." jam values with blanks for files in the comma delimited (.csv)
    #output format. This was done to facilitate GIS processing.
    #These jam values appear within certain tables for records with too few observations to tabulate.
    #Users interested in obtaining the original "." values should request data in
    #the fixed width format when finalizing their data extracts.
    #Additional information on jam values can be found within the 2012 ACS technical documentation.
    
    ################################### #
    #	NOT IMPLEMENTED:
    #	Interactive selection of directory only works on windows, (or need x11 for mac to do this)
    #if (os=="win") {
    # let user specify directory with data and codebook files
    #	require(tcltk)
    #	datadir <- tk_choose.dir(caption="Select folder containing NHGIS csv format data files and txt format codebook files")
    #	setwd(datadir)
    #}
    ################################### #
    
    #This function is not vectorized -- could later recode to handle multiple estimates files in one function call.
    #for (datafile in datafiles) {
    # but it can handle datafile that is vector of 2 matching files, estimates and MOE
    
    
    # The 20105 ACS summary file data provided by NHGIS had estimates and MOEs combined into a single file
    #	(per selected resolution like tract, or block group).
    # The 20115 or 20135 ACS summary file data provided by NHGIS has estimates and MOEs in 2 separate files
    #  (per selected resolution like tract, or block group)
    # If E and M files are separate they must be read and combined.
    # nhgis function passes what nhgisfind found, one summarylevel at a time (e.g. county), so
    # nhgisread has been passed a datafile name that might be one file (combined E and M in 1 file, or just one of those if other is missing)
    # or might be two files, the E file and the M file.
    
    
    datafile.E <- grep("E\\.csv", datafile, value = TRUE)
    datafile.M <- grep("M\\.csv", datafile, value = TRUE)
    # presume any other filename passed here is a combination file with E and M in one file
    datafile.combo <-
      datafile[!(datafile %in% c(datafile.E, datafile.M))]
    codebookfile.E <-  grep('E_codebook', codebookfile, value = TRUE)
    codebookfile.M <-  grep('M_codebook', codebookfile, value = TRUE)
    codebookfile.combo <-
      codebookfile[!(codebookfile %in% c(codebookfile.E, codebookfile.M))]
    
    ################################### #
    #	CHECK FOR MISSING/BAD FOLDER OR FILENAMES, etc.
    ################################### #
    
    if (!file.exists(folder)) {
      stop("Folder ", folder, " not found")
    }
    if (any(!file.exists(file.path(folder, datafile)))) {
      stop(paste("File(s) ", datafile, " not found in ", folder))
    }
    if (any(!file.exists(file.path(folder, codebookfile)))) {
      stop(paste("Codebook file(s) ", codebookfile, " not found in ", folder))
    }
    
    if (length(datafile.E) > 1) {
      stop('Cannot read more than one estimates file at a time - nhgisread is not vectorized')
    }
    if (length(datafile.M) > 1) {
      stop('Cannot read more than one MOE file at a time - nhgisread is not vectorized')
    }
    if (length(datafile.combo) > 1) {
      stop(
        'Cannot read more than one combined Est/MOE data file at a time - nhgisread is not vectorized'
      )
    }
    if (length(codebookfile.E) > 1) {
      stop(
        'Cannot read more than one estimates codebook file at a time - nhgisread is not vectorized'
      )
    }
    if (length(codebookfile.M) > 1) {
      stop('Cannot read more than one MOE codebook file at a time - nhgisread is not vectorized')
    }
    if (length(codebookfile.combo) > 1) {
      stop(
        'Cannot read more than one combined Est/MOE codebook file at a time - nhgisread is not vectorized'
      )
    }
    
    if (length(datafile.E) > 0) {
      Efile <-
        TRUE # an Estimates-only file exists and name was passed here (was passed here with or without MOE filename also)
      if (length(datafile.combo) > 0) {
        stop('cannot read estimates file and non-MOE file like combined E/MOE file at same time')
      }
      if (!file.exists(file.path(folder, codebookfile.E))) {
        stop("Codebook file ", codebookfile.E, " not found in ", folder)
      }
    } else {
      Efile <- FALSE
    }
    
    if (length(datafile.M) > 0) {
      Mfile <-
        TRUE # an MOE-only file exists and name was passed here (with or without its Estimates filename as well)
      if (length(datafile.combo) > 0) {
        stop('cannot read MOE file and non-estimates file like combined E/MOE file at same time')
      }
      if (!file.exists(file.path(folder, codebookfile.E))) {
        stop("Codebook file ", codebookfile.E, " not found in ", folder)
      }
    } else {
      Mfile <- FALSE
    }
    
    if (Efile & Mfile) {
      # ensure the two filenames are for the same dataset
      if (!(datafile.E == gsub("M\\.csv", "E\\.csv", datafile.E))) {
        stop('if E and MOE filenames specified they must match except for E or M letter')
      }
      getting.EM <- TRUE
      # Will read this datafile's Estimates file  & also read matching M datafile, remove duplicated cols except GISJOIN, & merge on that. Resort as orig?
      # Will also read this codebook & also read matching M codebookfile & c() them before parsing.
    } else {
      getting.EM <- FALSE
    }
    
    if (length(datafile.combo) > 0) {
      # there seems to be a combined Estimates/MOE file here
      getting.combo <- TRUE
    } else {
      getting.combo <- FALSE
    }
    
    # Warnings about other combinations are at end of function.
    
    ############## #
    #	START READING FILES
    ############## #
    
    cat("Trying to read these specified files:")
    cat("\n")
    cat(paste("Datafile: ", datafile.E, datafile.M, datafile.combo, sep =
                ' '))
    cat("\n")
    cat(paste(
      "Codebook: ",
      codebookfile.E,
      codebookfile.M,
      codebookfile.combo,
      sep = ' '
    ))
    cat("\n")
    cat("----------------------")
    cat("\n")
    #print(Sys.time())
    cat("Reading datafile...\n")
    
    ############### #
    #	IMPORT ACS DATA FROM DOWNLOADED CSV FILE(S)
    ############### #
    
    # Load R package Hmisc if using csv.get() to retain labels on fields
    # require(Hmisc)
    # acs <- csv.get(datafile, as.is=TRUE)
    # or just use read.csv()
    
    if (Efile) {
      acs <- read.csv(file.path(folder, datafile.E), as.is = TRUE)
    }
    
    if (Mfile & !getting.EM) {
      # may not ever hit this case - MOE but not estimates
      acs <- read.csv(file.path(folder, datafile.M), as.is = TRUE)
    }
    
    if (getting.EM)  {
      # Read the corresponding Margin of Error file and add its unique columns to the Estimates file.
      cat("and also reading the matching MOE file\n")
      # to have labelled columns, could use csv.get from Hmisc
      # acs.moe <- csv.get(file.path(folder, datafile.M), as.is=TRUE)
      acs.moe <- read.csv(file.path(folder, datafile.M), as.is = TRUE)
      uniquecols <- names(acs.moe)[!(names(acs.moe) %in% names(acs))]
      orig.order <- acs$GISJOIN
      acs <-
        merge(acs, acs.moe[, c("GISJOIN", uniquecols)], by = "GISJOIN")
      acs <-
        acs[match(acs$GISJOIN, orig.order),] # put back in original order just in case merge caused problems
    }
    
    #print(Sys.time())
    cat("Done reading datafile(s)")
    cat("\n")
    cat("----------------------")
    cat("\n")
    
    ############################################################################################### #
    
    ############### #
    #	READ CODEBOOK -- Don't care which codebook file is used?
    cat('filename of codebook to read now: ', codebookfile[1])
    x <- nhgisreadcodebook(codebookfile[1], folder)
    if (is.null(x)) {
      stop("Codebook or folder missing or not valid")
    }
    # will return table called varnames that has old, new, and long versions of estimate and MOE fields
    varnames <- x$fields
    
    # **** assumes they are in the correct sequence & uses new names (e.g., C01001.001) *****
    names(acs)[names(acs) %in% varnames$old] <- varnames$new
    
    #  also return  the geo/other columns not just estimates and MOE fields, and other info from nhgisreadcodebook
    tables <- x$tables
    contextfields <- x$contextfields
    geolevel	<-
      x$geolevel  # this assumes a file has only one geolevel in it ******
    years		<- x$years
    dataset		<- x$dataset
    
    ############################################################################################### #
    
    ########### #
    #	PRINT SUMMARY RESULTS
    ########### #
    
    cat("----------------------")
    cat("\n")
    #cat("Variables found in codebook:\n")
    #print(varnames)
    #cat("----------------------"); cat("\n")
    cat("Tables found according to codebook:\n")
    cat("\n")
    print(tables)
    cat("\n")
    cat("----------------------")
    cat("\n")
    cat("Number of rows (locations): ")
    cat(length(acs[, 1]))
    cat("\n")
    cat("----------------------")
    cat("\n")
    # total (e.g. for 2007-2011) is 220334 bg which matches census website tally for US plus PR but without island areas.
    cat("States/etc. covered:")
    cat("\n")
    print(unique(acs$STATE))
    cat("\n")
    #cbind(table(acs$STATE))
    cat("----------------------")
    cat("\n")
    
    #	Note one datafile and one codebook may contain >1 Census table.
    
    #could later recode to handle multiple estimates files in one function call, etc.
    #} # end loop over multiple datafiles (if >1)
    
    #	CORRESPONDS TO WHAT nhgisreadcodebook() RETURNS
    return(
      list(
        data = acs,
        contextfields = contextfields,
        fields = varnames,
        tables = tables,
        geolevel = geolevel,
        years = years,
        dataset = dataset
      )
    )
    
    #unique(gsub(".[[:digit:]]+$", "", varnames$new))
  }
