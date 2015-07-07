#' @title Unzip ACS datafile per state, downloading missing ones first
#'
#' @description Unzip ACS datafile for each specified US State, extracting specified table(s), downloading missing zip files first.
#' 
#' @param tables Character vector of table numbers needed such as 'B01001'
#' @param mystates Character vector of 2-character state abbreviations. Default is all states.
#' @param folder Default is current working directory.
#' @param end.year Default is "2012" -- specifies last year of 5-year summary file.
#' @param testing Default is FALSE. If TRUE, prints filenames but does not unzip them.
#' @param attempts Default is 5, specifies how many tries (maximum) for unzipping before trying to redownload and then give up.
#' @return Side effect is unzipping file on disk (unless testing=TRUE)
#' @seealso \code{\link{get.acs}}
#' @export
unzip.datafiles <- function(tables, mystates, folder=getwd(), end.year = '2012', testing=FALSE, attempts=5) {
  
  myseqfiles <- which.seqfiles(tables)
  
  ####################
  # to create a single list with all the zip file names:
  zipnames <- ""
  for (st in mystates) { zipnames <- c(zipnames, zipfile(st, myseqfiles, end.year = end.year))}
  zipnames <- zipnames[-1]
  ####################
  
  #################################
  #	unzip data files
  #################################
  
  for (statenum  in 1:length(mystates)) {
    state.abbrev <- mystates[statenum]
    
    # IF THIS IS THE USA FILE, SKIP THIS 'STATE' BECAUSE US ZIP FILES HAVE EMPTY SIZE ZERO ESTIMATE/MOE FILES
    if (tolower(state.abbrev)=='us') { next }
    
    #state.name <- statenames[statenum]
    for (seqfilenum in myseqfiles) {
      efile <- datafile(state.abbrev, seqfilenum)
      mfile <- gsub("^e", "m", efile)
      if (testing) { 
        zipfile.prefix <- get.zipfile.prefix(end.year)
        print(zipfile(state.abbrev, seqfilenum, zipfile.prefix))
        print(cbind(efile, mfile))
      }
      if (!testing) { 
        
        if (!file.exists(file.path(folder, efile)) || !file.exists(file.path(folder, mfile))) {
          ok <- FALSE; attempt <- 1
          while (!ok) {
            
            unzip(
              zipfile = file.path(folder, zipfile(state.abbrev, seqfilenum)), 
              files = c( efile, mfile),
              exdir = folder
            ) 
            
            ok <- TRUE; attempt <- attempt + 1
            # Could check if efile and mfile now exist & retry zip download if not
            if (!file.exists(file.path(folder, efile)) || !file.exists(file.path(folder, mfile))) {
              ok <- FALSE 
            } else {
              
              # CHECK IF PROBLEM WITH FILE SIZE ZERO
              # Actually it is the US estimates and MOE files inside the US zips that are empty & size zero.
              if (file.info(file.path(folder, efile))$size==0 || file.info(file.path(folder, mfile))$size==0) {
                cat('Problem: File size zero for '); cat(efile); cat(' or '); cat(mfile); cat('\n')
                ok <- FALSE
              }
            }
            if (attempt > attempts) {
              cat('***Problem: Repeatedly failed to obtain valid data and/or moe file. May need to download/unzip manually. ***\n')
              break
            }
            if (!ok) { 
              # Try downloading the state's zip file(s) again, and then unzip just the problem one, since contents were missing/bad.
              # Not clear how to back calculate what tables are the ones in this seqfilenum !?
              # Assume end.year is available as a global or at least in this environment
              cat('Retrying download of zip file since bad/missing contents after unzip attempts.\n')
              
              download.datafiles(tables, end.year=end.year, mystates=state.abbrev, folder=folder) 
            }
          }
          
        }
      }
    }
  }
  
  # NOTE: A seq file HAS ONLY 2 FILES- ESTIMATES AND MARGIN OF ERROR- EVEN IF IT HAS MULTIPLE TABLES
  # so this loop is actually not critical - could just say
  #   unzip(zipfile(state.abbrev, seqfilenum))
  # inside the loop.
  # But this loop is useful since it checks if file exists and only unzips if the contents don't yet exist in the working directory.
  # So it avoids redoing the unzip if run twice, but fails to overwrite a corrupt version of zip contents if attempting to unzip again from redownloaded zip.
  #
  # NOTE: The unzip() function is not vectorized, can't say   unzip(zipnames) 
  
  #################################
  
  #################################
  # Verify again that all unzipped OK
  #################################
  
  ####################
  # to create a single list with all the data (estimate and moe) file names:
  #	
  etxtnames <- ""
  # ignore the US file when checking for missing files. It is size zero - no data.
  for (seqfilenum in myseqfiles) { etxtnames <- c(etxtnames, datafile(mystates[tolower(mystates)!='us'], seqfilenum)) }
  etxtnames <- etxtnames[-1]	
  mtxtnames <- gsub("^e", "m", etxtnames)
  ####################
  
  
  txtfilesinfolder <- dir(path=folder, pattern="txt")
  txtnames <- c(etxtnames, mtxtnames)
  if ( any(!(txtnames %in% txtfilesinfolder)) ) { 
    print("Some data files that should have been unzipped are missing:") 
    for (thisfile in txtnames) {
      if (!(thisfile %in% txtfilesinfolder)) { print(paste("Missing:  ", thisfile, sep=""))} 
    }
    stop("stopped because of missing files")
    while (1==0) {print(".")}
  }
  
  # in case of errors, output is like this:
  #[1] "some data files that should have been unzipped are missing"
  #
  #[1] "Missing:  e20125in0013000.txt"
  #[1] "Missing:  e20125mi0044000.txt"
  # and shows corresponding moe files also.
  
  #################################
  # missing files could be obtained and unzipped manually
  #################################
  
  # ...
  
  # data files count should be 
  #   2 * length(stateabbs) * length(seqfilelistnums)
  # or in this case 636
  # and total files with zip files included should be 
  #   3 * length(stateabbs) * length(seqfilelistnums)
  # or in this case 954
  # but only 938 resulted, meaning 16 failed/missing data files- these gave warning messages:
  #
  #Warning messages:
  #1: In unzip(zipfile(state.abbrev, seqfilenum), files = efile) :
  #  error 1 in extracting from zip file
  #2: In unzip(zipfile(state.abbrev, seqfilenum), files = mfile) :
  #  error 1 in extracting from zip file
  
  # delete zip files now that unzipped
  
  for (this.f in paste(getwd(), "/", zipnames, sep="")) {
    if (file.exists(this.f)) {
      file.remove(this.f)
    }
  }
  
}


