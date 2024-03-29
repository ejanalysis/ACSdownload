% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.acs.R
\name{get.acs}
\alias{get.acs}
\title{Download Tables from American Community Survey (ACS) 5-year Summary File}
\usage{
get.acs(
  tables = "B01001",
  mystates = "all",
  end.year = acsdefaultendyearhere_func(),
  base.path = getwd(),
  data.path = file.path(base.path, "acsdata"),
  output.path = file.path(base.path, "acsoutput"),
  sumlevel = "both",
  vars = "all",
  varsfile,
  new.geo = TRUE,
  write.files = FALSE,
  save.files = FALSE,
  write.acspkg = FALSE,
  testing = FALSE,
  noEditOnMac = FALSE,
  silent = FALSE,
  save.log = TRUE,
  filename.log = "log"
)
}
\arguments{
\item{tables}{Character vector, optional. Defines tables to obtain, such as 'B01001' (the default).
NOTE: If the user specifies a table called 'ejscreen' then a set of tables used by that tool are included.
Those tables in EJScreen 2.0 are  
c("B01001", "B03002", "B15002", 'C16002', "C17002", "B25034", 'B23025')}

\item{mystates}{Character vector, optional, 'all' by default which means all available states
plus DC and PR but not VI etc. Defines which States to include in downloads of data tables.}

\item{end.year}{Character, optional. Defines a valid ending year of a 5-year summary file.
Can be '2020' for example. Not all years are tested. Actually works if numeric like 2017, instead of character, too.}

\item{base.path}{Character, optional, getwd() by default. Defines a base folder to start from, in case
data.path and/or output.path are not specified, in which case a subfolder under base.path,
called acsdata or acsoutput respectively, will be created and used for downloads or outputs of the function.}

\item{data.path}{Character, optional, file.path(base.path, 'acsdata') by default.
Defines folder (created if does not exist) where downloaded files will be stored.}

\item{output.path}{Character, optional, file.path(base.path, 'acsoutput') by default.
Defines folder (created if does not exist) where output files (results of this function) will be stored.}

\item{sumlevel}{Default is "both" (case insensitive) in which case tracts and block groups are returned.
Also c('tract', 'bg') or c(140,150) and similar patterns work.
If "tract" or 140 or some other match, but not block groups, is specified (insensitive to case, tract can be plural or part of a word, etc.),
just tracts are returned.
If "bg" or 150 or "blockgroups" or "block groups" or some other match (insensitive to case, singular or plural or part of a word)
but no match on tracts is specified, just block groups are returned.
Non-matching elements are ignored (e.g., sumlevel=c('bg', 'tracs', 'block') will return block groups
but neither tracts (because of the typo) nor blocks (not available in ACS), with no warning --
No warning is given if sumlevel is set to a list of elements where some are not recognized as matches to bg or tract,
as long as one or more match bg, tracts, or both (or variants as already noted).}

\item{vars}{Optional, default is 'all' (in which case all variables from each table will be returned unless otherwise specified -- see below).
This parameter specifies whether to pause and ask the user about which variables are needed in an interactive session in R.
This gives the user a chance to prepare the file "variables needed.csv" (or just ensure it is ready),
or to edit and save "variables needed.csv" within a window in the default editor used by R (the user is asked which of these is preferred).
If vars is 'ask', the function just looks in \code{data.folder} for a file called "variables needed.csv" that, if used,
must specify which variables to keep from each table.
The format of that file should be the same as is found in the file "variables needed template.csv" created by this function --
keeping the letter "Y" in the column named "keep" indicates the given variable is needed.
A blank or "N" or other non-Y specifies the variable should be dropped and not returned by get.acs().
If the "variables needed.csv" file is not found, however, this function looks for and uses the file called "variables needed template.csv"
which is written by this function and specifies all of the variables from each table, so all variables will be retained and returned by get.acs().}

\item{varsfile}{See help for \code{\link{set.needed}} for details. Optional name of file that can be used to specify which variables are needed from specified tables.
If varsfile is specified, parameter vars is ignored, and the function just looks in folder for file called filename, e.g., "variables needed.csv"
that should specify which variables to keep from each table.}

\item{new.geo}{Default is TRUE. If FALSE, just uses existing downloaded geo file if possible. If TRUE, forced to download geo file even if already done previously.}

\item{write.files}{Default is FALSE, but if TRUE then data-related csv files are saved locally -- Saves longnames, full fieldnames as csv file, in working directory.}

\item{save.files}{Default is FALSE, but if TRUE then various intermediate image files are saved as .RData files locally in working directory.}

\item{write.acspkg}{Default is FALSE. If TRUE, saves csv file of tracts and file of block groups, for each of the \code{tables},
in a format that the Census Bureau American Fact Finder provides as downloadable tables. That format can be easily read in by the very useful \pkg{acs} package.}

\item{testing}{Default is FALSE, but if TRUE more information is shown on progress, using cat() and while downloading, and more files (csv) are saved in working directory. But see silent parameter.}

\item{noEditOnMac}{FALSE by default. If TRUE, do not pause to allow edit() to define which variables needed from each table,
when on Mac OSX, even if vars=TRUE. Allows you to avoid problem in RStudio if X11 not installed.}

\item{silent}{Optional logical, default is FALSE. Should progress updates be shown (sent to standard out, like the screen).}

\item{save.log}{Optional logical, default is TRUE. Should log file be saved in output.path folder}

\item{filename.log}{Optional name (without extension) for a log file, which gets date and time and .txt extension appended to it. Default is "log"}
}
\value{
By default, returns a list of ACS data tables and information about them, with these elements in the list: \cr
  bg, tracts, headers, and info. The headers and info elements are data.frames providing metadata such as short and long field names.
  The same column names are found in x$info and x$headers, but headers has more rows. The info table just provides information about each
  data variable in the estimates tables. The headers table provides similar information but made to match the bg or tract format,
  so the headers table has as many rows as bg or tracts has columns -- enough for the estimates and MOE fields, and the basic fields such as FIPS.
  The info data.frame can look like this, for example: \cr
 \preformatted{
  'data.frame':	xxxx obs. of  9 variables:
 $ table.ID       : chr  "B01001" "B01001" "B01001" "B01001" ...
 $ line           : num  1 2 3 4 5 6 7 8 9 10 ...
 $ shortname      : chr  "B01001.001" "B01001.002" "B01001.003" "B01001.004" ...
 $ longname       : chr  "Total:" "Male:" "Under 5 years" "5 to 9 years" ...
 $ table.title    : chr  "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" ...
 $ universe       : chr  "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" ...
 $ subject        : chr  "Age-Sex" "Age-Sex" "Age-Sex" "Age-Sex" ...
 $ longname2      : chr  "Total" "Male" "Under5years" "5to9years" ...
 $ longname.unique: chr  "Total:|SEX BY AGE" "Male:|SEX BY AGE" "Under 5 years|SEX BY AGE" "5 to 9 years|SEX BY AGE" ...
 }
}
\description{
NOTE: Census formats changed a lot, and some of the info below is obsolete. 
  Also see newer get.acs.all() that will try to use new format for 5yr summary file ACS
  that makes it easier to get one table for every blockgroup in the US.
  
  This function will download and parse 1 or more tables of data from the American Community Survey's
  5-year Summary File FTP site, for all Census tracts and/or block groups in specified State(s).
  Estimates and margins of error are obtained, as well as long and short names for the variables,
  which can be specified if only parts of a table are needed. \cr\cr
  It is especially useful if you want a lot of data such as all the blockgroups in the USA,
  which may take a long time to obtain using the Census API and a package like \pkg{\link[tidycensus]{tidycensus}} \cr\cr
  Release schedule for ACS 5-year data is here: \url{https://www.census.gov/programs-surveys/acs/news/data-releases.html}
  The 2016-2020 ACS 5-year estimates release date is December 9, 2021.
}
\details{
The United States Census Bureau provides detailed demographic data by US Census tract and block group
  in the American Community Survey (ACS) 5-year summary file via their FTP site. For those interested in block group or tract data,
  Census Bureau tools tend to focus on obtaining data one state at a time rather than for the entire US at once.
  This function lets a user specify (tables and) variables needed. This will look up what sequence files
  contain those tables. Using a table of variables for those selected tables, a user can specify variables
  or tables to drop by putting x or anything other than "Y" in the column specifying needed variables. \cr\cr
  For ACS documentation, see for example:\cr\cr
  \url{http://www.census.gov/programs-surveys/acs.html} \cr
}
\note{
#' #####################################	ADDITIONAL NOTES ######################################\cr
	SEE CENSUS ACS DOCUMENTATION ON NON-NUMERIC FIELDS IN ESTIMATE AND MOE FILES.\cr \cr
 Note relevant sequence numbers change over time. \cr
############# \cr \cr
#####################################################################################  \cr
OLDER NOTES on where to obtain ACS data - sources for downloads of summary file data  \cr
##################################################################################### \cr\cr \cr

FOR ACS SUMMARY FILE DOCUMENTATION, SEE \cr
\url{https://www.census.gov/acs/www/data_documentation/summary_file/} \cr \cr

 LARGER THAN NECESSARY: \cr\cr

*** all states and all tables in one huge tar.gz file (plus a zip of all geography codes)  \cr
\url{ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)} \cr
\url{ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)/2011_ACS_Geography_Files.zip} \cr
2011_ACS_Geography_Files.zip		# \cr
Tracts_Block_Groups_Only.tar.gz		# (THIS HAS ALL THE SEQUENCE FILES FOR EACH STATE IN ONE HUGE ZIP FOLDER) \cr\cr

or \cr\cr

 MORE FOCUSED DOWNLOADS: \cr\cr

*** one zip file per sequence file PER STATE:    (plus csv of geography codes) \cr \cr

\url{http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/} \cr
        20115dc0002000.zip (Which has the e file and m file for this sequence file in this state) \cr
        g20115dc.csv  (which lets you link FIPS to data) \cr
so this would mean 50+ * about 7 sequence files? = about 350 zip files?? each with 2 text files. Plus 50+ geo csv files.
so downloading about 400 files and expanding to about 750 files, and joining into one big file.\cr

OR \cr\cr

 PREJOINED TO TIGER BLOCK GROUP BOUNDARIES SHAPEFILES/ GEODATABASES - \cr
ONE PER STATE HAS SEVERAL TABLES \cr
\url{http://www.census.gov/geo/maps-data/data/tiger-data.html} \cr
 BUT NOT one file per sequence file FOR ALL STATES AT ONCE. \cr
Estimates & margin of error (MOE), (ONCE UNZIPPED), and GEOgraphies (not zipped) are in 3 separate files. \cr \cr

also, data for entire US for one seq file at a time, but not tract/bg -- just county and larger? -- is here, e.g.:
\url{ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/20111us0001000.zip} \cr
GEO files:\cr
Note the US file is not bg/tract level:  geo for whole US at once doesn't have tracts and BGs
\url{ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/g20111us.csv} \cr\cr

OTHER SOURCES include \cr
\itemize{
  \item \pkg{\link[tidycensus]{tidycensus}} package for R - uses API, requires a key, very useful for modest numbers of Census units rather than every block group in US
  \item \pkg{\link[acs]{acs}} package for R - uses API, requires a key, very useful for modest numbers of Census units rather than every block group in US
  \item \url{http://www.NHGIS.org} - (and see \code{\link{nhgis}}) very useful for block group (or tract/county/state/US) datasets
  \item DataFerrett (\url{http://dataferrett.census.gov/AboutDatasets/ACS.html}) -- not all tracts in US at once
  \item American Fact Finder (\url{http://www.census.gov/acs/www/data/data-tables-and-tools/american-factfinder/}) (not block groups for ACS SF, and the tracts are not for the whole US at once)
  \item ESRI - commercial
  \item Geolytics - commercial
  \item etc.
}
}
\examples{
  ##### Basic info on ACS tables:
  cbind(table(lookup.acs2020$Subject.Area))
  
                                                                                   table.title table.ID
                                                                                    SEX BY AGE   B01001
                                                             HISPANIC OR LATINO ORIGIN BY RACE   B03002
                            SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER   B15002
                            
AGE BY LANGUAGE SPOKEN AT HOME BY ABILITY TO SPEAK ENGLISH FOR THE POPULATION 5 YEARS AND OVER   B16004
                               HOUSEHOLD LANGUAGE BY HOUSEHOLD LIMITED ENGLISH SPEAKING STATUS   C16002

                                        RATIO OF INCOME TO POVERTY LEVEL IN THE PAST 12 MONTHS   C17002
                                        EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER   B23025    
                                                                                                                  YEAR STRUCTURE BUILT   B25034    #' 
  # from the census website, see USA ACS tables:
 mytables <- c("B01001", "B03002", "B15002", 'B23025', "B25034", "C16002", "C17002") # EJScreen-related
 yr <- 2020 # ACS 5YR Summary File 2016-2020
 geos <- '0100000US_0400000US72' # US (just 50 States and DC) and PR: 
 https://data.census.gov/cedsci/table?q=acs\%20B01001\%20B03002\%20B15002\%20B23025\%20B25034\%20C16002\%20C17002&g=0100000US_0400000US72&y=2020
 myurl <- paste0('https://data.census.gov/cedsci/table?q=acs\%20', paste(mytables, collapse= '\%20'), '&g=', geos, '&y=', yr)
 # browseURL(myurl)
 
1    B03002    1 B03002.001                                                       Total:
2    B03002    2 B03002.002     Not Hispanic or Latino:
  3    B03002    3 B03002.003                                                  White alone
  4    B03002    4 B03002.004                              Black or African American alone
  5    B03002    5 B03002.005                      American Indian and Alaska Native alone
  6    B03002    6 B03002.006                                                  Asian alone
  7    B03002    7 B03002.007             Native Hawaiian and Other Pacific Islander alone
  8    B03002    8 B03002.008                                        Some other race alone
  9    B03002    9 B03002.009                                           Two or more races
  12   B03002   12 B03002.012   Hispanic or Latino
  
 \dontrun{
  t( get.table.info('B01001', end.year = acsdefaultendyearhere_func()) )
  t( get.table.info(c('B17001', 'C17002') ) )
  get.field.info('C17002')
  ##### Data for just DC & DE, just two tables:
  outsmall <- get.acs(tables = c('B01001', 'C17002'), mystates=c('dc','de'),
   end.year = acsdefaultendyearhere_func(), base.path = '~/Downloads', write.files = T, new.geo = FALSE)
  summary(outsmall)
  t(outsmall$info[1, ])
  t(outsmall$bg[1, ])

   ## ENTIRE USA -- DOWNLOAD AND PARSE -- TAKES A COUPLE OF MINUTES for one table:
   acs_2014_2018_B01001_vars_bg_and_tract <- get.acs(
     base.path='~/Downloads', end.year='2018', write.files = TRUE, new.geo = FALSE)

  ########################################################################
  ##### Data for just DC & DE, just the default pop count table:
  out <- get.acs(mystates=c('dc','de'), end.year = acsdefaultendyearhere_func(), new.geo = FALSE)
  names(out$bg); cat('\n\n'); head(out$info)
  head(t(rbind(id=out$headers$table.ID, long=out$headers$longname, univ=out$headers$universe,
     subj=out$headers$subject,  out$bg[1:2,]) ), 15)
  cbind(longname=out$info$longname,
        total=colSums(out$bg[ , names(out$bg) \%in\% out$info$shortname ]))
  ### to see data on 2 places, 1 per column, with short and long field names
  cbind( out$headers$longname, t(out$bg[1:2, ]) )
  ### to see 7 places, 1 per row, with short and long field name as header
  head( rbind(out$headers$longname, out$bg) )[,1:7]
  ##### just 2 tables for just Delaware
  out <- get.acs(mystates='de', tables=c('B01001', 'C17002'))
  summary(out); head(out$info); head(out$bg)
  ##### uses all EJSCREEN defaults and the specified folders:
  out <- get.acs(base.path='~', data.path='~/ACStemp', output.path='~/ACSresults')
  summary(out); head(out$info); head(out$bg)
  ##### all tables needed for EJSCREEN, plus 'B16001', # b16001 has more details on specific languages spoken
    with variables specified in 'variables needed.csv', all states and DC and PR:
  out <- get.acs(tables=c('ejscreen', 'B16001'))
  summary(out); head(out$info); head(out$bg)
 }

}
\seealso{
\pkg{\link[acs]{acs}} package, which allows you to download and work with ACS data (using the API and your own key).
   To get the tables and variables used in EJSCREEN, see \link[ejscreen]{ejscreen.download}.
   Also see \code{\link{nhgis}} which parses any files manually downloaded from \url{NHGIS.org}
}
