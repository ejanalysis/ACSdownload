#' @title Download Tables from American Community Survey (ACS) 5-year Summary File
#'
#' @description
#'   This function will download and parse 1 or more tables of data from the American Community Survey's
#'   5-year Summary File FTP site, for all Census tracts and/or block groups in specified State(s).
#'   Estimates and margins of error are obtained, as well as long and short names for the variables,
#'   which can be specified if only parts of a table are needed.
#' 
#' @details
#'   The United States Census Bureau provides detailed demographic data by US Census tract and block group
#'   in the American Community Survey (ACS) 5-year summary file via their FTP site. For those interested in block group or tract data,
#'   Census Bureau tools tend to focus on obtaining data one state at a time rather than for the entire US at once.
#'   The \code{get.acs} function lets a user specify (tables and) variables needed. The code will look up what sequence files
#'   contain those tables. Using a table of variables for those selected tables, a user can specify variables
#'   or tables to drop by putting x or anything other than "Y" in the column specifying needed variables.
#'   \cr\cr
#'   For ACS documentation, see for example:\cr\cr
#' \url{http://www.census.gov/programs-surveys/acs.html} \cr
#' or\cr
#' \url{http://www.census.gov/acs/www/Downloads/data_documentation/SumFileTemp/2012-5-Year/Sequence_Number_and_Table_Number_Lookup.xls}\cr
#' linked from\cr
#' \url{http://www.census.gov/programs-surveys/acs/data/summary-file.html}\cr
#' \cr\cr
#' #####################################	ADDITIONAL NOTES ######################################\cr
#' 	NOTES ON NON-NUMERIC FIELDS IN ESTIMATE AND MOE FILES:\cr
#' \cr
#' FROM 2008-2012 ACS 5-Year Summary File Technical Documentation:\cr
#' \cr
#' Some data values represent unique situations where either the information to be conveyed is
#' an explanation for the absence of data, represented by a #symbol in the data display, such as "(X)",
#' or the information to be conveyed is an open-ended distribution, such as 115 or greater, represented by 115+.
#' The following special data values can appear in the ACS Summary File table as an explanation for the absence of data:\cr
#' 2008-2012 ACS 5-Year Summary File Technical Documentation\cr
#' \cr
#' ? Missing Value = ??    **********\cr
#' A missing string indicates that the estimate is unavailable. (This appears in the estimates and margins or error
#' files as two commas adjacent to each #other without anything between them, or if the last cell in a data file is
#' filtered then you get a comma followed immediately by a carriage return or #EOF.)
#' A missing value indicates when an estimate is missing because of filtering for geographic restrictions,
#' coefficients of variations (CV), or was #removed due to the Disclosure Review Board?s (DRB) requirements.
#' For more detail on filtering, please see Appendix C.5.\cr
#' \cr
#' ? Dot = ?.?		********\cr
#' A dot indicates when the estimate has no sample observations or too few sample observations.
#' In the margin of error files, this value could also indicate #that the margin of error is unavailable for
#' a median estimate that has been replaced with a jam value.\cr
#' \cr
#' ? Zero = ?0?\cr
#' A ?0? entry in the margin of error column indicates that the estimate is controlled.
#' A statistical test for sampling variability is not appropriate.
#' This #is similar to the ?*****? symbol used in American FactFinder.\cr
#' \cr
#' ? Negative 1 = ?-1?\cr
#' This indicates that an estimate does not contain a Margin of Error.
#' Tables B00001, B00002, and tables starting with B98 and B99 do not have margin of #error (MOE)
#' associated with them. The MOE calculations are set to -1 for these tables.\cr
#' \cr
#' ? Jam Values for Medians\cr
#' The following is a listing of the jam values for medians. For example, if there is an estimate of "2499"
#' for table B10010, then it does not indicate a #dollar amount. It means that the median is somewhere
#' below 2,500 and thus isn't calculated. \cr
#' \cr
#'  \cr
#' "Jam Value","Actual Meaning","Use for Medians" \cr
#' "0","1 or less","Age, Duration of Marriage" \cr
#' "9","9.0 or more","Rooms" \cr
#' "10","10.0 or less","Gross Rent as Percentage of Income, Owner Costs as Percentage of Income" \cr
#' "50","50.0 or more","Gross Rent as Percentage of Income, Owner Costs as Percentage of Income" \cr
#' "99","100 or less","Rent, Gross Rent, Selected Monthly Owner Costs, Monthly Housing Costs" \cr
#' "101","101 or more","Duration of Marriage" \cr
#' "116","115 or more","Age" \cr
#' "199","200 or less","Tax" \cr
#' "1001","1,000 or more","Selected Monthly Owner Costs" \cr
#' "1939","1939 or earlier","Year Built" \cr
#' "1969","1969 or earlier","Year Moved In" \cr
#' "2001","2,000 or more","Rent, Gross Rent" \cr
#' "2005","2005 or later","Year Built, Year Moved In" \cr
#' "2499","2,500 or less","Income, Earnings" \cr
#' "4001","4,000 or more","Selected Monthly Owner Costs, Monthly Housing Costs" \cr
#' "9999","10,000 or less","Value" \cr
#' "10001","10,000 or more","Tax" \cr
#' "200001","200,000 or more","Income" \cr
#' "250001","250,000 or more","Income, Earnings" \cr
#' "1000001","1,000,000 or more","Value" \cr
#'  ############################################### \cr
#'  \cr
#'    in older 2005-2009 and 2005-2010 also these were the sequence numbers, but they change over time: \cr
#' seqnum <- "0010" has ageunder5m = B01001.003 etc. \cr
#' seqnum <- "0013" has hisp = B03002.012 etc. \cr
#' seqnum <- "0040" has age25up = B15002.001 etc. \cr
#' seqnum <- "0042" has lingisospanish = B16002.004 etc. \cr
#' seqnum <- "0046" has povknownratio = C17002.001 etc. \cr
#' NOTE:  seq file 98 was used for year built in ACS 2005-2009 but in ACS 2006-2010 that is in seq file 97 \cr
#' ############# \cr
#'  \cr
#' #####################################################################################  \cr
#'	NOTES on where to obtain ACS data - sources for downloads of summary file data  \cr
#' ##################################################################################### \cr
#'  \cr \cr
#' FOR ACS SUMMARY FILE DOCUMENTATION, SEE \cr
#' \url{http://www.census.gov/acs/www/data_documentation/summary_file/} \cr
#' \cr
#' 	As of 12/2012, ACS block group/tract summary file ESTIMATES on FTP site is provided as either \cr
#' \cr
#'  LARGER THAN NECESSARY: \cr
#' \cr
#'	*** all states and all tables in one huge tar.gz file (plus a zip of all geography codes), \cr
#'	\url{ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)} \cr
#'	\url{ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)/2011_ACS_Geography_Files.zip} \cr
#'	2011_ACS_Geography_Files.zip		# \cr
#'	Tracts_Block_Groups_Only.tar.gz		# (THIS HAS ALL THE SEQUENCE FILES FOR EACH STATE IN ONE HUGE ZIP FOLDER) \cr
#' \cr
#' or \cr
#' \cr
#'  MORE FOCUSED DOWNLOADS: \cr
#' \cr
#'	*** one zip file per sequence file PER STATE:    (plus csv of geography codes) \cr
#' \cr
#'	\url{http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/} \cr
#'         20115dc0002000.zip (Which has the e file and m file for this sequence file in this state) \cr
#'         g20115dc.csv  (which lets you link FIPS to data) \cr
#'	so this would mean 50+ * about 7 sequence files? = about 350 zip files?? each with 2 text files. Plus 50+ geo csv files.
#'	so downloading about 400 files and expanding to about 750 files, and joining into one big file.
#' \cr
#' OR \cr
#' \cr
#'  PREJOINED TO TIGER BLOCK GROUP BOUNDARIES SHAPEFILES/ GEODATABASES - \cr
#'	ONE PER STATE HAS SEVERAL TABLES BUT NOT B16001, B16002 (many languages but tracts only), B16004 (has block groups but fewer languages) \cr
#'	\url{http://www.census.gov/geo/maps-data/data/tiger-data.html} \cr
#' \cr
#'  BUT NOT one file per sequence file FOR ALL STATES AT ONCE. \cr
#' \cr
#' Estimates & margin of error (MOE), (ONCE UNZIPPED), and GEOgraphies (not zipped) are in 3 separate files. \cr
#' \cr
#' also, data for entire US for one seq file at a time, but not tract/bg -- just county and larger? -- is here, e.g.:
#' \url{ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/20111us0001000.zip}
#' \cr
#' GEO files:\cr
#' \cr
#' Note the US file is not bg/tract level:  geo for whole US at once doesn't have tracts and BGs
#' \url{ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/g20111us.csv}
#' \cr\cr
#' OTHER SOURCES include \cr
#' \itemize{
#'   \item \pkg{acs} package for R - very useful for modest numbers of Census units rather than every block group in US
#'   \item \url{NHGIS.org} - very useful for block group (or tract/county/state/US) datasets
#'   \item DataFerrett (\url{http://dataferrett.census.gov/AboutDatasets/ACS.html}) -- not all tracts in US at once
#'   \item American Fact Finder (\url{http://www.census.gov/acs/www/data/data-tables-and-tools/american-factfinder/}) (not block groups for ACS SF, and the tracts are not for the whole US at once)
#'   \item ESRI - commercial
#'   \item Geolytics - commercial
#'   \item etc.
#' }
#'
#' @param tables Character vector, optional. Defines tables to obtain, such as 'B01001' (the default).
#'   If the user specifies a table called 'ejscreen' then a set of tables used by that tool are included.
#'   Those tables are "B01001", "B03002", "B15002", "B16002", "C17002", "B25034"
#' @param base.path Character, optional, getwd() by default. Defines a base folder to start from, in case
#'   data.path and/or output.path are not specified, in which case a subfolder under base.path,
#'   called acsdata or acsoutput respectively, will be created and used for downloads or outputs of the function.
#' @param data.path Character, optional, file.path(base.path, 'acsdata') by default.
#'   Defines folder (created if does not exist) where downloaded files will be stored.
#' @param output.path Character, optional, file.path(base.path, 'acsoutput') by default.
#'   Defines folder (created if does not exist) where output files (results of this function) will be stored.
#' @param end.year Character, optional, '2012' by default. Defines a valid ending year of a 5-year summary file.
#'   Can be '2010' for example. Not all years are tested.
#' @param mystates Character vector, optional, 'all' by default which means all available states
#'   plus DC and PR but not VI etc. Defines which States to include in downloads of data tables.
#' @param summarylevel Default is "both" in which case tracts and block groups are returned,
#'   but if "tract" specified, just tracts are returned,
#'   and if summarylevel is anything else, just block groups are returned.
#' @param askneeded Optional logical, default is TRUE, specifies whether to pause and
#'   ask user about which variables are needed in an interactive session.
#'   If FALSE, it just looks (in \code{folder}) for file called "variables needed.csv" that should specify which variables to keep from each table.
#'   The format of that file should be the same as is found in the file "variables needed template.csv" created by this function.
#'   If the "variables needed.csv" file is not found, it looks for and uses the file called "variables needed template.csv"
#'   which is written by this function and specifies all of the variables from each table.
#' @param new.geo Default is TRUE. If FALSE, just uses existing downloaded geo file if possible. If TRUE, forced to download geo file even if already done previously.
#' @param writefiles Default is FALSE, but if TRUE then data-related csv files are saved locally -- Saves longnames, full fieldnames as csv file, in working directory.
#' @param save.files Default is FALSE, but if TRUE then various intermediate image files are saved as .RData files locally in working directory.
#' @param testing Default is FALSE, but if TRUE more information is shown on progress, using cat() and while downloading, and more files (csv) are saved in working directory.
#'
#' @return By default, returns a list with datatables and information about them, with three elements in the list: \cr
#'   bg, tracts, and info. The info element is a table of metadata such as short and long field names: \cr\cr
#'   'data.frame':	xxxx obs. of  9 variables:  \cr
#'  $ table.ID       : chr  "B01001" "B01001" "B01001" "B01001" ...  \cr
#'  $ line           : num  1 2 3 4 5 6 7 8 9 10 ...  \cr
#'  $ shortname      : chr  "B01001.001" "B01001.002" "B01001.003" "B01001.004" ...  \cr
#'  $ longname       : chr  "Total:" "Male:" "Under 5 years" "5 to 9 years" ...  \cr
#'  $ table.title    : chr  "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" ...  \cr
#'  $ universe       : chr  "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" ...  \cr
#'  $ subject        : chr  "Age-Sex" "Age-Sex" "Age-Sex" "Age-Sex" ...  \cr
#'  $ longname2      : chr  "Total" "Male" "Under5years" "5to9years" ...  \cr
#'  $ longname.unique: chr  "Total:|SEX BY AGE" "Male:|SEX BY AGE" "Under 5 years|SEX BY AGE" "5 to 9 years|SEX BY AGE" ...  \cr
#' @seealso \pkg{acs} package which allows you to download and work with ACS data (using the API and your own key).
#' @examples
#'  \dontrun{
#'   out <- get.acs(mystates=c('dc','de')) # Just DC & DE, just the default table.
#'   head(out$info); head(out$bg)
#'   out <- get.acs(mystates='de', tables=c('B01001', 'C17002'))  # just 2 tables for just Delaware
#'   head(out$info); head(out$bg)
#'   out <- get.acs(base.path='~', data.path='~/ACS/temp', output.path='~/ACS/results') # uses all EJSCREEN defaults and the specified folders
#'   head(out$info); head(out$bg)
#'   out <- get.acs(tables=c('ejscreen', 'B16001')) # all tables needed for EJSCREEN, plus 'B16001', with variables specified in 'variables needed.csv', all states&DC &PR?
#'   head(out$info); head(out$bg)
#'  }
#' @export
get.acs <- function(tables='B01001', base.path=getwd(), data.path=file.path(base.path, 'acsdata'), output.path=file.path(base.path, 'acsoutput'),
                    end.year='2012', mystates='all', summarylevel='both', askneeded=FALSE,
                    new.geo=TRUE, writefiles=FALSE, save.files=FALSE, testing=FALSE) {

  ejscreentables <- c("B01001", "B03002", "B15002", "B16002", "C17002", "B25034")

  # require(analyze.stuff)

  # check if base.path seems to be a valid folder
  if (!file.exists(base.path)) {stop(paste('base.path', base.path, 'does not exist'))}

  if (!file.exists(output.path)) {
    diroutcome <- try( dir.create(output.path), silent = TRUE)
    if (class(diroutcome) == 'try-error') { stop('output.path not found and could not be created')}
    cat(paste('output.path', output.path, 'not found so it was created'))
  }

  if (!file.exists(data.path)) {
    diroutcome <- try( dir.create(data.path), silent = TRUE)
    if (class(diroutcome) == 'try-error') { stop('data.path not found and could not be created')}
    cat(paste('data.path', data.path, 'not found so it was created'))
  }

  if (testing) {
    cat(  'base.path: ', base.path, '\n')
    cat(  'data.path: ', data.path, '\n')
    cat('output.path', output.path, '\n')
    cat('getwd(): ',   getwd(),     '\n')
  }

  # if tables equals or contains 'ejscreen' then replace the 'ejscreen' part with the default tables as follows, leaving any other tables specified in addition to ejscreen tables:
  if (any(tolower(tables)=='ejscreen')) {tables <- c(ejscreentables, tables[tolower(tables)!='ejscreen'])}
  # note b16001 is tract only and not in core set of EJSCREEN variables
  # or e.g.,   mystates <- c("dc", "de")

  ######################################################################################
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
  #######################################################

  #require(proxistat)
  data(lookup.states, envir = environment(), package='proxistat')
  stateabbs	<- tolower(lookup.states[, 'ST'])
  # or could use
  #   stateabbs <- tolower(c(state.abb, c("DC", "AS", "GU", "MP", "PR", "UM", "VI", "US")))
  # but other functions in this pkg require lookup.states anyway, and not just abbs
  mystates <- clean.mystates(mystates=mystates, testing=testing)

  cat(as.character(Sys.time()), ' '); cat("Started scripts to download and parse ACS data\n")
  cat('data.path is now set to '); cat(data.path, '\n')
  # setwd(data.path)

  ##########################################
  #  GET URLs and table/variable name lookup
  ##########################################

  cat(as.character(Sys.time()), ' '); cat('Started getting URLs, table/variable name lookup table, etc. \n')

  # How we get FTP site URL and file names.
  #   url.prefix <- get.url.prefix(end.year)
  #   url.prefix.lookup.table <- get.url.prefix.lookup.table(end.year)
  #   lookup.file.name  <- get.lookup.file.name(end.year)
  #   datafile.prefix 	<- get.datafile.prefix(end.year)
  #   zipfile.prefix    <- get.zipfile.prefix(end.year)

  if (testing) {cat('starting get.lookup.acs\n')}
  # Get lookup table of sequence files, table IDs, variable names & positions in the sequence file.

  ######## MAY CHANGE THIS TO DATA?? but varies by year ** also see acs.lookup in acs package as an alternative
  lookup.acs <- get.lookup.acs(end.year)

  seqfilelistnums <- which.seqfiles(tables=tables, lookup.acs=lookup.acs)
  # convert these to four-character-long strings with correct # of leading zeroes (already done when reading lookup csv but ok to repeat):
  seqfilelistnums <- as.character(seqfilelistnums)
  seqfilelistnums <- analyze.stuff::lead.zeroes(seqfilelistnums, 4)
  if (testing) { print(cbind(seqfilelistnums)) }
  # e.g. seqfilelistnums <- c(2, 5, 43, 44, 49, 104)
  cat(as.character(Sys.time()), ' '); cat("Finished getting URLs, table/variable name lookup table, etc. \n")

  ##########################################
  #  Check csv to see which fields user needs (may not need every field from every specified table)
  ##########################################

  ########### ***********************
  #	THIS CURRENTLY DOESN'T WAIT TO
  # CHECK IF THE csv FILE HAS BEEN MODIFIED BY USER TO SPECIFY DESIRED VARIABLES:
  # It just uses all variables in tables
  # unless it finds file "variables needed.csv" in data folder that is based on variables needed template.csv format
  # "needed" will be a dataframe that specifies which variables are needed, from among the specified tables

  cat(as.character(Sys.time()), ' '); cat("Started specifying which variables are needed from the specified ACS tables \n")
  needed <- set.needed(tables=tables, lookup.acs=lookup.acs, askneeded=askneeded, folder=data.path) # requires "lookup.acs" be in memory, which was done a few lines ago, & a few other variables *****
  # ensure leading zeroes on sequence file number
  needed$seq <- analyze.stuff::lead.zeroes(needed$seq, 4)
  cat(as.character(Sys.time()), ' '); cat("Finished specifying which variables are needed from the specified ACS tables \n")

  geo <- get.read.geo(mystates=mystates, new.geo=new.geo, end.year=end.year, folder=data.path)

  ##################################################################
  #
  #  Call functions to
  #  download and unzip specified set of
  #  ACS DATA TABLES
  #
  ##################################################################

  cat(as.character(Sys.time()), ' '); cat("Started downloading data files... \n")
  # if they have already been downloaded, this will not try to re-download them:
  cat('  Tables: ', tables, '\n  End year: ', end.year, '\n  States: ', mystates, '\n')

  download.datafiles(tables=tables, end.year=end.year, mystates=mystates, folder=data.path, testing=testing)

  cat('\n', as.character(Sys.time()), ' '); cat("Finished downloading data files... \n")
  cat(as.character(Sys.time()), ' '); cat("Started unzipping data files... \n")

  unzip.datafiles(tables=tables, mystates=mystates, folder=data.path, end.year=end.year, testing=testing)

  cat(as.character(Sys.time()), ' '); cat("Finished unzipping data files... \n")

  #########################################################################################################
  #  **** ERRORS MAY STILL OCCUR HERE  ****#  **** ERRORS MAY STILL OCCUR HERE  ****
  # Having memory problems in Windows when trying to get several tables for all US states/DC/PR at once all in memory.
  #########################################################################################################
  if (testing) {
    # Test smaller set:
    tables <- c("B03002", "B15002", "B25034")
  }
  ################################################################
  # NOTE : IF ONLY TRACTS ARE NEEDED, IT WOULD BE MORE EFFICIENT TO
  # JOIN DATA TO GEO FOR EACH STATE AND/OR TABLE,
  # THEN DROP THE BLOCK GROUP ROWS,
  # PRIOR TO MERGING ALL THE ROWS IN ONE BIG TABLE HERE.
  # BUT CURRENTLY THIS ASSEMBLES ALL EVEN IF YOU ONLY NEED TRACTS, OR JUST BG.

  cat(as.character(Sys.time()), ' '); cat("Started reading/assembling all data files... \n")

  # NOTE - Inefficient to pass entire geo table here! Just need count of rows per state to help read in data tables from csv files...
  # Could recode to *** make this and read.concat.states() more efficient:
  alltab <- read.concat.states(tables, mystates, geo=geo, save.files=save.files, folder=data.path, end.year=end.year, needed=needed, sumlevel=summarylevel, testing=testing)

  cat(as.character(Sys.time()), ' '); cat("Finished reading data \n")

  # There should be this many unique tables here: # length(alltab)
  #########################################################################################################

  if (save.files) {
    # ******* SAVE WORKSPACE JUST IN CASE, WHILE IN DEVELOPMENT ********************
    save.image(file='ACS EARLY work in progress.RData')
  }

  #########################################################################################################

  if (testing) {
    if (save.files) {
      #  USED TO SAVE THE FULL SET OF TABLES JUST IN CASE:
      save(alltab, file="alltab no geo.RData");  cat(as.character(Sys.time()), ' '); cat('Finished saving RData \n')
      gc()
    }
  }
  # could look at what is in alltab so far
  if (testing) {
    lapply(alltab, FUN=names)
    #  e.g.:		# $B01001
    #  [1] "KEY"          "STUSAB"       "LOGRECNO"     "B01001.001"   "B01001.003"   "B01001.020"   "B01001.021"   "B01001.022"
    head(alltab[[1]])
  }	# end testing

  #########################################################################################################

  #############################
  # JOIN GEO INFO TO TABLES
  #############################

  cat(as.character(Sys.time()), ' '); cat("Started joining geo to data tables \n")

  alltab <- join.geo.to.tablist(geo, alltab, folder=folder, save=writefiles, sumlevel=summarylevel)

  cat(as.character(Sys.time()), ' '); cat('Finished joining geo to data tables \n')
  cat(as.character(Sys.time()), ' '); cat('Checked block groups and tracts, retained ');cat(summarylevel); cat('\n')

  gc()
  if (testing) {
    if (save.files) {
      #  USED TO SAVE THE FULL SET OF TABLES JUST IN CASE:
      save(alltab, file="alltab with geo.RData")
      cat(as.character(Sys.time()), ' '); cat("Saved alltab with geo\n")
    }
  }

  #############################
  # REORDER THE COLUMNS,   # E.G., MARGIN OF ERROR COLUMNS INTERSPERSED WITH ESTIMATES DATA COLUMNS
  #############################

  alltab <- format.est.moe(alltab)

  cat(as.character(Sys.time()), ' '); cat('Re-ordered estimates and margin of error columns \n')
  if (testing) {
    # lapply(alltab, FUN=names)
    if (save.files) {
      #  USED TO SAVE THE FULL SET OF TABLES JUST IN CASE:
      save(alltab, file="alltab with geo est-moe.RData")
      cat(as.character(Sys.time()), ' '); cat("Saved alltab with geo and est-moe \n")
    }
  }
  #############################
  # MERGE the list of tables into one big table
  #############################
  #Error: cannot allocate vector of size 2.2 Mb

  merged <- merge.tables(alltab)

  cat(as.character(Sys.time()), ' '); cat('Merged all tables into one big table \n')

  #if (testing) {
  if (save.files) {
    ######################################
    #  DO SAVE THE FULL SET OF TABLES HERE, IN CASE -- block groups and tracts as well:
    ######################################
    save(merged, file="merged tables.RData")
    cat(as.character(Sys.time()), ' '); cat("Saved merged tables \n")
  }
  #}

  ######################################
  #  SPLIT into a BLOCK GROUPS dataset & a TRACTS dataset
  ######################################

  tracts <- get.tracts(merged)
  bg     <- get.bg(merged)

  rm(merged)

  cat(as.character(Sys.time()), ' '); cat('Split data into block groups dataset and tracts dataset \n')
  cat("TRACTS count: "); cat(length(tracts$FIPS)); cat(" "); cat(length(unique(tracts$FIPS))); cat("\n")
  cat("BLOCK GROUPS count: "); cat(length(bg$FIPS)); cat(" "); cat(length(unique(bg$FIPS))); cat("\n")

  ######################################
  # REMOVE TABLE B16001 from block group dataset because it is at tract level only
  ######################################
  # table(is.na((alltab[[4]][ , "B16001.001"])))
  # This table has tract but not BG data:
  # FALSE   TRUE
  # 74001 220333

  bg <- bg[ , !(grepl("B16001", names(bg)))]

  # Drop now-useless field SUMLEVEL
  bg$SUMLEVEL <- NULL
  tracts$SUMLEVEL <- NULL
  #print(head(tracts))

  if (save.files) {save.image(file='ACS all but table.info step done.RData')}

  ########################################################
  # GET TABLE TITLE, UNIVERSE, AND LONG VARIABLE NAMES
  ########################################################

  table.info <- get.table.info2(tables, end.year, table.info.only=FALSE)

  table.info.best <- table.info  # instead of obsolete section below

  # Can get longnames for all the variables from any of these tables, (not just selected vars in those tables)
  # plus the table name and universe, and table.var= a variable name as TableID.000 format

  ################################################################################################################
  ################################################################################################################

  # THIS SECTION BELOW MAY BE OBSOLETE IF NOW USING get.table.info2() instead of older get.table.info() !

  ################################################################################################################
  ################################################################################################################
  if (1==0) {
    ###############
    # GET TITLE OF EACH TABLE
    ###############
    tables.titles <- table.info$Table.Title[match(tables, table.info$Table.ID)]

    ###############
    # GET UNIVERSE FOR EACH TABLE
    ###############
    tables.universe <- table.info$Table.Title[1 + match(tables, table.info$Table.ID)]
    table.info.only <- data.frame(Table.ID=tables, Table.Title=tables.titles, universe=tables.universe, stringsAsFactors=FALSE)
    # print('table.info.only: '); print( table.info.only)

    ###############
    # GET LONG FIELD NAMES
    # corresponding to the current bg or tract dataset (merged set of all selected tables)
    ###############

    if (exists('bg') && length(bg)>0) {longnames <- names(bg)} else {longnames <- names(tracts)}
    valids<- !is.na(table.info$Line.Number)

    needed.table.var <- longnames # just all those that had been needed and were parsed to make bg or tracts, but may be subset of all vars in table.info

    cat('Fields obtained: '); print(longnames)

    for (i in 1:length(longnames)) {

      if (longnames[i] %in% table.info$table.var[valids]) {
        longnames[i] <- table.info$varname2[match(longnames[i], table.info$table.var)]
      }

      if (longnames[i] %in% paste(table.info$table.var[valids],'.m',sep='')) {
        longnames[i] <- paste(table.info$varname2[match(longnames[i], paste(table.info$table.var,'.m',sep=''))],'_MOE',sep='')
      }

      #  if (exists('bg'))     { if (length(bg)>0)     { label(bg[ , i])     <- longnames[i] } }
      #  if (exists('tracts')) { if (length(tracts)>0) { label(tracts[ , i]) <- longnames[i] } }
    }

    # ************
    # MAKE table.info.best which has
    # only valid fields/rows and has new columns for tables.universe
    # & tables.titles corrected & repeated for each row as appropriate.
    # ************
    #
    # Format of table.info:
    #   Table.ID Line.Number                 Table.Title  table.var   varname2 (a cleaned up version of Table.Title)
    #7    B01001          NA                  SEX BY AGE       <NA>   SEX BY AGE

    table.info.best <- table.info  # but this has too many variables if needed only a subset, so fix below
    # rename a column
    names(table.info.best) <- c('Table.ID', 'Line.Number', 'Table.Title', 'table.var', 'longnames')
    # remove rows that are just table title or universe
    table.info.best <- subset(table.info.best[!is.na(table.info.best$Line.Number) ,])

    # now fix problem where needed only subset of variables so table.info or table.info.best has all in ACS table but longnames is based on subset.
    table.info.best <- table.info.best[ table.info.best$table.var %in%  needed.table.var, ]

    if (testing) {print('before any');print('table.info.best');print(table.info.best);cat('\n\n\n');print('longnames: ');cat(longnames,'\n\n')}

    # make the MOE versions of the estimates columns, interspersed with estimates, to match full list of longnames
    table.info.best.m <- table.info.best
    table.info.best.m$table.var <- paste(table.info.best.m$table.var, '.m', sep='')
    if (testing) { print('before rbind, this is the dot m version');print(str(table.info.best.m)); cat('\n\n') }
    table.info.best <- rbind(table.info.best, table.info.best.m)
    if (testing) { print('str of table.info.best now'); print(str(table.info.best));print(table.info.best);cat('\n\n') }
    table.info.best <- table.info.best[  analyze.stuff::intersperse(1:length(table.info.best[,1])) , ]

    # add the basic info columns up front to match full list of longnames
    rows.to.add <- data.frame(Table.ID=c('KEY', 'FIPS', 'STUSAB', 'GEOID'), Line.Number=0, Table.Title=0, table.var=0, longnames=c('KEY', 'FIPS', 'STUSAB', 'GEOID'))
    if (testing) { print(rows.to.add); cat('\n\n') }
    table.info.best <- rbind(rows.to.add, table.info.best)
    if (testing) { print('after second rbind');cat('\n\n');print('table.info.best');print(table.info.best);cat('\n\n\n');print('longnames: ');cat(longnames,'\n')}

    # add actual longnames which have _MOE indication ********
    table.info.best$longnames <-  longnames    # now has the basic info cols, followed by estimates & MOE interspersed

    # make Table.Title column now be that (instead of fieldname), repeating the full table title for every row of the table (each variable in the table)
    table.info.best$Table.Title <- table.info.only$Table.Title[ match(table.info.best$Table.ID, table.info.only$Table.ID)]
    # add column specifying universe (out of which the estimate is a subset)
    table.info.best$universe <- table.info.only$universe[ match(table.info.best$Table.ID, table.info.only$Table.ID)]

    # use better order for columns
    table.info.best <- table.info.best[ , c('Table.Title', 'Table.ID', 'Line.Number', 'table.var', 'longnames', 'universe')]
    # print(table.info.best)
    save(table.info.best, file=file.path(folder, 'table.info.best.RData'))

    ###############
    # NOTE: IT IS EASIER TO WORK WITH get.table.info(tables) which has useful cols plus new cols for just selected tables
    #   than with get.lookup.acs() which returns nonuseful info and for all tables in acs

    ###############
    # USEFUL EXAMPLES OF GETTING TABLE VARIABLES INFORMATION:
    ###############

    # To get those long names for the variables in ONE ACS table in memory:
    #mytable <- data.frame(C17002.001=1:10, C17002.002=1:10) # create example dataset
    #longnames <- merge(
    #  data.frame(var=names(mytable)),
    #  data.frame(longname=table.info$varname2, table.var=table.info$table.var),
    #  by.x="var", by.y="table.var", all.x=TRUE, all.y=FALSE)

    # To get from ALL ACS tables specifed in 'tables', just the long names, for ALL the variables in a given table, not just needed variables:
    #longnames	<- with(lookup.acs, varname2[(Table.ID %in% tables) & !is.na(Line.Number)])

    # To get from ALL ACS tables specifed in 'tables', just the specified variables in a given table, as cleaned variable names,
    # assuming "needed" is in memory as a global variable still.
    #longnames	<- with(needed, varname2[(table %in% tables) ])
    #print(names(tracts));print(names(bg))
    ###############

  }

  ################################################################################################################
  ################################################################################################################

  #################################
  #  maybe save on disk final merged results as tracts and block groups files
  #################################

  if (save.files) {
    # WOULD BE BETTER TO SPECIFY A DATA DIRECTORY BUT FOR NOW SAVE IN WORKING DIR:
    save(bg, file=file.path(folder, "bg all tables.RData"))
    save(tracts, file=file.path(folder,"tracts all tables.RData"))
    #save()
    cat(as.character(Sys.time()), ' '); cat('Saved block group file and tracts file as .RData \n')
  }

  if (testing) {
    if (writefiles) {
      write.csv(bg, file=file.path(folder,"bg all tables.csv"), row.names=FALSE)
      write.csv(tracts, file=file.path(folder,"tracts all tables.csv"), row.names=FALSE)
      cat(as.character(Sys.time()), ' '); cat('Saved block group file and tracts file as .csv ')
    }
  }

  if (writefiles) {
    write.csv(table.info, row.names=FALSE, file=file.path(folder,'table.info.csv'))
    write.csv(t(cbind(names(bg), longnames)), file=file.path(folder,'bg.longnames.csv'), row.names=FALSE)
    cat(as.character(Sys.time()), ' '); cat('Saved longnames, full fieldnames as csv file. \n')
  }

  ########################################################
  cat(as.character(Sys.time()), '\n')

  cat("################ DONE ############## \n\n")

  # Return block group or tracts file (or both) as list, along with table.info.best which has fieldnames etc.
  if (substr(summarylevel,1,5)=='tract') {
    return(list(tracts=tracts, info=table.info.best))
  } else {
    if (summarylevel=='both') {
      return(list(bg=bg, tracts=tracts, info=table.info.best))
    } else {
      return(list(bg=bg, info=table.info.best))
    }
  }

  # could format for acs package here

}

