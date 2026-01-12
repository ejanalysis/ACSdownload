# Older function to download Tables from American Community Survey (ACS) 5-year Summary File (before the acs2022 5yr data)

Now see newer [`get_acs_new()`](reference/get_acs_new.md) that will try
to use new format for 5yr summary file ACS

## Usage

``` r
get_acs_old(
  tables = "B01001",
  mystates = "all",
  end.year = acsdefaultendyearhere,
  base.path = getwd(),
  data.path = file.path(base.path, "acsdata"),
  output.path = file.path(base.path, "acsoutput"),
  sumlevel = "both",
  vars = "all",
  varsfile,
  new.geo = TRUE,
  write.files = FALSE,
  save.files = FALSE,
  testing = FALSE,
  noEditOnMac = FALSE,
  silent = FALSE,
  save.log = TRUE,
  filename.log = "log"
)
```

## Arguments

- tables:

  Character vector, optional. Defines tables to obtain, such as 'B01001'
  (the default). NOTE: If the user specifies a table called 'ejscreen'
  then a set of tables used by that tool are included.

- mystates:

  Character vector, optional, 'all' by default which means all available
  states plus DC and PR but not VI etc. Defines which States to include
  in downloads of data tables.

- end.year:

  Character, optional. Defines a valid ending year of a 5-year summary
  file. Can be '2020' for example. Not all years are tested. Actually
  works if numeric like 2017, instead of character, too.

- base.path:

  Character, optional, getwd() by default. Defines a base folder to
  start from, in case data.path and/or output.path are not specified, in
  which case a subfolder under base.path, called acsdata or acsoutput
  respectively, will be created and used for downloads or outputs of the
  function.

- data.path:

  Character, optional, file.path(base.path, 'acsdata') by default.
  Defines folder (created if does not exist) where downloaded files will
  be stored.

- output.path:

  Character, optional, file.path(base.path, 'acsoutput') by default.
  Defines folder (created if does not exist) where output files (results
  of this function) will be stored.

