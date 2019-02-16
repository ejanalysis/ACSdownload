#' @title Download American Community Survey 5-yr data files
#' @description
#'   Attempts to download data files (estimates and margins of error) for specified states and tables,
#'   from the US Census Bureau's FTP site for American Community Survey (ACS) 5-year summary file data.
#'
#' @param tables Required character vector of table numbers, such as c("B01001", "B03002")
#' @param end.year Character element, optional, "2012" by default. Defines last of five years of summary file dataset; default is 2008-2012.
#' @param folder Default is getwd()
#' @param mystates Character vector, now optional - Default is 50 states + DC + PR here, but otherwise relies on \code{\link{clean.mystates}}
#' @param testing Default to FALSE. If TRUE, provides info on progress of download.
#' @param silent Optional, default is FALSE. Whether progress info should be sent to standard output (like the screen).
#' @param attempts Default is 5, specifies how many tries (maximum) for unzipping before trying to redownload and then give up.
#' @return Effect is to download and save locally a number of data files.
#' @seealso \code{\link[proxistat]{get.distances}} which allows you to get distances between all points.
#' @export
download.datafiles <-
  function(tables,
           end.year = "2012",
           mystates = 52,
           folder = getwd(),
           testing = FALSE,
           attempts = 5,
           silent = FALSE) {
    # FUNCTION TO DOWNLOAD ZIP FILES WITH DATA (ESTIMATES AND MOE)
    
    #stateinfo <- ejanalysis::get.state.info()
    # or could use
    data(lookup.states, package = 'proxistat', envir = environment())
    stateinfo <- lookup.states
    
    # VALIDATE STATES
    mystates <- clean.mystates(mystates)
    mystates <- unique(mystates[mystates != 'US'])
    
    seqfilelistnums <- which.seqfiles(tables, end.year = end.year)
    zipfile.prefix    <- get.zipfile.prefix(end.year)
    
    ################################################################# #
    #   OBTAIN ZIP FILES AND DATA FILES FROM INSIDE ZIP FILES
    ################################################################# #
    
    #	WILL DOWNLOAD ZIP FILE(S) with estimates data file and margin of error data file, one zip per state-seqfile combo
    
    ################################ #
    #	download zip files with data (estimates and margins of error)
    ################################ #
    
    ################# #
    #	SPECIFY URL AND ZIPFILE NAME
    # based on
    # seqfilelistnums (could recode to limit to specified seqfiles)
    # stateabbs ( recoded to limit to specified states)
    ################# #
    
    ################### #
    # to create a single list with all the zip file names:
    #	****  requires "seqfilelistnums" in memory, zipfile(), & mystates
    zipnames <- ""
    enames <- ""
    mnames <- ""
    for (st in mystates) {
      zipnames <-
        c(zipnames,
          zipfile(st, seqfilelistnums, zipfile.prefix, end.year = end.year))
      enames <-
        c(enames, datafile(st, seqfilelistnums, end.year = end.year))
    }
    mnames <- gsub("^e", "m", enames)
    #drop the null first element
    zipnames <- zipnames[-1]
    enames 	<- enames[-1]
    mnames	<- mnames[-1]
    ################### #
    
    # download them one at a time just in case - but note download.file is vectorized
    
    for (statenum  in 1:length(mystates)) {
      state.abbrev <- tolower(mystates[statenum])
      state.abbrev <-
        tolower(stateinfo$ST[tolower(state.abbrev) == tolower(stateinfo$ST)])
      
      # US zip files are empty - the moe and est files in them are size zero
      if (tolower(state.abbrev) == 'us') {
        next
      }
      
      state.name 	<-
        stateinfo$ftpname[tolower(state.abbrev) == tolower(stateinfo$ST)]
      #print(seqfilelistnums)
      
      for (seqfilenum in seqfilelistnums) {
        zipfile.fullpath <-
          file.path(
            url.to.find.zipfile(state.name, end.year = end.year),
            zipfile(state.abbrev, seqfilenum, end.year = end.year)
          )
        #if (testing) {
        #  cat(zipfile.fullpath); cat(' \n')
        #}
        if (seqfilenum == seqfilelistnums[1]) {
          #cat('Checking zipfiles such as ', zipfile(state.abbrev, seqfilenum, end.year = end.year)); cat(' ... \n')
          if (!silent) {
            cat(as.character(Sys.time()), ' ')
            cat('Checking zipfiles:  ')
          }
        }
        #if (!silent) {cat(zipfile(state.abbrev, seqfilenum, end.year = end.year), ' ')}
        if (!silent) {
          cat(state.abbrev, ' ')
        }
        
        # The US estimates and MOE files inside the US zips are empty & size zero.
        # Just in case any zip files are size zero here, delete them to avoid confusion.
        if (file.exists(file.path(
          folder,
          zipfile(state.abbrev, seqfilenum, end.year = end.year)
        ))) {
          if (file.info(file.path(
            folder,
            zipfile(state.abbrev, seqfilenum, end.year = end.year)
          ))$size == 0) {
            if (!silent) {
              cat('\n Warning: File size zero (deleting file now) for ')
              cat(zipfile(state.abbrev, seqfilenum, end.year = end.year))
              cat('\n')
            }
            file.remove(file.path(
              folder,
              zipfile(state.abbrev, seqfilenum, end.year = end.year)
            ))
          }
        }
        # DOWNLOAD ZIP IF  zip file is missing AND missing (estimates and/or moe file).
        # If have zip, or est+moe that was in zip, then don't need to download zip again.
        if ((!file.exists(file.path(
          folder,
          zipfile(state.abbrev, seqfilenum, end.year = end.year)
        ))) &
        (!file.exists(file.path(
          folder,
          datafile(state.abbrev, seqfilenum, end.year = end.year)
        )) |
        !file.exists(mfile <-
                     gsub(
                       "^e", "m", file.path(
                         folder,
                         datafile(state.abbrev, seqfilenum, end.year = end.year)
                       )
                     )))) {
          # IF PROBLEM DOWNLOADING, provide a warning message & retry a few times.
          # Note: if (file.exists(zipfile.fullpath) seems to fail at trying to check an FTP site.
          ok <- FALSE
          attempt <- 1
          while (!ok) {
            x <- try(download.file(zipfile.fullpath,
                                   file.path(
                                     folder,
                                     zipfile(state.abbrev, seqfilenum, end.year = end.year)
                                   ),
                                   quiet = !testing),
                     silent = !testing)
            
            ok <- TRUE
            attempt <- attempt + 1
            if (class(x) == "try-error") {
              ok <- FALSE
              if (!silent) {
                cat('Attempt #',
                    attempt,
                    " because unable to download data file ")
                cat(file.path(folder, zipfile(state.abbrev, seqfilenum)))
                cat(" on attempt ", attempt - 1, " ... \n")
              }
            } else {
              if (!silent) {
                cat('Downloaded. \n')
              }
            }
            
            # *** Some zip downloads give warnings that zip file size is
            # WRONG AND THEY ARE CORRUPT. Not clear how to check for and fix that.
            
            # might need to pause here to allow download to start so file size is not zero when checked below???
            
            # Also it is the US estimates and MOE files inside the US zips that are empty & size zero.
            if (file.info(file.path(
              folder,
              zipfile(state.abbrev, seqfilenum, end.year = end.year)
            ))$size == 0) {
              ok <- FALSE
              if (!silent) {
                cat('Warning: File size zero for ')
                cat(file.path(
                  folder,
                  zipfile(state.abbrev, seqfilenum, end.year = end.year)
                ))
                cat('\n')
              }
            }
            if (attempt > attempts) {
              if (!silent) {
                cat(
                  '\n*** Failed to obtain ',
                  file.path(
                    folder,
                    zipfile(state.abbrev, seqfilenum, end.year = end.year)
                  ),
                  'file after repeated attempts. May need to download manually. ***\n========================================\n'
                )
              }
              break
            }
          }
        } # end of if
        
      } # end of for loop over sequence files
      if (!silent) {
        cat(' \n')
      }
    } # end of for loop over states
    if (!silent) {
      cat(' \n')
    }
    
    ################# #
    # VERIFY ALL FILES WERE DOWNLOADED
    # BUT THIS DOESN'T CHECK IF ZIP FILE IS CORRUPT/VALID (other than checking for size 0 above)
    ################# #
    
    #zipsinfolder <- dir(pattern="zip", path=folder)
    #if ( any(!(zipnames %in% zipsinfolder)) ) {
    if (any(!((
      file.exists(file.path(folder, zipnames)) |
      (file.exists(enames) & file.exists(mnames))
    )))) {
      warning(
        '*** WARNING: Some zip files missing and their corresponding estimates and MOE files contents also not found locally'
      )
      #	got.zip.or.txts <- ( file.exists(file.path(folder, zipnames)) | (file.exists(file.path(folder, enames)) & file.exists(file.path(folder, mnames)) ) )
      #	cat("\n\nMissing zip and one or more data files (estimates/ MOE) for ")
      # cat(zipnames[!got.zip.or.txts]); cat("\n")
    } else {
      if (!silent) {
        cat(as.character(Sys.time()), ' ')
        cat(
          "All data zipfiles, or their estimates or MOE contents file, were downloaded/ found locally \n"
        )
      }
    }
    # note count of downloaded zip files should be
    # length(stateabbs) * length(seqfilelistnums)
    # e.g. 318
    #if (length(stateabbs) * length(seqfilelistnums) > length(dir(pattern="zip")) ) { print("please check count of zip files downloaded") }
    
  }	# end of download.datafiles()
