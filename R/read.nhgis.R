#' @title Read NHGIS.org ACS Data Files and Codebooks
#' @description Helper function used by nhgisimport to read downloaded and unzipped csv and txt files obtained from NHGIS.org,
#'   with US Census Bureau data from the American Community Survey (ACS).
#' @param datafile Names of files
#' @param codebookfile Optional name(s) of codebook files. Default is to infer from datafile
#' @param folder Optional path where files are found. Default is getwd()
#' @return Returns a named list: data, contextfields, fields, tables, geolevel, years, dataset
#' @seealso  \code{\link{nhgisimport}} which uses this, \code{\link{get.acs}}, \code{\link{get.datafile.prefix}}, \code{\link{datafile}}, \code{\link{geofile}}, \code{\link{get.zipfile.prefix}}
#' @export
read.nhgis <- function(datafile, codebookfile=gsub("\\.csv", "_codebook.txt", datafile), folder=getwd() ) {

	####################################
	#	FUNCTION TO READ NHGIS ACS FILE
	####################################

	################
	#	R CODE TO PARSE ACS BLOCKGROUP DATA FILES DOWNLOADED FROM NHGIS.ORG
	#	Log in with an account at
	#	https://data2.nhgis.org/main
	#	https://www.nhgis.org
	#	and select, e.g., block groups, all in US, acs2007-2011, and specify all needed ACS Tables.
	#
	# Research using NHGIS data should cite it as:
	# Minnesota Population Center. National Historical Geographic Information System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
	################

	# NOTE THAT A BLANK ENTRY IS A JAM VALUE, and that will be read here as NA.
	#Users should be aware that NHGIS has modfied the original format of the ACS data
	#to replace "." jam values with blanks for files in the comma delimited (.csv)
	#output format. This was done to facilitate GIS processing.
	#These jam values appear within certain tables for records with too few observations to tabulate.
	#Users interested in obtaining the original "." values should request data in
	#the fixed width format when finalizing their data extracts.
	#Additional information on jam values can be found within the 2012 ACS technical documentation.


	####################################
	#	NOT IMPLEMENTED:
	#	Interactive selection of directory only works on windows, (or need x11 for mac to do this)
	#if (os=="win") {
		# let user specify directory with data and codebook files
	#	require(tcltk)
	#	datadir <- tk_choose.dir(caption="Select folder containing NHGIS csv format data files and txt format codebook files")
	#	setwd(datadir)
	#}
	####################################

  #This function is not vectorized -- could later recode to handle multiple estimates files in one function call.
  #for (datafile in datafiles) {

	####################################
	#	CHECK FOR MISSING/BAD FOLDER OR FILENAMES
	####################################

	if (!file.exists(folder) ) {
		cat("WARNING: Folder", folder, " not found \n");cat("\n")
		return(NULL) # exits function now
	}
	if (!file.exists(file.path(folder, datafile)) ) {
		cat(paste("WARNING: Data file", datafile, " not found in\n", folder));cat("\n")
		return(NULL) # exits function now
	}
	if (!file.exists(file.path(folder, codebookfile)) ) {
		cat(paste("WARNING: Codebook file", codebookfile, " not found in\n", folder));cat("\n")
		return(NULL) # exits function now
	}

	oldwd <- getwd()
	on.exit(setwd(oldwd))
	setwd(folder)

	####################################
	#	CHECK FOR MATCHING ESTIMATES AND MOE FILES AS SEPARATE FILES
	#	AND ANY RELATED PROBLEMS
	####################################

	# The 20105 ACS summary file data provided by NHGIS had estimates and MOEs combined into a single file
	#	(per selected resolution like tract, or block group).
	# The 20115 ACS summary file data provided by NHGIS has estiamtes and MOEs in 2 separate files (per selected resolution like tract, or block group)
	# If E and M files are separate they must be read and combined.

	Efile <- FALSE	# assume this is not an Estimates-only file
	Mfile.exists <- FALSE	# assume no corresponding Marginoferror-only file exists
	Mfile <- FALSE
	Efile.exists <- FALSE
	getting.EM <- FALSE  # assume not getting this efile and also a matching moe file right now

	if (grepl("E\\.csv", datafile)) {
		Efile <- TRUE # this file is an Estimates-only file
		datafile.M <- gsub("E\\.csv", "M\\.csv", datafile)
		if (file.exists(datafile.M)) {Mfile.exists <- TRUE} # a matching MOE file exists
	}

	if (grepl("M\\.csv", datafile)) {
		Mfile <- TRUE # this file is an MOE-only file
		datafile.E <- gsub("M\\.csv", "E\\.csv", datafile)
		if (file.exists(datafile.E)) {Efile.exists <- TRUE} # a matching ESTIMATES file exists
	}

	if (Efile & Mfile.exists) {
		getting.EM <- TRUE
		# Read this datafile   & also read matching M datafile, remove duplicated cols except GISJOIN, & merge on that. Resort as orig?
		# Read this codebook & also read matching M codebookfile & c() them before parsing.
		# check if MOE codebook exists
		codebookfile.moe <- gsub("E_codebook", "M_codebook", codebookfile)
		if (!file.exists(file.path(folder, codebookfile.moe)) ) {
			cat(paste("WARNING: Codebook file", codebookfile.moe, " not found in\n", folder));cat("\n")
			return(NULL) # exits function now
		}
	}

	if (Mfile & Efile.exists) {
		# Don't read datafile or codebook as already did so or will do so in loop presumably? what if user tries to read only M file not all in dir()?
		#Just warn that presuming E has been read with M & break/return from fxn.
		cat("-----------------------"); cat("\n")
		cat("NOTE: Not reading this MARGIN OF ERROR file, because matching Estimates file found \n")
		cat("& presuming they were read together as call to function for estimates file\n")
		return(NULL) # exits function now
	}

	# Warnings about other combinations are at end of function.

	###############
	#	START READING FILES
	###############

	cat("-----------------------"); cat("\n")
	cat("Trying to read these specified files:"); cat("\n")
	cat(paste("Datafile: ", datafile)); cat("\n")
	cat(paste("Codebook: ", codebookfile)); cat("\n")
	cat("----------------------"); cat("\n")
	cat(Sys.time()); cat("\n")
	cat("Reading datafile...\n")
	cat(paste("Datafile: ", datafile)); cat("\n")

	################
	#	IMPORT ACS DATA FROM DOWNLOADED CSV FILE(S)
	################

	# Load R package Hmisc if using csv.get() to retain labels on fields
	# require(Hmisc)
	# acs <- csv.get(datafile, as.is=TRUE)
	acs <- read.csv(file.path(folder, datafile), as.is=TRUE)

	if (getting.EM)  {
		# Read the corresponding Margin of Error file and add its unique columns to the Estimates file.
		cat("and also reading the matching MOE file\n")
		# to have labelled columns, could use csv.get from Hmisc
		# acs.moe <- csv.get(datafile.M, as.is=TRUE)

		acs.moe <- read.csv(file.path(folder, datafile.M), as.is=TRUE)
		uniquecols <- names(acs.moe)[!(names(acs.moe) %in% names(acs))]
		orig.order <- acs$GISJOIN
		acs <- merge(acs, acs.moe[ , c("GISJOIN", uniquecols) ], by="GISJOIN")
		acs <- acs[ match(acs$GISJOIN, orig.order), ] # put back in original order just in case
	}

	cat(Sys.time()); cat("\n")
	cat("Done reading datafile"); cat("\n")
	cat("----------------------"); cat("\n")

	################################################################################################

	################
	#	READ CODEBOOK

	x <- read.codebook(codebookfile, folder)
	if (is.null(x)) { print("Codebook or folder missing or not valid"); return()}
	# will return table called varnames that has old, new, and long versions of estimate and MOE fields
	varnames <- x$fields

	# **** assumes they are in the correct sequence & uses new names (e.g., C01001.001) *****
	names(acs)[names(acs) %in% varnames$old] <- varnames$new

	#  also return  the geo/other columns not just estimates and MOE fields, and other info from read.codebook
	tables <- x$tables
	contextfields <- x$contextfields
	geolevel	<- x$geolevel
	years		<- x$years
	dataset		<- x$dataset

	################################################################################################

	############
	#	PRINT SUMMARY RESULTS
	############

	cat("----------------------"); cat("\n")
	#cat("Variables found in codebook:\n")
	#print(varnames)
	#cat("----------------------"); cat("\n")
	cat("Tables found according to codebook:\n"); cat("\n")
	print(tables); cat("\n")
	cat("----------------------"); cat("\n")
	cat("Number of rows (locations): "); cat(length(acs[, 1])); cat("\n")
	cat("----------------------"); cat("\n")
	# total (e.g. for 2007-2011) is 220334 bg which matches census website tally for US plus PR but without island areas.
	cat("States/etc. covered:"); cat("\n")
	print(unique(acs$STATE)); cat("\n")
	#cbind(table(acs$STATE))
	cat("----------------------"); cat("\n")

	if (Efile & !Mfile.exists) {
		cat("-----------------------"); cat("\n")
		cat("WARNING! This is an Estimates file but matching Margin of Error file can't be found!\n");cat("\n")
		cat("-----------------------"); cat("\n")
	}

	if (Mfile & !Efile.exists) {
		cat("-----------------------"); cat("\n")
		cat("WARNING! This is a Margin of Error file but matching Estimates file can't be found!\n");cat("\n")
		cat("-----------------------"); cat("\n")
	}

	if (!Efile & !Mfile) { cat("Note this file isn't named as Estimates-only or MOE-only.")}
	# e.g., old 20105 data formats from NHGIS had E/M combined in 1 datafile.

	#	Note one datafile and one codebook may contain >1 Census table.

  #could later recode to handle multiple files in one function call
  #} # end loop over multiple datafiles (if >1)

	setwd(oldwd)

#	CORRESPONDS TO WHAT read.codebook() RETURNS
	return(list(data=acs, contextfields=contextfields, fields=varnames, tables=tables,
		geolevel=geolevel, years=years, dataset=dataset ))

	#unique(gsub(".[[:digit:]]+$", "", varnames$new))
} # end of function
#######################################