- sumlevel:

  Default is "both" (case insensitive) in which case tracts and block
  groups are returned. Also c('tract', 'bg') or c(140,150) and similar
  patterns work. If "tract" or 140 or some other match, but not block
  groups, is specified (insensitive to case, tract can be plural or part
  of a word, etc.), just tracts are returned. If "bg" or 150 or
  "blockgroups" or "block groups" or some other match (insensitive to
  case, singular or plural or part of a word) but no match on tracts is
  specified, just block groups are returned. Non-matching elements are
  ignored (e.g., sumlevel=c('bg', 'tracs', 'block') will return block
  groups but neither tracts (because of the typo) nor blocks (not
  available in ACS), with no warning – No warning is given if sumlevel
  is set to a list of elements where some are not recognized as matches
  to bg or tract, as long as one or more match bg, tracts, or both (or
  variants as already noted).

- vars:

  Optional, default is 'all' (in which case all variables from each
  table will be returned unless otherwise specified – see below). This
  parameter specifies whether to pause and ask the user about which
  variables are needed in an interactive session in R. This gives the
  user a chance to prepare the file "variables needed.csv" (or just
  ensure it is ready), or to edit and save "variables needed.csv" within
  a window in the default editor used by R (the user is asked which of
  these is preferred). If vars is 'ask', the function just looks in
  `data.folder` for a file called "variables needed.csv" that, if used,
  must specify which variables to keep from each table. The format of
  that file should be the same as is found in the file "variables needed
  template.csv" created by this function – keeping the letter "Y" in the
  column named "keep" indicates the given variable is needed. A blank or
  "N" or other non-Y specifies the variable should be dropped and not
  returned by get_acs_old(). If the "variables needed.csv" file is not
  found, however, this function looks for and uses the file called
  "variables needed template.csv" which is written by this function and
  specifies all of the variables from each table, so all variables will
  be retained and returned by get_acs_old().

- varsfile:

  See help for [`set.needed()`](reference/set.needed.md) for details.
  Optional name of file that can be used to specify which variables are
  needed from specified tables. If varsfile is specified, parameter vars
  is ignored, and the function just looks in folder for file called
  filename, e.g., "variables needed.csv" that should specify which
  variables to keep from each table.

- new.geo:

  Default is TRUE. If FALSE, just uses existing downloaded geo file if
  possible. If TRUE, forced to download geo file even if already done
  previously.

- write.files:

  Default is FALSE, but if TRUE then data-related csv files are saved
  locally – Saves longnames, full fieldnames as csv file, in working
  directory.

- save.files:

  Default is FALSE, but if TRUE then various intermediate image files
  are saved as .RData files locally in working directory.

- testing:

  Default is FALSE, but if TRUE more information is shown on progress,
  using cat() and while downloading, and more files (csv) are saved in
  working directory. But see silent parameter.

- noEditOnMac:

  FALSE by default. If TRUE, do not pause to allow edit() to define
  which variables needed from each table, when on Mac OSX, even if
  vars=TRUE. Allows you to avoid problem in RStudio if X11 not
  installed.

- silent:

  Optional logical, default is FALSE. Should progress updates be shown
  (sent to standard out, like the screen).

- save.log:

  Optional logical, default is TRUE. Should log file be saved in
  output.path folder

- filename.log:

  Optional name (without extension) for a log file, which gets date and
  time and .txt extension appended to it. Default is "log"

## Value

By default, returns a list of ACS data tables and information about
them, with these elements in the list:  
bg, tracts, headers, and info. The headers and info elements are
data.frames providing metadata such as short and long field names. The
same column names are found in x\$info and x\$headers, but headers has
more rows. The info table just provides information about each data
variable in the estimates tables. The headers table provides similar
information but made to match the bg or tract format, so the headers
table has as many rows as bg or tracts has columns – enough for the
estimates and MOE fields, and the basic fields such as FIPS. The info
data.frame can look like this, for example:  

      'data.frame': xxxx obs. of  9 variables:
     $ table.ID       : chr  "B01001" "B01001" "B01001" "B01001" ...
     $ line           : num  1 2 3 4 5 6 7 8 9 10 ...
     $ shortname      : chr  "B01001.001" "B01001.002" "B01001.003" "B01001.004" ...
     $ longname       : chr  "Total:" "Male:" "Under 5 years" "5 to 9 years" ...
     $ table.title    : chr  "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" "SEX BY AGE" ...
     $ universe       : chr  "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" ...
     $ subject        : chr  "Age-Sex" "Age-Sex" "Age-Sex" "Age-Sex" ...
     $ longname2      : chr  "Total" "Male" "Under5years" "5to9years" ...
     $ longname.unique: chr  "Total:|SEX BY AGE" "Male:|SEX BY AGE" "Under 5 years|SEX BY AGE" "5 to 9 years|SEX BY AGE" ...
     

## Details

NOTE: Census formats changed a lot, and some of the info below is
obsolete. New format since 2022 acs makes it easier to get one table for
every blockgroup in the US.

This older function downloaded and parsed 1 or more tables of data from
the American Community Survey's 5-year Summary File FTP site, for all
Census tracts and/or block groups in specified State(s). Estimates and
margins of error are obtained, as well as long and short names for the
variables, which can be specified if only parts of a table are needed.

It is especially useful if you want a lot of data such as all the
blockgroups in the USA, which may take a long time to obtain using the
Census API and a package like
[tidycensus::tidycensus](https://walker-data.com/tidycensus/reference/tidycensus-package.html)

Release schedule for ACS 5-year data is here:
<https://www.census.gov/programs-surveys/acs/news/data-releases.html>
The 2018-2022 ACS 5-year estimates release date was December, 2023.

For information on new Summary File format visit
<https://www.census.gov/programs-surveys/acs/data/summary-file.html>

The United States Census Bureau provides detailed demographic data by US
Census tract and block group in the American Community Survey (ACS)
5-year summary file via their FTP site. For those interested in block
group or tract data, Census Bureau tools tend to focus on obtaining data
one state at a time rather than for the entire US at once. This function
lets a user specify (tables and) variables needed. This will look up
what sequence files contain those tables. Using a table of variables for
those selected tables, a user can specify variables or tables to drop by
putting x or anything other than "Y" in the column specifying needed
variables.

For ACS documentation, see for example:

[http://www.census.gov/programs-surveys/acs.html](http://www.census.gov/programs-surveys/acs.md)

\##################################### ADDITIONAL NOTES
\######################################

    SEE CENSUS ACS DOCUMENTATION ON NON-NUMERIC FIELDS IN ESTIMATE AND MOE FILES.\cr \cr

Note relevant sequence numbers change over time.  
\#############  
  
\#####################################################################################  
OLDER NOTES on where to obtain ACS data - sources for downloads of
summary file data  
\#####################################################################################  
  
  

FOR ACS SUMMARY FILE DOCUMENTATION, SEE  
<https://www.census.gov/acs/www/data_documentation/summary_file/>  
  

LARGER THAN NECESSARY:  
  

\*\*\* all states and all tables in one huge tar.gz file (plus a zip of
all geography codes)  
<ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)>  
<ftp://ftp.census.gov/acs2011_5yr/summaryfile//2007-2011_ACSSF_All_In_2_Giant_Files(Experienced-Users-Only)/2011_ACS_Geography_Files.zip>  
2011_ACS_Geography_Files.zip \#  
Tracts_Block_Groups_Only.tar.gz \# (THIS HAS ALL THE SEQUENCE FILES FOR
EACH STATE IN ONE HUGE ZIP FOLDER)  
  

or  
  

MORE FOCUSED DOWNLOADS:  
  

\*\*\* one zip file per sequence file PER STATE: (plus csv of geography
codes)  
  

<http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/>  
20115dc0002000.zip (Which has the e file and m file for this sequence
file in this state)  
g20115dc.csv (which lets you link FIPS to data)  
so this would mean 50+ \* about 7 sequence files? = about 350 zip
files?? each with 2 text files. Plus 50+ geo csv files. so downloading
about 400 files and expanding to about 750 files, and joining into one
big file.  

OR  
  

PREJOINED TO TIGER BLOCK GROUP BOUNDARIES SHAPEFILES/ GEODATABASES -  
ONE PER STATE HAS SEVERAL TABLES  
[http://www.census.gov/geo/maps-data/data/tiger-data.html](http://www.census.gov/geo/maps-data/data/tiger-data.md)  
BUT NOT one file per sequence file FOR ALL STATES AT ONCE.  
Estimates & margin of error (MOE), (ONCE UNZIPPED), and GEOgraphies (not
zipped) are in 3 separate files.  
  

also, data for entire US for one seq file at a time, but not tract/bg –
just county and larger? – is here, e.g.:
(ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/20111us0001000.zip)

GEO files:

Note the US file is not bg/tract level: geo for whole US at once doesn't
have tracts and BGs
(ftp://ftp.census.gov/acs2011_1yr/summaryfile//2011_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/g20111us.csv)

OTHER SOURCES include

- [`tidycensus::tidycensus()`](https://walker-data.com/tidycensus/reference/tidycensus-package.html)
  package for R - uses API, requires a key, very useful for modest
  numbers of Census units rather than every block group in US

- http://www.NHGIS.org - (and see [`nhgis()`](reference/nhgis.md)) very
  useful for block group (or tract/county/state/US) datasets

- [DataFerrett](http://dataferrett.census.gov/AboutDatasets/ACS.md) –
  not all tracts in US at once

- [American Fact
  Finder](http://www.census.gov/acs/www/data/data-tables-and-tools/american-factfinder/)
  (not block groups for ACS SF, and the tracts are not for the whole US
  at once)

- ESRI - commercial

- Geolytics - commercial

- etc.

## See also

[`get_acs_new()`](reference/get_acs_new.md) for newer code. Also note
[tidycensus package](https://walker-data.com/tidycensus/), which allows
you to download and work with ACS data (using the API and your own key).
Regarding the ACS-derived variables used in EJSCREEN, see the [EJAM
package](https://ejanalysis.com/ejam-code).

## Examples
