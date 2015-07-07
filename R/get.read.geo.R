#' @title Download (if necessary) and merge GEO files for ACS
#' 
#' @description
#' Returns a data.frame of all states merged geo info and saves geo.RData to working directory.
#' 
#' @details
#' Read and compile geo data for entire USA with PR DC, \cr
#'	This takes some time for the entire USA:  \cr
#' \cr
#' 2 minutes 48 seconds on \cr
#' MacBook Pro 16 GB RAM, SSD, 2.7 GHz Intel Core i7\cr
#' R version: R 3.0.2 GUI 1.62 Snow Leopard build (6558)\cr
#' \cr
#' 8 minutes 20 seconds on \cr
#' R version 3.0.1 \cr
#' Dell Latitude E6400, x86 Family 6 Model 23 Stepping 6 GenuineIntel ~2260 Mhz, \cr
#' Total Physical Memory 4,096.00 MB, Available Physical Memory 1.97 GB, Total Virtual Memory 2.00 GB, Available Virtual Memory 1.94 GB, \cr
#' Microsoft Windows XP Professional \cr
#' ############## \cr
#' @param mystates Character vector of 2-character state abbreviations, required.
#' @param new.geo Logical value, optional, FALSE by default. If FALSE, if geo exists in memory don't download and parse again.
#' @param folder Defaults to current working directory.
#' @param end.year Defaults to "2012" to specify last year of 5-year summary file.
#' @return Returns a data.frame of all states geo info. \cr
#'   # FOR ACS 2008-2012, tract and block group counts: \cr
#'   table(geo$SUMLEVEL) \cr
#'     140    150  \cr
#'   74001 220333  \cr \cr
#'  Remaining fields in geo: \cr
#'  "STUSAB"   "SUMLEVEL" "GEOID"    "FIPS"     "KEY" \cr
#'  NOTE: do not really need GEOID or KEY. \cr
#'  GEOID is redundant, but might be useful for joining to shapefiles/ boundaries \cr
#'  Also, could specify here if "NAME" field from geo files should be dropped -  
#'  it might be useful but takes lots of RAM and encoding of Spanish characters in Puerto Rico caused a problem in Mac OSX. \cr
#'  NOTE FROM CENSUS:  \cr
#'  The ACS Summary File GEOID contains the necessary information to connect to the TIGER/Line Shapefiles, 
#'  but it needs to be modified in order to exactly match up. 
#'  Notice that the ACS GEOID, 05000US10001, contains the TIGER/Line GEOID string, 10001.
#'  In order to create an exact match of both GEOIDs, it is necessary to 
#'  remove all of the characters before and including the letter S in the ACS Summary File. 
#'  By removing these characters, the new GEOID in the ACS Summary File exactly matches the field GEOID in the TIGER/Line Shapefiles.
#' @seealso \code{\link{get.acs}} which uses this, and \code{\link{download.geo}}
#' @export
get.read.geo <- function(mystates, new.geo=FALSE, folder=getwd(), end.year='2012') {
  
  if (!new.geo) { # IF DO NOT WANT TO REDO WORK TO GET GEO DATA
    if (exists('geo')) {
      cat('Using geo info from prior work, already in memory\n')
      # skip download & parse
    }
    if (!exists('geo')) { 
      if (file.exists(file.path(folder, 'geo.RData'))) { 
        load('geo.RData') 
        cat('Loading geo.RData\n')
        # skip download & parse
      }
      if (!file.exists(file.path(folder, 'geo.RData'))) { 
        # Said !new.geo, but can't find old geo, so must do all parsing after all.
        # Repeating download.geo() is ok since checks for need to download, then do parsing
        cat('  Cannot find geo in memory or disk, so redoing parsing (downloading first if necessary)\n')
        new.geo <- TRUE 
      }
    }
  }
  
  if (new.geo) {  # IF WANT NEW GEO, do download & parse new geo.
    # if user choice is to create a new geo dataset, (default), do that here (downloading if needed, then parsing):
    
    cat(as.character(Sys.time()), ' '); cat("Started to download geo files \n")
    # note this won't re-download geofiles that have already been downloaded into the local data folder
    # don't need to specify   download.geo(..., data.path) since already did setwd(data.path)
    
    download.geo(mystates, end.year=end.year, folder=folder)
    
    # e.g.,  download.geo( c("pr", "dc") )
    cat(as.character(Sys.time()), ' '); cat("Finished downloading geo files \n")
    
    cat(as.character(Sys.time()), ' '); cat("Started parsing geo files \n")
    
    geo <- read.geo(mystates, folder=folder)
    
    cat(as.character(Sys.time()), ' '); cat("Finished parsing geo files \n")
    # or just for example
    # stateabbs.mine <- c("de", "dc");  geo <- read.geo( stateabbs.mine)
    gc()
    
    # CLEAN UP THE geo DATA
    
    cat(as.character(Sys.time()), ' '); cat("Started cleaning up geo files \n")
    # Cut white space (OR drop GEOID entirely), (but already used trim.whitespace so redundant)
    geo$GEOID <- gsub(" *$", "", geo$GEOID)
    #geo$GEOID <- NULL
    
    # Might also drop huge name field if it was imported (but it causes problems on OSX likely due to encoding)
    # or at least trim large amounts of white space at end of name field (but already used trim.whitespace)
    
    if ("NAME" %in% names(geo)) {
      geo$NAME <- gsub(" {2,}", "", geo$NAME)
      # geo$NAME <- NULL
    }
    
    ###############################
    # Add leading zeroes and create FIPS (don't actually need all these fields once FIPS and KEY are created)
    # An alternative way to create fips would be to extract it from the geoid field:
    # geo$FIPS <- gsub("[[:alnum:]]*US", "", geo$GEOID)
    
    geo$BLKGRP[is.na(geo$BLKGRP)] <- ""
    geo$TRACT	<- analyze.stuff::lead.zeroes(geo$TRACT, 6)
    geo$STATE	<- analyze.stuff::lead.zeroes(geo$STATE, 2)
    geo$COUNTY	<- analyze.stuff::lead.zeroes(geo$COUNTY, 3)
    geo$FIPS	<- with(geo, paste( STATE, COUNTY, TRACT, BLKGRP, sep=""))
    # Ideally would call these FIPS.ST, FIPS.COUNTY, FIPS.TRACT, FIPS as elsewhere
    
    ################################
    #	THE UNIQUE ID THAT WILL BE USED FOR JOINS IS A COMBO OF STATE AND LOGRECNO
    #	NOTE LOWER CASE STUSAB USED TO CREATE KEY
    
    geo$KEY <- paste(tolower(geo$STUSAB), geo$LOGRECNO, sep="")
    
    #  THESE CAN BE DROPPED, AT LEAST AFTER THE KEY FIELD IS CREATED: (saving about 8 MB of memory) 
    #  LOGRECNO, STATE, COUNTY,  TRACT, BLKGRP
    
    geo <- geo[ , names(geo)[!(names(geo) %in% c("LOGRECNO", "STATE", "COUNTY", "TRACT", "BLKGRP"))] ]
    
    cat(as.character(Sys.time()), ' '); cat("Finished cleaning up geo files \n")
    
    # if (save.files) {
    #  save this .RData file, so that restarting interrupted get.acs() will look for it and not recreate it once it is on disk.
    # Would save lots of time to avoid parsing geo files more than once - don't need to do that usually..?
    # unless first run on a few places and then expanded to more states? *** problem if sees small geo and doesn't make bigger one!
    cat(as.character(Sys.time()), ' '); cat("Started saving geo files on disk \n")
    # can save on disk in case a copy is needed later
    save(geo, file=file.path(folder, "geo.RData"))
    cat(as.character(Sys.time()), ' '); cat("Finished saving geo.RData file on disk \n")
    #  }
  }
  return(geo)
  ########################################## DONE reading GEO FILES ##########################
}
