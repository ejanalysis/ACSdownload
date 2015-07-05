#' @title Download American Community Survey 5-yr data files
#' @description
#'   Attempts to download data files (estimates and margins of error) for specified states and tables, 
#'   from the US Census Bureau's FTP site for American Community Survey (ACS) 5-year summary file data.
#' 
#' @param tables Required character vector of table numbers, such as c("B01001", "B03002")
#' @param end.year Character element, optional, "2012" by default. Defines last of five years of summary file dataset; default is 2008-2012.
#' @param mystates Character vector, required. Defines states/DC/PR for which files should be downloaded.
#' @return Effect is to download and save locally a number of data files.
#' @seealso \code{\link{get.distances}} which allows you to get distances between all points.
#' @export
download.datafiles <- function(tables, end.year="2012", mystates) {

  # FUNCTION TO DOWNLOAD ZIP FILES WITH DATA (ESTIMATES AND MOE)
  
  stateinfo <- ejanalysis::get.state.info()
  # or now could use data()
  
	seqfilelistnums <- which.seqfiles(tables)
	zipfile.prefix    <- get.zipfile.prefix(end.year)
	
    ##################################################################
    #   OBTAIN ZIP FILES AND DATA FILES FROM INSIDE ZIP FILES
    ##################################################################
    
    #	WILL DOWNLOAD ZIP FILE(S) with estimates data file and margin of error data file, one zip per state-seqfile combo
    
    #################################
    #	download zip files with data (estimates and margins of error)
    #################################
    
    	##################
    	#	SPECIFY URL AND ZIPFILE NAME
    	# based on 
    	# seqfilelistnums (could recode to limit to specified seqfiles)
    	# stateabbs ( recoded to limit to specified states)
    	##################
  
      ####################
    # to create a single list with all the zip file names:
    #	****  requires "seqfilelistnums" in memory, zipfile(), & mystates
    zipnames <- ""
	enames <- ""
	mnames <- ""
    for (st in mystates) {
    	zipnames <- c(zipnames, zipfile(st, seqfilelistnums, zipfile.prefix))
    	enames <- c(enames, datafile(st, seqfilelistnums))
    }
    mnames <- gsub("^e", "m", enames)
	#drop the null first element
    zipnames <- zipnames[-1]
	enames 	<- enames[-1]
	mnames	<- mnames[-1]
    ####################
    
    # download them one at a time just in case - but note download.file is vectorized

    for (statenum  in 1:length(mystates)) {
    	state.abbrev <- tolower(mystates[statenum])
    	state.abbrev <- tolower(stateinfo$ST[tolower(state.abbrev)==tolower(stateinfo$ST)])

      # US zip files are empty - the moe and est files in them are size zero
      if (tolower(state.abbrev)=='us') {next}

      state.name 	<- stateinfo$ftpname[tolower(state.abbrev)==tolower(stateinfo$ST)]
	#print(seqfilelistnums)

    	for (seqfilenum in seqfilelistnums) {
    		zipfile.fullpath <- file.path( url.to.find.zipfile(state.name), zipfile(state.abbrev, seqfilenum) ) 
    		#if (testing) { 
    		#  cat(zipfile.fullpath); cat(' \n')
    		#}
    		cat('Checking ', zipfile(state.abbrev, seqfilenum)); cat(' ... ')

        # The US estimates and MOE files inside the US zips are empty & size zero.
        # Just in case any zip files are size zero here, delete them to avoid confusion.
    		if (file.exists(zipfile(state.abbrev, seqfilenum))) {
          if (file.info(zipfile(state.abbrev, seqfilenum))$size==0) {
    		    cat('Warning: File size zero (deleting file now) for '); cat(zipfile(state.abbrev, seqfilenum));cat('\n')
            file.remove(zipfile(state.abbrev, seqfilenum))
    		  }
    		}
    		# DOWNLOAD ZIP IF  zip file is missing AND missing (estimates and/or moe file).
    		# If have zip, or est+moe that was in zip, then don't need to download zip again.
    		if ( (!file.exists(zipfile(state.abbrev, seqfilenum))) & 
    		       (!file.exists( datafile(state.abbrev, seqfilenum)) | 
    		          !file.exists( mfile <- gsub("^e", "m", datafile(state.abbrev, seqfilenum)) ))) {
    		  
    		  # IF PROBLEM DOWNLOADING, provide a warning message & retry a few times.
    		  # Note: if (file.exists(zipfile.fullpath) seems to fail at trying to check an FTP site.
    		  ok <- FALSE; attempt <- 1
    		  while (!ok) {
    		    x <- try(download.file(zipfile.fullpath, zipfile(state.abbrev, seqfilenum), quiet=TRUE) ,silent=TRUE )
    		    
    		    ok <- TRUE; attempt <- attempt + 1
    		    if (class(x)=="try-error") {
    		      ok<-FALSE; cat('Attempt #', attempt, " because unable to download data file "); cat(zipfile(state.abbrev, seqfilenum)); cat(" on attempt ",attempt-1," ... \n")
    		    } else {cat('Downloaded. \n')}
    		    # Some zip downloads give warnings that zip file size is
    		    # WRONG AND THEY ARE CORRUPT. Not clear how to check for and fix that.
    		    
            # might need to pause here to allow download to start so file size is not zero when checked below???
            
    		    # Also it is the US estimates and MOE files inside the US zips that are empty & size zero.
    		    if (file.info(zipfile(state.abbrev, seqfilenum))$size==0) {
    		      ok<-FALSE; cat('Warning: File size zero for ');cat(zipfile(state.abbrev, seqfilenum));cat('\n')
    		    }
    		    if (attempt > 5) {
    		      cat('\n*** Failed to obtain file after repeated attempts. May need to download manually. ***\n========================================\n')
    		      break
    		    }
    		  }
    		} # end of if 	
    		
    	} # end of for loop over sequence files
    } # end of for loop over states
	
    ##################
    # VERIFY ALL FILES WERE DOWNLOADED
    # BUT THIS DOESN'T CHECK IF ZIP FILE IS CORRUPT/VALID (other than checking for size 0 above)
    ##################
    
#    zipsinfolder <- dir(pattern="zip")
#    if ( any(!(zipnames %in% zipsinfolder)) ) { 
#    	cat("Some zip files missing (but data files from them may be here)\n") 
#    
#    }

#	got.zip.or.txts <- ( file.exists(zipnames) | (file.exists(enames) & file.exists(mnames) ) ) 
#	cat("\n\nMissing zip and one or more data files (estimates/ MOE) for ")
# cat(zipnames[!got.zip.or.txts]); cat("\n")
	
    # note count of downloaded zip files should be 
    # length(stateabbs) * length(seqfilelistnums)
    # e.g. 318
    #if (length(stateabbs) * length(seqfilelistnums) > length(dir(pattern="zip")) ) { print("please check count of zip files downloaded") }
    # 
    #e.g. 
    #Warning messages:
    #1: In download.file(zipfile.fullpath, zipfile(state.abbrev,  ... :
    #  downloaded length 349760 != reported length 351410
    #2: In download.file(zipfile.fullpath, zipfile(state.abbrev,  ... :
    #  downloaded length 519472 != reported length 519485   ...

}	# end of download.datafiles()
