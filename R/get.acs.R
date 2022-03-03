#' @title Download Tables from American Community Survey (ACS) 5-year Summary File
#'
#' @description
#'   This function will download and parse 1 or more tables of data from the American Community Survey's
#'   5-year Summary File FTP site, for all Census tracts and/or block groups in specified State(s).
#'   Estimates and margins of error are obtained, as well as long and short names for the variables,
#'   which can be specified if only parts of a table are needed. \cr\cr
#'   It is especially useful if you want a lot of data such as all the blockgroups in the USA,
#'   which may take a long time to obtain using the Census API and a package like \pkg{\link[tidycensus]{tidycensus}} \cr\cr
#'   Release schedule for ACS 5-year data is here: \url{https://www.census.gov/programs-surveys/acs/news/data-releases.html}
#'   The 2016-2020 ACS 5-year estimates release date is December 9, 2021.
#' @details
#'   The United States Census Bureau provides detailed demographic data by US Census tract and block group
#'   in the American Community Survey (ACS) 5-year summary file via their FTP site. For those interested in block group or tract data,
#'   Census Bureau tools tend to focus on obtaining data one state at a time rather than for the entire US at once.
#'   This function lets a user specify (tables and) variables needed. This will look up what sequence files
#'   contain those tables. Using a table of variables for those selected tables, a user can specify variables
#'   or tables to drop by putting x or anything other than "Y" in the column specifying needed variables. \cr\cr
#'   For ACS documentation, see for example:\cr\cr
#'   \url{http://www.census.gov/programs-surveys/acs.html} \cr
#' @param tables Character vector, optional. Defines tables to obtain, such as 'B01001' (the default).
#'   NOTE: If the user specifies a table called 'ejscreen' then a set of tables used by that tool are included.
#'   Those tables are "B01001", "B03002", "B15002", "B16002", "C17002", "B25034"
#' @param base.path Character, optional, getwd() by default. Defines a base folder to start from, in case
#'   data.path and/or output.path are not specified, in which case a subfolder under base.path,
#'   called acsdata or acsoutput respectively, will be created and used for downloads or outputs of the function.
#' @param data.path Character, optional, file.path(base.path, 'acsdata') by default.
#'   Defines folder (created if does not exist) where downloaded files will be stored.
#' @param output.path Character, optional, file.path(base.path, 'acsoutput') by default.
#'   Defines folder (created if does not exist) where output files (results of this function) will be stored.
#' @param end.year Character, optional. Defines a valid ending year of a 5-year summary file.
#'   Can be '2020' for example. Not all years are tested. Actually works if numeric like 2017, instead of character, too.
#' @param mystates Character vector, optional, 'all' by default which means all available states
#'   plus DC and PR but not VI etc. Defines which States to include in downloads of data tables.
#' @param sumlevel Default is "both" (case insensitive) in which case tracts and block groups are returned.
#'   Also c('tract', 'bg') or c(140,150) and similar patterns work.
#'   If "tract" or 140 or some other match, but not block groups, is specified (insensitive to case, tract can be plural or part of a word, etc.),
#'   just tracts are returned.
#'   If "bg" or 150 or "blockgroups" or "block groups" or some other match (insensitive to case, singular or plural or part of a word)
#'   but no match on tracts is specified, just block groups are returned.
#'   Non-matching elements are ignored (e.g., sumlevel=c('bg', 'tracs', 'block') will return block groups
#'   but neither tracts (because of the typo) nor blocks (not available in ACS), with no warning --
#'   No warning is given if sumlevel is set to a list of elements where some are not recognized as matches to bg or tract,
#'   as long as one or more match bg, tracts, or both (or variants as already noted).
#' @param vars Optional, default is 'all' (in which case all variables from each table will be returned unless otherwise specified -- see below).
#'   This parameter specifies whether to pause and ask the user about which variables are needed in an interactive session in R.
#'   This gives the user a chance to prepare the file "variables needed.csv" (or just ensure it is ready),
#'   or to edit and save "variables needed.csv" within a window in the default editor used by R (the user is asked which of these is preferred).
#'   If vars is 'ask', the function just looks in \code{data.folder} for a file called "variables needed.csv" that, if used,
#'   must specify which variables to keep from each table.
#'   The format of that file should be the same as is found in the file "variables needed template.csv" created by this function --
#'   keeping the letter "Y" in the column named "keep" indicates the given variable is needed.
#'   A blank or "N" or other non-Y specifies the variable should be dropped and not returned by get.acs().
#'   If the "variables needed.csv" file is not found, however, this function looks for and uses the file called "variables needed template.csv"
#'   which is written by this function and specifies all of the variables from each table, so all variables will be retained and returned by get.acs().
#' @param varsfile See help for \code{\link{set.needed}} for details. Optional name of file that can be used to specify which variables are needed from specified tables.
#'   If varsfile is specified, parameter vars is ignored, and the function just looks in folder for file called filename, e.g., "variables needed.csv"
#'   that should specify which variables to keep from each table.
#' @param new.geo Default is TRUE. If FALSE, just uses existing downloaded geo file if possible. If TRUE, forced to download geo file even if already done previously.
#' @param write.files Default is FALSE, but if TRUE then data-related csv files are saved locally -- Saves longnames, full fieldnames as csv file, in working directory.
#' @param save.files Default is FALSE, but if TRUE then various intermediate image files are saved as .RData files locally in working directory.
#' @param write.acspkg Default is FALSE. If TRUE, saves csv file of tracts and file of block groups, for each of the \code{tables},
#'   in a format that the Census Bureau American Fact Finder provides as downloadable tables. That format can be easily read in by the very useful \pkg{acs} package.
#' @param testing Default is FALSE, but if TRUE more information is shown on progress, using cat() and while downloading, and more files (csv) are saved in working directory. But see silent parameter.
#' @param noEditOnMac FALSE by default. If TRUE, do not pause to allow edit() to define which variables needed from each table,
#'   when on Mac OSX, even if vars=TRUE. Allows you to avoid problem in RStudio if X11 not installed.
#' @param filename.log Optional name (without extension) for a log file, which gets date and time and .txt extension appended to it. Default is "log"
#' @param save.log Optional logical, default is TRUE. Should log file be saved in output.path folder
#' @param silent Optional logical, default is FALSE. Should progress updates be shown (sent to standard out, like the screen).
#'
#' @return By default, returns a list of ACS data tables and information about them, with these elements in the list: \cr
#'   bg, tracts, headers, and info. The headers and info elements are data.frames providing metadata such as short and long field names.
#'   The same column names are found in x$info and x$headers, but headers has more rows. The info table just provides information about each
#'   data variable in the estimates tables. The headers table provides similar information but made to match the bg or tract format,
#'   so the headers table has as many rows as bg or tracts has columns -- enough for the estimates and MOE fields, and the basic fields such as FIPS.
#'   The info data.frame can look like this, for example: \cr
#'  \preformatted{
#'   'data.frame':	xxxx obs. of  9 variables:
#'  $ table.ID       : chr  "B01001" "B01001" "B01001" "B01001" ...
#'  $ line           : num  1 2 3 4 5 6 7 8 9 10 ...
#'  $ shortname      : chr  "B01001.001" "B01001.002" "B01001.003" "B01001.004" ...
#'  $ longname       : chr  "Total:" "Male:" "Under 5 years" "5 to 9 years" ...
#'  $ table.title    : chr  "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" ...
#'  $ universe       : chr  "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" ...
#'  $ subject        : chr  "Age-Sex" "Age-Sex" "Age-Sex" "Age-Sex" ...
#'  $ longname2      : chr  "Total" "Male" "Under5years" "5to9years" ...
#'  $ longname.unique: chr  "Total:|SEX BY AGE" "Male:|SEX BY AGE" "Under 5 years|SEX BY AGE" "5 to 9 years|SEX BY AGE" ...
#'  }
#' @seealso \pkg{\link[acs]{acs}} package, which allows you to download and work with ACS data (using the API and your own key).
#'    To get the tables and variables used in EJSCREEN, see \link[ejscreen]{ejscreen.download}.
#'    Also see \code{\link{nhgis}} which parses any files manually downloaded from \url{NHGIS.org}
#' @examples
#'   ##### Basic info on ACS tables:
#'   cbind(table(lookup.acs2019$Subject.Area))
#'  \dontrun{
#'   ##### Basic info on ACS tables:
#'   t( get.table.info('B01001', end.year = acsdefaultendyearhere_func()) )
#'   t( get.table.info(c('B17001', 'C17002'), end.year = 2019) )
#'   get.field.info('C17002', end.year = 2019)
#'   ##### Data for just DC & DE, just two tables:
#'   outsmall <- get.acs(tables = c('B01001', 'C17002'), mystates=c('dc','de'),
#'    end.year = acsdefaultendyearhere_func(), base.path = '~/Downloads', write.files = T, new.geo = FALSE)
#'   summary(outsmall)
#'   t(outsmall$info[1, ])
#'   t(outsmall$bg[1, ])
#'
#'    ## ENTIRE USA -- DOWNLOAD AND PARSE -- TAKES A COUPLE OF MINUTES for one table:
#'    acs_2014_2018_B01001_vars_bg_and_tract <- get.acs(
#'      base.path='~/Downloads', end.year='2018', write.files = TRUE, new.geo = FALSE)
#'
#'   ########################################################################
#'   ##### Data for just DC & DE, just the default pop count table:
#'   out <- get.acs(mystates=c('dc','de'), end.year = acsdefaultendyearhere_func(), new.geo = FALSE)
#'   names(out$bg); cat('\n\n'); head(out$info)
#'   head(t(rbind(id=out$headers$table.ID, long=out$headers$longname, univ=out$headers$universe,
#'      subj=out$headers$subject,  out$bg[1:2,]) ), 15)
#'   cbind(longname=out$info$longname,
#'         total=colSums(out$bg[ , names(out$bg) %in% out$info$shortname ]))
#'   ### to see data on 2 places, 1 per column, with short and long field names
#'   cbind( out$headers$longname, t(out$bg[1:2, ]) )
#'   ### to see 7 places, 1 per row, with short and long field name as header
#'   head( rbind(out$headers$longname, out$bg) )[,1:7]
#'   ##### just 2 tables for just Delaware
#'   out <- get.acs(mystates='de', tables=c('B01001', 'C17002'))
#'   summary(out); head(out$info); head(out$bg)
#'   ##### uses all EJSCREEN defaults and the specified folders:
#'   out <- get.acs(base.path='~', data.path='~/ACStemp', output.path='~/ACSresults')
#'   summary(out); head(out$info); head(out$bg)
#'   ##### all tables needed for EJSCREEN, plus 'B16001',
#'     with variables specified in 'variables needed.csv', all states and DC and PR:
#'   out <- get.acs(tables=c('ejscreen', 'B16001'))
#'   summary(out); head(out$info); head(out$bg)
#'  }
#'
#' @note
#' #' #####################################	ADDITIONAL NOTES ######################################\cr
#' 	SEE CENSUS ACS DOCUMENTATION ON NON-NUMERIC FIELDS IN ESTIMATE AND MOE FILES.\cr \cr
#'  Note relevant sequence numbers change over time. \cr
#' ############# \cr \cr
#' #####################################################################################  \cr
#'	NOTES on where to obtain ACS data - sources for downloads of summary file data  \cr
#' ##################################################################################### \cr\cr \cr
#'
#' FOR ACS SUMMARY FILE DOCUMENTATION, SEE \cr
#' \url{http://www.census.gov/acs/www/data_documentation/summary_file/} \cr \cr
#'
#' 	As of 12/2012, ACS block group/tract summary file ESTIMATES on FTP site is provided as either \cr\cr
#'
#'  LARGER THAN NECESSARY: \cr\cr
#'
#'	*** all states and all tables in one huge tar.gz file (plus a zip of all geography codes), \cr
#'	\url{ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)} \cr
#'	\url{ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)/2011_ACS_Geography_Files.zip} \cr
#'	2011_ACS_Geography_Files.zip		# \cr
#'	Tracts_Block_Groups_Only.tar.gz		# (THIS HAS ALL THE SEQUENCE FILES FOR EACH STATE IN ONE HUGE ZIP FOLDER) \cr\cr
#'
#' or \cr\cr
#'
#'  MORE FOCUSED DOWNLOADS: \cr\cr
#'
#'	*** one zip file per sequence file PER STATE:    (plus csv of geography codes) \cr \cr
#'
#'	\url{http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/} \cr
#'         20115dc0002000.zip (Which has the e file and m file for this sequence file in this state) \cr
#'         g20115dc.csv  (which lets you link FIPS to data) \cr
#'	so this would mean 50+ * about 7 sequence files? = about 350 zip files?? each with 2 text files. Plus 50+ geo csv files.
#'	so downloading about 400 files and expanding to about 750 files, and joining into one big file.\cr
#'
#' OR \cr\cr
#'
#'  PREJOINED TO TIGER BLOCK GROUP BOUNDARIES SHAPEFILES/ GEODATABASES - \cr
#'	ONE PER STATE HAS SEVERAL TABLES BUT NOT B16001, B16002 (many languages but tracts only), B16004 (has block groups but fewer languages) \cr
#'	\url{http://www.census.gov/geo/maps-data/data/tiger-data.html} \cr
#'  BUT NOT one file per sequence file FOR ALL STATES AT ONCE. \cr
#' Estimates & margin of error (MOE), (ONCE UNZIPPED), and GEOgraphies (not zipped) are in 3 separate files. \cr \cr
#'
#' also, data for entire US for one seq file at a time, but not tract/bg -- just county and larger? -- is here, e.g.:
#' \url{ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/20111us0001000.zip} \cr
#' GEO files:\cr
#' Note the US file is not bg/tract level:  geo for whole US at once doesn't have tracts and BGs
#' \url{ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/g20111us.csv} \cr\cr
#'
#' OTHER SOURCES include \cr
#' \itemize{
#'   \item \pkg{\link[tidycensus]{tidycensus}} package for R - uses API, requires a key, very useful for modest numbers of Census units rather than every block group in US
#'   \item \pkg{\link[acs]{acs}} package for R - uses API, requires a key, very useful for modest numbers of Census units rather than every block group in US
#'   \item \url{http://www.NHGIS.org} - (and see \code{\link{nhgis}}) very useful for block group (or tract/county/state/US) datasets
#'   \item DataFerrett (\url{http://dataferrett.census.gov/AboutDatasets/ACS.html}) -- not all tracts in US at once
#'   \item American Fact Finder (\url{http://www.census.gov/acs/www/data/data-tables-and-tools/american-factfinder/}) (not block groups for ACS SF, and the tracts are not for the whole US at once)
#'   \item ESRI - commercial
#'   \item Geolytics - commercial
#'   \item etc.
#' }
#' @export
get.acs <-
  function(tables = 'B01001',
           mystates = 'all',
           end.year = acsdefaultendyearhere_func(),
           base.path = getwd(),
           data.path = file.path(base.path, 'acsdata'),
           output.path = file.path(base.path, 'acsoutput'),
           sumlevel = 'both',
           vars = 'all',
           varsfile,
           new.geo = TRUE,
           write.files = FALSE,
           save.files = FALSE,
           write.acspkg = FALSE,
           testing = FALSE,
           noEditOnMac = FALSE,
           silent = FALSE,
           save.log = TRUE,
           filename.log = 'log') {
    ejscreentables <-
      c("B01001", "B03002", "B15002", "B16002", "C17002", "B25034")
    end.year <- as.character(end.year)
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}

    # check if base.path seems to be a valid folder
    if (!file.exists(base.path)) {
      stop(paste('base.path', base.path, 'does not exist'))
    }

    if (!save.log & silent) {
      nocat <- TRUE
    } else {
      nocat <- FALSE
    }
    #  if (!nocat) {cat('\n')}

    starttime <- Sys.time()

    if (!file.exists(output.path)) {
      diroutcome <- try(dir.create(output.path), silent = TRUE)
      if (class(diroutcome) == 'try-error') {
        stop('output.path not found and could not be created\n')
      }
      created.output.path <- TRUE
    } else {
      created.output.path <- FALSE
    }

    # Set up the log file if requested, which also suppresses or does not suppress on screen messages, depending on parameter called silent
    logfullpath <-
      file.path(output.path, paste(filename.log, ' ', gsub(':', '.', Sys.time()), '.txt', sep =
                                     ''))
    if (save.log & !silent) {
      sink(logfullpath, split = TRUE)
      on.exit({
        warning('Exiting')
        sink()
      })
    }
    if (save.log & silent) {
      sink(logfullpath, split = FALSE)
      on.exit({
        warning('Exiting')
        sink()
      })
    }

    if (created.output.path) {
      if (!nocat) {
        cat(as.character(Sys.time()), ' ')
        cat(paste('output.path', output.path, 'not found so it was created\n'))
      }
    }

    if (!file.exists(data.path)) {
      diroutcome <- try(dir.create(data.path), silent = TRUE)
      if (class(diroutcome) == 'try-error') {
        stop('data.path not found and could not be created\n')
      }
      if (!nocat) {
        cat(as.character(Sys.time()), ' ')
        cat(paste('data.path  ', data.path, 'not found so it was created\n'))
      }
    }

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('base.path: ', base.path, '\n')
    }
    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('data.path: ', data.path, '\n')
    }
    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('output.path:', output.path, '\n')
    }
    #if (!nocat) {cat(as.character(Sys.time()), ' '); cat('working directory: ',   getwd(),     '\n')}

    # if tables equals or contains 'ejscreen' then replace the 'ejscreen' part with the default tables as follows, leaving any other tables specified in addition to ejscreen tables:
    if (any(tolower(tables) == 'ejscreen')) {
      tables <- c(ejscreentables, tables[tolower(tables) != 'ejscreen'])
    }
    # note b16001 is tract only and not in core set of EJSCREEN variables
    # or e.g.,   mystates <- c("dc", "de")

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('Tables:   ', tables,   '\n')
      cat(as.character(Sys.time()), ' ')
      cat('End year: ', end.year, '\n')
      cat(as.character(Sys.time()), ' ')
      cat('States:   ', mystates, '\n')
    }

    ##################################################################################### #
    # STEPS:
    #
    #   SPECIFY USER-DEFINED SETTINGS (done previously)
    #
    #  specify where to save files locally
    #	specify years needed (and create URLs of where to obtain zip files, based on years needed & list of State names)
    #	specify variables, tables, sequence file numbers needed
    #
    #   OBTAIN FILES
    #
    #	download txt (or csv) file(s) with GEO information (for linking data file to file with FIPS/GEOID/NAME/SUMLEVEL/CKEY)
    #	read and concatenate state geo files

    #	create names of individual data & moe files extracted from the zip files (based on 2-letter state abbreviations, years needed, and seq file #s)
    #	download zip files with data (estimates and margins of error)
    #	unzip DATA & MOE files

    #	read and concatenate state DATA & MOE files (csv) into one data frame or file per Census table
    #	  while selecting just the desired fields, ideally

    #   MERGE FILES
    #
    #	join (merge) US data and US geo files on FIPS for each Census table
    #	compile all Census tables into one large table
    #	split tracts and block groups into 2 files based on SUMLEVEL code 140 or 150
    #
    #   CREATE CALCULATED VARIABLES (done elsewhere)
    #
    ###################################################### #

    mystates <- clean.mystates(mystates = mystates, testing = testing)

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Started scripts to download and parse ACS data\n")
    }

    ######################################### #
    #  GET URLs and table/variable name lookup
    ######################################### #

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('Started getting URLs, table/variable name lookup table, etc. \n')
    }

    # How we get FTP site URL and file names.
    #   url.prefix <- get.url.prefix(end.year)
    #   url.prefix.lookup.table <- get.url.prefix.lookup.table(end.year)
    #   lookup.file.name  <- get.lookup.file.name(end.year)
    #   datafile.prefix 	<- get.datafile.prefix(end.year)
    #   zipfile.prefix    <- get.zipfile.prefix(end.year)

    if (testing) {
      cat('starting get.lookup.acs\n')
    }
    # Get lookup table of sequence files, table IDs, variable names & positions in the sequence file.

    lookup.acs <- get.lookup.acs(end.year = end.year)

    seqfilelistnums <-
      which.seqfiles(tables = tables,
                     lookup.acs = lookup.acs,
                     end.year = end.year)
    # convert these to four-character-long strings with correct # of leading zeroes (already done when reading lookup csv but ok to repeat):
    seqfilelistnums <- as.character(seqfilelistnums)
    seqfilelistnums <- analyze.stuff::lead.zeroes(seqfilelistnums, 4)
    if (testing) {
      print(cbind(seqfilelistnums))
    }
    # e.g. seqfilelistnums <- c(2, 5, 43, 44, 49, 104)
    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Finished getting URLs, table/variable name lookup table, etc. \n")
    }

    ######################################### #
    #  Check csv to see which fields user needs (may not need every field from every specified table)
    ######################################### #

    ########### ***********************
    #	THIS CURRENTLY DOESN'T WAIT TO
    # CHECK IF THE csv FILE HAS BEEN MODIFIED BY USER TO SPECIFY DESIRED VARIABLES:
    # It just uses all variables in tables
    # unless it finds file "variables needed.csv" in data folder that is based on variables needed template.csv format
    # "needed" will be a data.frame that specifies which variables are needed, from among the specified tables

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Started specifying which variables are needed from the specified ACS tables \n")
    }

    needed <-
      set.needed(
        tables = tables,
        lookup.acs = lookup.acs,
        vars = vars,
        folder = data.path,
        noEditOnMac = noEditOnMac,
        end.year = end.year,
        varsfile = varsfile,
        silent = nocat
      )

    # ensure leading zeroes on sequence file number
    needed$seq <- analyze.stuff::lead.zeroes(needed$seq, 4)
    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Finished specifying which variables are needed from the specified ACS tables \n")
    }

    geo <-
      get.read.geo(
        mystates = mystates,
        new.geo = new.geo,
        end.year = end.year,
        folder = data.path,
        silent = nocat
      )

    ################################################################# #
    #  Call functions to
    #  download and unzip specified set of
    #  ACS DATA TABLES
    ################################################################# #

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Started downloading data files \n")
      # if they have already been downloaded, this will not try to re-download them
    }

    download.datafiles(
      tables = tables,
      end.year = end.year,
      mystates = mystates,
      folder = data.path,
      testing = testing,
      silent = nocat
    )

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Finished downloading data files \n")
      cat(as.character(Sys.time()), ' ')
      cat("Started unzipping data files \n")
    }

    unzip.datafiles(
      tables = tables,
      mystates = mystates,
      folder = data.path,
      end.year = end.year,
      testing = testing,
      silent = nocat
    )

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Finished unzipping data files \n")
    }

    ######################################################################################################## #
    #  **** ERRORS MAY STILL OCCUR HERE  ****#  **** ERRORS MAY STILL OCCUR HERE  ****
    # Having memory problems in Windows when trying to get several tables for all US states/DC/PR at once all in memory.
    ######################################################################################################## #
    if (testing) {
      # Test smaller set:
      tables <- c("B03002", "B15002", "B25034")
    }
    # NOTE : IF ONLY TRACTS ARE NEEDED, *** IT WOULD BE MORE EFFICIENT TO
    # JOIN DATA TO GEO FOR EACH STATE AND/OR TABLE,
    # THEN DROP THE BLOCK GROUP ROWS,
    # PRIOR TO MERGING ALL THE ROWS IN ONE BIG TABLE HERE.
    # BUT CURRENTLY THIS ASSEMBLES ALL EVEN IF YOU ONLY NEED TRACTS, OR JUST BG.

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Started reading/assembling all data files \n")
    }

    # *** NOTE - Inefficient to pass entire geo table here! Just need count of rows per state to help read in data tables from csv files
    # Could recode to *** make this and read.concat.states() more efficient:
    alltab <-
      read.concat.states(
        tables = tables,
        mystates = mystates,
        geo = geo,
        save.files = save.files,
        folder = data.path,
        output.path = output.path,
        end.year = end.year,
        needed = needed,
        sumlevel = sumlevel,
        testing = testing,
        silent = nocat
      )

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Finished reading data \n")
    }

    ######################################################################################################## #
    ######################################################################################################## #

    if (testing) {
      if (save.files) {
        #  USED TO SAVE THE FULL SET OF TABLES JUST IN CASE:
        save(alltab, file = file.path(output.path, "alltab no geo.RData"))
        cat(as.character(Sys.time()), ' ')
        cat('Finished saving RData \n')
        gc()
      }
      # could look at what is in alltab so far
      lapply(alltab, FUN = names)
      #  e.g.:		# $B01001
      #  [1] "KEY"          "STUSAB"       "LOGRECNO"     "B01001.001"   "B01001.003"   "B01001.020"   "B01001.021"   "B01001.022"
      head(alltab[[1]])
    }	# end testing

    ######################################################################################################## #

    ############################ #
    # JOIN GEO INFO TO TABLES
    ############################ #

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat("Started joining geo to data tables \n")
    }

    alltab <-
      join.geo.to.tablist(
        geo,
        alltab,
        folder = output.path,
        save.csv = write.files,
        sumlevel = sumlevel,
        end.year = end.year
      )

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('Finished joining geo to data tables \n')
      cat(as.character(Sys.time()), ' ')
      cat('Checked block groups and tracts, retained ')
      cat(sumlevel)
      cat('\n')
    }

    gc()
    if (testing) {
      if (save.files) {
        #  COULD SAVE THE FULL SET OF TABLES JUST IN CASE:
        save(alltab, file = file.path(output.path, "alltab with geo.RData"))
        cat(as.character(Sys.time()), ' ')
        cat("Saved alltab with geo\n")
      }
    }

    ############################ #
    # REORDER THE COLUMNS,   # E.G., MARGIN OF ERROR COLUMNS INTERSPERSED WITH ESTIMATES DATA COLUMNS
    ############################ #

    alltab <- format.est.moe(alltab)

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('Re-ordered estimates and margin of error columns \n')
    }
    if (testing) {
      # lapply(alltab, FUN=names)
      if (save.files) {
        #  USED TO SAVE THE FULL SET OF TABLES JUST IN CASE:
        save(alltab,
             file = file.path(output.path, "alltab with geo est-moe.RData"))
        cat(as.character(Sys.time()), ' ')
        cat("Saved alltab with geo and est-moe \n")
      }
    }
    ############################ #
    # MERGE the list of tables into one big table
    ############################ #
    #Error: cannot allocate vector of size 2.2 Mb - on Windows this was a problem

    merged <- merge.tables(alltab)

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('Merged all tables into one big table \n')
    }

    if (testing) {
      if (save.files) {
        #  CAN SAVE THE FULL SET OF TABLES HERE, IN CASE -- block groups and tracts as well:
        save(merged, file = file.path(output.path, "merged tables.RData"))
        cat(as.character(Sys.time()), ' ')
        cat("Saved merged tables \n")
      }
    }

    ##################################### #
    #  SPLIT into a BLOCK GROUPS dataset & a TRACTS dataset
    ##################################### #

    tracts <- get.tracts(merged)
    bg     <- get.bg(merged)

    rm(merged)

    if (!nocat) {
      cat(as.character(Sys.time()), ' ')
      cat('Split data into block groups dataset and tracts dataset \n \n')
      cat(as.character(Sys.time()), ' ')
      cat("Tracts count:       ")
      cat(length(tracts$FIPS))
      cat(" ")
      cat('(', length(unique(tracts$FIPS)), 'unique FIPS)')
      cat(" \n")
      cat(as.character(Sys.time()), ' ')
      cat("Block groups count: ")
      cat(length(bg$FIPS))
      cat(" ")
      cat('(', length(unique(bg$FIPS)), 'unique FIPS)')
      cat(" \n")
    }

    # REMOVE TABLE B16001 from block group dataset because it is at tract level only
    # table(is.na((alltab[[4]][ , "B16001.001"])))
    # This table has tract but not BG data:
    # FALSE   TRUE
    # 74001 220333
    bg <- bg[, !(grepl("B16001", names(bg)))]

    # Drop now-useless field SUMLEVEL
    bg$SUMLEVEL <- NULL
    tracts$SUMLEVEL <- NULL
    #print(head(tracts))

    if (testing) {
      if (save.files) {
        save.image(file = file.path(output.path, 'ACS all but table.info step done.RData'))
      }
    }

    ####################################################### #
    # GET TABLE TITLE, UNIVERSE, AND LONG VARIABLE NAMES
    ####################################################### #

    # This is Just one entry per variable in estimates table, not for MOE, not basic info cols like "FIPS"
    table.info <-
      get.table.info(tables, end.year, table.info.only = FALSE)
    # NOTE: THIS HAS ALL VARIABLES, NOT JUST needed, so we want to remove any not needed so it matches retained data fields.
    table.info <- table.info[table.info$shortname %in% names(bg),]
    rownames(table.info) <- table.info$shortname

    # This is All the entries like MOE and basic info (FIPS) so it can serve as header rows to final output table
    table.info.all <- table.info

    # make the MOE versions of the estimates columns,
    # then intersperse with estimates, to match full list of longnames
    table.info.all.m <-
      get.table.info(tables,
                     end.year,
                     table.info.only = FALSE,
                     moe = TRUE)
    # NOTE: THIS HAS ALL VARIABLES, NOT JUST needed, so we want to remove any not needed so it matches retained data fields.
    table.info.all.m <-
      table.info.all.m[table.info.all.m$shortname %in% paste(names(bg), '.m', sep =
                                                               '') ,]
    rownames(table.info.all.m) <- table.info.all.m$shortname

    # append MOE names and then reorder these rows so that estimate and MOE are adjacent for each variable:
    table.info.all <- rbind(table.info.all, table.info.all.m)
    table.info.all <-
      table.info.all[analyze.stuff::intersperse(1:length(table.info.all[, 1])),]

    # Now add the basic info columns up front to match full list of longnames
    #otherfields <- c('KEY', 'STUSAB', 'SUMLEVEL', 'GEOID', 'FIPS') # SUMLEVEL was dropped from bg and tracts
    otherfields <- c("KEY", "FIPS", "STUSAB", "GEOID")
    rows.to.add <- data.frame(
      table.ID = otherfields,
      line = 0,
      shortname = otherfields,
      longname = otherfields,
      table.title = 0,
      universe = 0,
      subject = 0,
      longname2 = otherfields,
      longname.unique = otherfields,
      stringsAsFactors = FALSE
    )
    table.info.all <- rbind(rows.to.add, table.info.all)

    ############################################################################################################### #

    ################################ #
    #  maybe save on disk final merged results as tracts and block groups files
    ################################ #

    if (save.files) {
      save(bg,     file = file.path(output.path, "bg all tables.RData"))
      save(tracts, file = file.path(output.path, "tracts all tables.RData"))
      # a waste of space to create headers and info here but nice to save with those names and usually not much memory for this
      headers = table.info.all
      save(headers, file = file.path(output.path, 'headers.RData'))
      rm(headers)
      info = table.info
      save(info, file = file.path(output.path, 'info.RData'))
      rm(info)
      #save()
      if (!nocat) {
        cat(as.character(Sys.time()), ' ')
        cat('Saved block group file and tracts file as .RData \n')
      }
    }

    if (testing) {
      # These are big so probably do not want them even if write.files=TRUE since they can be saved as .RData and are returned by function get.acs() already
      if (write.files) {
        write.csv(bg,
                  file = file.path(output.path, "bg all tables.csv"),
                  row.names = FALSE)
        write.csv(
          tracts,
          file = file.path(output.path, "tracts all tables.csv"),
          row.names = FALSE
        )
        cat(as.character(Sys.time()), ' ')
        cat('Saved block group file and tracts file as .csv ')
      }
    }

    if (write.files) {
      # *** NOTE THIS HAD BEEN SAVING JUST ONE NAME PER DATA FIELD, NOT ONCE FOR ESTIMATES AND ONCE FOR MOE.
      # AND  NOT  FIELD NAMES FOR OTHER FIELDS "KEY"          "FIPS"         "STUSAB"       "GEOID"
      # SO DID NOT CORRESPOND TO names(bg)
      write.csv(table.info,
                file = file.path(output.path, 'info.csv'),
                row.names = FALSE)
      write.csv(
        table.info.all,
        file = file.path(output.path, 'headers.csv'),
        row.names = FALSE
      )
      if (!nocat) {
        cat(as.character(Sys.time()), ' ')
        cat('Saved longnames, etc fieldnames as csv file. \n')
      }
    }

    ####################################################### #
    if (!nocat) {
      cat(as.character(Sys.time()), '\n')
      cat("################ DONE ############## \n")
    }

    # Format for acs package here:
    #print(names(alltab))
    #print(str(alltab))
    if (write.acspkg) {
      if (!nocat) {
        cat(as.character(Sys.time()), ' ')
        cat('Started to save tables as files formatted for use in the acs package \n')
      }
      for (this.tab in names(alltab)) {
        if (!nocat) {
          cat('      ', this.tab, '\n')
        }
        acs.this.tab <- format.for.acs.package(alltab[[this.tab]])
        #         head( format.for.acs.package( alltab[[2]]) )
        filename.tracts <-
          paste("ACS_",
                substr(end.year, 3, 4),
                "_5YR_",
                this.tab,
                "_with_ann.csv",
                sep = "")
        filename.bg     <-
          paste("ACS_",
                substr(end.year, 3, 4),
                "_5YR_",
                this.tab,
                "_with_ann_BG.csv",
                sep = "")
        write.csv(acs.this.tab[acs.this.tab$SUMLEVEL == "140"], row.names =
                    FALSE, file = filename.tracts)
        write.csv(acs.this.tab[acs.this.tab$SUMLEVEL == "150"], row.names =
                    FALSE, file = filename.bg)
        if (!nocat) {
          cat(as.character(Sys.time()), ' ')
          cat('Saved tracts files formatted for use in the acs package \n')
        }
      }
    }

    # Return block group or tracts file (or both) as list, along with table.info.best which has fieldnames etc.
    sumlevel <- clean.sumlevel(sumlevel)

    if (!nocat) {
      print(round(Sys.time() - starttime, 0))
      cat('\n')
    }

    if (sumlevel == 'tract') {
      return(list(
        tracts = tracts,
        headers = table.info.all,
        info = table.info
      ))
    } else {
      if (sumlevel == 'both') {
        return(list(
          bg = bg,
          tracts = tracts,
          headers = table.info.all,
          info = table.info
        ))
      } else {
        # can assume it is bg since check.sumlevel stops with error if not one of these three
        return(list(
          bg = bg,
          headers = table.info.all,
          info = table.info
        ))
      }
    }

  }
