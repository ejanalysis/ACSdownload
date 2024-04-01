#' @title Download GEO txt file(s) with geo information for ACS
#'
#' @description
#'  Download text file from US Census Bureau with geographic information for American Community Survey.
#'  The geo file is used to join data file(s) to FIPS/GEOID/NAME/SUMLEVEL/CKEY.
#'  Used by [get.acs()]
#'
#' @details
#'   Downloads to the current working directory unless another folder is specified.
#'   In contrast to the data files, the geo file is not zipped so does not have to be unzipped once downloaded.
#'   Key functions used:
#' 
#'    - [url.to.find.zipfile()]
#'    - [geofile()]
#'    - `data(lookup.states, package="proxistat")`
#'  
#' @param mystates vector of character 2-letter State abbreviations specifying which are needed
#' @param end.year Specifies end year of 5-year summary file such as "2020" 
#' @param folder folder to use for saving files - default is current working directory
#' @param testing Default to FALSE. If TRUE, provides info on progress of download.
#' @param attempts Default is 5, specifies how many tries (maximum) for unzipping before trying to redownload and then give up.
#' @param silent Optional, default is FALSE. Whether progress info should be sent to standard output (like the screen)
#' @return Side effect is downloading the file.
#' @seealso [get.acs()] which uses this, and [get.read.geo()]
#' @examples
#'  \dontrun{
#'    download.geo("de")
#'    download.geo( c("pr", "dc") )
#'  }
#' @export
download.geo <-
  function(mystates,
           end.year = acsdefaultendyearhere_func(),
           folder = getwd(),
           testing = FALSE,
           attempts = 5,
           silent = FALSE) {
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    # ****  get names of states and geo files that correspond to state abbreviations parameter
    if (!exists('stateabbs') | !exists('statenames')) {
      #stateinfo	<- ejanalysis::get.state.info()
      # or else
      data(lookup.states, package = 'proxistat', envir = environment())
      stateinfo <- lookup.states
      
      statenames	<- stateinfo$ftpname
      stateabbs	<-
        tolower(stateinfo$ST) # stateabbs may be used later also
    }
    
    if (missing(mystates)) {
      mystates <- clean.mystates(stateabbs)
    }
    mystates <- tolower(mystates)
    
    #datafile.prefix 	<- get.datafile.prefix(end.year=end.year)
    geofilenames 	<- geofile(mystates, end.year = end.year)
    
    statenames.mine <- statenames[match(mystates, stateabbs)]
    # cat(statenames.mine); cat('\n')
    # https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/documentation/geography/5yr_year_geo/g20215us.txt
    # browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only/g20215de.txt")
    # > url.to.find.zipfile(2020)
    # [1] "https://www2.census.gov/programs-surveys/acs/summary_file/2021/data/5_year_seq_by_state/2020/Tracts_Block_Groups_Only"
    #     "https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only"
    full.geofilenames <-
      file.path(url.to.find.zipfile(statenames.mine, end.year = end.year),
                geofilenames)
    # Note download.file is not vectorized so use a loop:
    #  i.e., can't say download.file(full.geofilenames, geofilenames)
    
    if (!silent) {
      cat(as.character(Sys.time()), ' ')
      cat(
        'Attempting to download geographic data for each State, xx, from \n',
        file.path(
          url.to.find.zipfile('xx', end.year = end.year),
          geofile('xx', end.year = end.year)
        ),
        '\n\n'
      )
    }
    
    for (statenum in 1:length(mystates)) {
      if (mystates[statenum] != "us") {
        # Note Census does not provide a geo file that has all the US block groups and tracts in 1 file,
        # so avoid downloading the us geo file, which actually has counties etc., not tracts/blocks - A 50+ MB file not needed.
        missing.file <-
          !file.exists(file.path(folder, geofilenames[statenum]))
        if (!missing.file) {
          if (file.info(file.path(folder, geofilenames[statenum]))$size == 0) {
            ok <- FALSE
            if (!silent) {
              cat('Warning: File size zero for ')
              cat(geofilenames[statenum])
              cat(' ... removing empty file\n')
            }
            file.remove(file.path(folder, geofilenames[statenum]))
          }
        }
        if (missing.file) {
          # IF PROBLEM DOWNLOADING, provide a warning message & retry a few times.
          ok <- FALSE
          attempt <- 1
          while (!ok) {
            if (!silent) {
              cat(paste(rep(' ', 21), collapse = ''), 'Trying to download ')
            }
            if (!silent) {
              cat(mystates[statenum], ' ')
            }
            x <- try(download.file(full.geofilenames[statenum],
                                   file.path(folder, geofilenames[statenum]),
                                   quiet = !testing),
                     silent = !testing)
            
            # on windows in RStudio there is a bug/issue as of 7/2015 in using download.file():
            #Error in download.file(full.geofilenames[statenum], file.path(folder,  :
            #cannot open URL 'ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset/Delaware/Tracts_Block_Groups_Only/g20125de.txt'
            #In addition: Warning message:
            #  In download.file(full.geofilenames[statenum], file.path(folder,  :
            #     InternetOpenUrl failed: 'The FTP session was terminated'
            # Fixed issue by changing RStudio options:
            # http://stackoverflow.com/questions/22721819/download-file-fails-in-rstudio
            
            ok <- TRUE
            attempt <- attempt + 1
            if (class(x) == "try-error") {
              ok <- FALSE
              if (!silent) {
                cat(paste(rep(' ', 21), collapse = ''))
                cat("Warning: Unable so far to download geo file")
                cat(geofilenames[statenum])
                cat("\n")
              }
            }
            if (file.info(file.path(folder, geofilenames[statenum]))$size ==
                0) {
              ok <- FALSE
              if (!silent) {
                cat(paste(rep(' ', 21), collapse = ''),
                    'Warning: File size zero for ')
                cat(geofilenames[statenum])
                cat('\n')
              }
              file.remove(file.path(folder, geofilenames[statenum]))
            }
            if (attempt > attempts) {
              if (!silent) {
                cat(
                  '\n',
                  paste(rep(' ', 21), collapse = ''),
                  '*** Failed to obtain geo file',
                  geofilenames[statenum],
                  'after repeated attempts. Start again or download manually. ***\n'
                )
              }
              break
            }
          }
          if (!silent) {
            cat('\n')
          }
          
          # file.exists() doesn't seem to work for checking an ftp site. This fails (says FALSE):  but can instead use try(download.file( ... as done in other code here
          # file.exists('ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset/Delaware/Tracts_Block_Groups_Only/g20125de.txt')
          # but this still works:
          #download.file('ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset/Delaware/Tracts_Block_Groups_Only/g20125de.txt','test.txt')
          #				if (file.exists(full.geofilenames[statenum])) {
          #				} else { cat("WARNING: Can't find "); cat(full.geofilenames[statenum]);cat("\n") }
        } # missing.file initially
      }
    }
    
    # Verify all GEO downloaded OK
    
    if (any(!(file.exists(file.path(
      folder, geofilenames[geofilenames != geofile("us", end.year = end.year)]
    ))))) {
      warning('Some geo data files are missing')
      if (!silent) {
        cat(
          '\n',
          paste(rep(' ', 21), collapse = ''),
          "*** WARNING: Some geo data files that should have been downloaded are missing:\n"
        )
      }
      for (thisfile in geofilenames[geofilenames != geofile("us", end.year = end.year)]) {
        if (!(file.exists(file.path(folder, thisfile)))) {
          if (!silent) {
            cat(paste("Missing:  ", thisfile, "\n", sep = ""))
          }
        }
      }
      # stop("Stopped because of missing files.") # can just provide a warning
    } else {
      if (!silent) {
        cat(as.character(Sys.time()), ' ')
        cat("All geo files successfully downloaded \n")
      }
    }
  }
