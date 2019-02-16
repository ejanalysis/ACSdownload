#' @title Read NHGIS.org ACS Codebook File
#' @description Helper function used by \code{\link{nhgis}} to read downloaded and unzipped codebook files obtained from NHGIS.org,
#'   for US Census Bureau data from the American Community Survey (ACS).
#' @param codebookfile Name(s) of codebook file(s).
#' @param folder Optional path where files are found. Default is getwd()
#' @return Returns a named list: data, contextfields, fields, tables, geolevel, years, dataset
#' @seealso  \code{\link{nhgis}} which uses this, \code{\link{nhgisread}} for reading datafiles, \code{\link{get.acs}}, \code{\link{get.datafile.prefix}}, \code{\link{datafile}}, \code{\link{geofile}}, \code{\link{get.zipfile.prefix}}
#' @export
nhgisreadcodebook <- function(codebookfile, folder = getwd()) {
  ############### #
  #	CODE FOR PARSING ACS (BLOCKGROUP & OTHER SCALES) DATA FILES DOWNLOADED FROM NHGIS.ORG
  #	To obtain data files and codebook, log in with an account at
  #	https://www.nhgis.org
  #	https://data2.nhgis.org/main
  #	and select, e.g., block groups, all in US, acs2007-2011, and specify one or more ACS Tables.
  #
  #
  #	Research using NHGIS data should cite it as:
  #	Minnesota Population Center. National Historical Geographic Information System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
  ############### #
  
  ############### #
  #	FUNCTION TO READ CODEBOOK FROM NHGIS DOWNLOAD OF ACS DATA
  #
  #	Reads codebook file obtained from NHIGIS.org
  #	Gets NHGIS variable names (e.g., JMJE001)
  #	Creates Census-like names (e.g. C17002.001) for estimates
  #	and ends variable names with ".m" for MOE (margin of error) values (e.g., C17002.001.m)
  #	Gets Census long versions of names (e.g., "Built 2005 or later")
  ############### #
  
  ################################### #
  #	CHECK FOR MISSING/BAD FOLDER OR FILENAMES
  ################################### #
  
  if (!file.exists(folder)) {
    cat("WARNING: Folder", folder, " not found \n")
    cat("\n")
    return(NULL) # exits function now
  }
  if (!file.exists(file.path(folder, codebookfile))) {
    stop(paste("Codebook file", codebookfile, " not found in\n", folder))
    cat("\n")
  }
  
  oldwd <- getwd()
  on.exit(setwd(oldwd))
  setwd(folder)
  
  Ecodebook <- FALSE
  Mcodebook <- FALSE
  getting.EM <- FALSE
  
  if (grepl("E_codebook", codebookfile)) {
    Ecodebook <- TRUE # this file is an Estimates-only codebook file
    codebookfile.moe <- gsub("E_codebook", "M_codebook", codebookfile)
    if (!file.exists(file.path(folder, codebookfile.moe))) {
      warning(paste(
        "Codebook file",
        codebookfile.moe,
        " not found in\n",
        folder
      ))
      cat("\n")
      # ****************
      return(NULL) # exit function now? ALLOW IT TO READ ESTIMATES CODEBOOK EVEN IF MOE CODEBOOK DOESN'T EXIST?
    }
    if (file.exists(file.path(folder, codebookfile.moe))) {
      # a matching MOE codebook exists
      getting.EM <-
        TRUE # reading matching E and M codebooks at same time
    }
  }
  
  if (grepl("M_codebook", codebookfile)) {
    Mcodebook <- TRUE # this file is an MOE-only codebook file
    # read it anyway, in case this function is called on its own, not from nhgisread()
    # return()
  }
  
  cat("\nReading codebook file...")
  cat("\n")
  cat(paste("Codebook: ", codebookfile))
  cat("\n")
  
  ######### #
  #	READ CODEBOOK AS LINES TO PARSE LONG VARIABLE NAMES, etc.
  ######### #
  
  #	Long variable names are stored this way in "codebook":
  # For 2006-2010 ACS:
  #	JMJE001: Total JMJE002: Not Hispanic or Latino
  # For 2007-2011 ACS:
  #"        MTXE002:     Built 2005 or later"
  
  codelines	<- scan(codebookfile, what = "character", sep = "\n")
  
  varlines	<-
    codelines[grep("[[:alnum:]]{4}[[:digit:]]{3}: +([[:print:]]+)$",
                   codelines)]
  nhgisnames	<-
    gsub(" +([[:alnum:]]{4}[[:digit:]]{3}): +([[:print:]]+)$",
         "\\1",
         varlines)
  longnames	<-
    gsub(" +[[:alnum:]]{4}[[:digit:]]{3}: +([[:print:]]+)$",
         "\\1",
         varlines)
  
  dataset		<-
    gsub(
      "Dataset: +([[:graph:]]+)",
      "\\1",
      grep("Dataset: +([[:graph:]]+)", codelines, value = TRUE)
    )
  years		<-
    gsub(
      "Year: +([[:graph:]]+)$",
      "\\1",
      grep("Year: +([[:graph:]]+)$", codelines, value = TRUE)
    )
  geolevel	<-
    gsub(
      "Geographic level: +([[:graph:]]+)$",
      "\\1",
      grep("Geographic level: +([[:graph:]]+)", codelines, value = TRUE)
    )
  tablenames	<-
    gsub(
      " +Table {1}[[:graph:]]+: +([[:graph:]]+)",
      "\\1",
      grep(" +Table {1}[[:graph:]]+: +([[:graph:]]+)", codelines, value = TRUE)
    )
  tnum <- length(tablenames)
  
  # in case estimates and MOE are both in codebook:
  if (tnum / 2 == floor(tnum / 2)) {
    if (tablenames[1 + tnum / 2] == tablenames[1]) {
      tablenames <- tablenames[1:(tnum / 2)]
      tnum <- length(tablenames)
    }
  }
  
  universes	<-
    gsub(
      " +Universe: +([[:graph:]]+)",
      "\\1",
      grep(" +Universe: +([[:graph:]]+)", codelines, value = TRUE)
    )
  universes	<-
    universes[1:tnum] # in case multiple copies of the set found which there were
  
  ############### #
  #	GET CONTEXT FIELDS
  ############### #
  
  contextline.first <- 1 + grep("Context Fields",  codelines)
  
  # This used to work in older dataset:
  #  contextline.last <- -2 + grep("Breakdown/Data Type",  codelines)
  # That finds two lines if the codebook covers estimates and MOEs as well. We just want one.
  #  contextline.last <- contextline.last[1]
  # This might in newer (20135):
  # find first appearance of blank line after the contextline.first row...
  contextline.last <-
    contextline.first - 2 + grep("^ *$",  codelines[contextline.first:length(codelines)])[1]
  
  contextlines <- codelines[contextline.first:contextline.last]
  contextfields <-
    data.frame(matrix(gsub("  +", "", unlist(
      strsplit(contextlines, ":")
    )), ncol = 2, byrow = TRUE), stringsAsFactors = FALSE)
  names(contextfields) <- c("old", "long")
  contextfields$new <- contextfields$old
  contextfields <- contextfields[, c("old", "new", "long")]
  
  ############### #
  #	READ CODEBOOK(S) AS VECTOR OF WORDS TO PARSE SHORT VARIABLE NAMES
  ############### #
  
  codebook 		<- scan(codebookfile, what = "list")
  
  if (getting.EM)  {
    cat("and also reading corresponding MOE codebook file\n")
    
    # read as lines to get long varnames from moe file
    # longnames.moe should be the same names repeated
    # nhgisnames.moe will be same as for estimates but with M not E as last letter
    codelines	<- scan(codebookfile.moe, what = "character", sep = "\n")
    varlines	<-
      codelines[grep("[[:alnum:]]{4}[[:digit:]]{3}: +([[:print:]]+)$",
                     codelines)]
    nhgisnames.moe	<-
      gsub(" +([[:alnum:]]{4}[[:digit:]]{3}): +([[:print:]]+)$",
           "\\1",
           varlines)
    nhgisnames	<- c(nhgisnames, nhgisnames.moe)
    longnames.moe	<-
      gsub(" +[[:alnum:]]{4}[[:digit:]]{3}: +([[:print:]]+)$",
           "\\1",
           varlines)
    longnames 	<- c(longnames, longnames.moe)
    # e.g.,
    #	   nhgisnames longnames
    #  [1,] "MNIE001"  "Total"
    #  [2,] "MNIE002"  "Male"
    #  [3,] "MNIE003"  "Male: Under 5 years"
    
    # Read this codebook & also read matching M codebookfile & c() them.
    # read as vector of words to get short varnames from moe file (should be the same names repeated)
    codebook <- c(codebook, scan(codebookfile.moe, what = "list"))
  }
  
  cat("Done reading codebook file(s)")
  cat("\n")
  
  ########### #
  #	GET SHORT VARIABLE NAMES USED BY NHGIS AND NAMES USED BY CENSUS
  ########### #
  # note that codebook is essential here - they rename the variables from what Census uses
  # e.g. see "nhgis0001_ds176_20105_2010_blck_grp_codebook.txt" or whatever the file is called.
  # parse that codebook to extract these lines (which appear repeatedly):
  #
  #   Source code: B03002
  #   NHGIS code:  JMJ
  #
  #   Source code: C17002
  #   NHGIS code:  JOC
  #
  # not the fastest way to do this, but it works:
  # Look for this type of pattern, repeatedly, to find the pairs of short fieldnames:
  # "Source","code:","B03002","NHGIS","code:","JMJ"
  
  wordnum.source <- grep("Source", codebook)
  wordnum.code <- grep("code:", codebook)
  wordnum.both <-
    wordnum.source[(wordnum.source + 1) %in% wordnum.code]
  
  wordnum.nhgis <- grep("NHGIS", codebook)
  wordnum.code <- grep("code:", codebook)
  wordnum.both.NHGIS <-
    wordnum.nhgis[(wordnum.nhgis + 1) %in% wordnum.code]
  
  wordnum.all4 <-
    wordnum.both[(wordnum.both + 3) %in% wordnum.both.NHGIS]
  tablepairs <-
    data.frame(unique(cbind(
      table.num = codebook[wordnum.all4 + 2],
      table.code = codebook[wordnum.all4 + 5]
    )), stringsAsFactors = FALSE)
  table.nums 	<- tablepairs$table.num
  table.codes	<- tablepairs$table.code
  
  # e.g., head(tablepairs)
  #		  table.num table.code
  #1    B01001        MNI
  #2    B03002        MN2
  #3    B15002        MPS
  #4    B16002        MPT
  #5    C17002        MPV
  #6    B25034        MTX
  
  ####### #
  #	LOOP TO RENAME VARIABLES FOR EACH TABLE TO FOLLOW CENSUS CONVENTIONS or at least close to that:
  #
  #	This code puts variables into this format:
  #	C17002.001, C17002.001.m
  ####### #
  
  # e.g., cbind(nhgisnames, longnames)
  #	   nhgisnames longnames
  #  [1,] "MNIE001"  "Total"
  #  [2,] "MNIE002"  "Male"
  #  [3,] "MNIE003"  "Male: Under 5 years"
  
  # e.g.,
  #		  table.num table.code
  #1    B01001        MNI
  #2    B03002        MN2
  #3    B15002        MPS
  
  convert <- function(oldvars, oldtabs, newtabs) {
    for (i in 1:(length(oldtabs))) {
      oldvars <-
        gsub(paste(oldtabs[i], "E", sep = ""),
             paste(newtabs[i], ".", sep = ""),
             oldvars)
      oldvars <-
        gsub(
          paste(oldtabs[i], "M([[:alnum:]]+)", sep = ""),
          paste(newtabs[i], ".\\1.m", sep = ""),
          oldvars
        )
    }
    newvars.here <- oldvars
    return(newvars.here)
  }
  
  newnames <- convert(nhgisnames, table.codes, table.nums)
  
  # in newnames, find first and last character of xxxxxx. which provides the table number that each individual variable came from
  find.tabnums <- regexpr("[[:alnum:]]+.", newnames)
  startchar <- as.numeric(find.tabnums)
  endchar <- attr(find.tabnums, "match.length")
  tablenum.per.name <- substr(newnames, startchar, endchar - 1)
  
  ########### #
  #	PUT TOGETHER DATA FRAME OF OLD NHGIS CODENAMES FROM CODEBOOK, NEW NAMES IN CENSUS-LIKE FORMAT, AND COMPLETE LONG FIELD NAMES:
  ########### #
  
  varnames <-
    data.frame(
      tablenum = tablenum.per.name,
      old = nhgisnames,
      new = newnames,
      stringsAsFactors = FALSE
    )
  varnames$long <- longnames[match(varnames$old, nhgisnames)]
  varnames$long[is.na(varnames$long)] <-
    varnames$old[is.na(varnames$long)]
  
  tables <-
    data.frame(
      old = table.codes,
      new = table.nums,
      long = tablenames,
      universe = universes,
      stringsAsFactors = FALSE
    )
  
  return(
    list(
      contextfields = contextfields,
      fields = varnames,
      tables = tables,
      geolevel = geolevel,
      years = years,
      dataset = dataset
    )
  )
}
