
# Starting with the 2022 data release, the Table-Based Format is the only format available.
# The 2021 data releases were the final releases of the original sequence-based format.
# Beginning with the 2018 ACS, the U.S. Census
# Bureau began testing a streamlined format that
# the estimates and MOEs were grouped by table ID.
#
# Under this table-based format,
# **** a file is posted for each table****
# that contains the estimates and MOEs
# for all available geographies.
#
# Users can easily select
# the individual table(s), only needing to merge in
# a separate file containing geographic labels to
# reproduce the complete table(s). The table-based
# format will be the only format available starting with
# the 2022 ACS data release.
## Geography Labels - All geography labels for 1-year or 5-year data release
#
# Example File Name: Geos20211YR.txt or Geos20215YR.txt
# Example: 0400000US06 = “California”
#
# see
# https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html
# https://www.census.gov/programs-surveys/acs/library/handbooks/geography.html
# https://www2.census.gov/programs-surveys/acs/summary_file/handbooks/acs_table_based_summary_file_handbook.pdf
# the data
# https://www2.census.gov/programs-surveys/acs/summary_file/
# <https://www2.census.gov/programs-surveys/acs/summary_file/2020/data/5_year_entire_sf/2020_ACS_Geography_Files.zip>
# documentation
#  https://www.census.gov/programs-surveys/acs/data/summary-file.html
#  https://www2.census.gov/programs-surveys/acs/summary_file/2023/table-based-SF/documentation/
#  https://www2.census.gov/programs-surveys/acs/summary_file/2023/table-based-SF/documentation/Geos20235YR.txt
#
# Geos20235YR.txt looks like
#
# FILEID|STUSAB|SUMLEVEL|COMPONENT|US|REGION|DIVISION|STATE|COUNTY|COUSUB|PLACE|TRACT|BLKGRP|CONCIT|AIANHH|AIANHHFP|AIHHTLI|AITS|AITSFP|ANRC|CBSA|CSA|METDIV|MACC|MEMI|NECTA|CNECTA|NECTADIV|UA|CDCURR|SLDU|SLDL|ZCTA5|SUBMCD|SDELM|SDSEC|SDUNI|UR|PCI|PUMA5|GEO_ID|NAME|BTTR|BTBG|TL_GEO_ID
# ACSSF|US|010|00|1||||||||||||||||||||||.|.|||||||||||||0100000US|United States|||
# ACSSF|US|010|89|1||||||||||||||||||||||.|.|||||||||||||0100089US|United States -- American Indian Reservation and Trust Land -- Federal|||
# ACSSF|US|010|90|1||||||||||||||||||||||.|.|||||||||||||0100090US|United States -- American Indian Reservation and Trust Land -- State|||
# ACSSF|US|010|91|1||||||||||||||||||||||.|.|||||||||||||0100091US|United States -- Oklahoma Tribal Statistical Area|||
#
# etc.
##
##   ACS20235YR_Table_Shells.txt  looks like
#
# Table ID|Line|Indent|Unique ID|Label|Title|Universe|Type
# B01001|1.0|0|B01001_001|Total:|Sex by Age|Total population|int
# B01001|2.0|1|B01001_002|Male:|Sex by Age|Total population|int
# B01001|3.0|2|B01001_003|Under 5 years|Sex by Age|Total population|int
# B01001|4.0|2|B01001_004|5 to 9 years|Sex by Age|Total population|int
# B01001|5.0|2|B01001_005|10 to 14 years|Sex by Age|Total population|int
#
# but...
#   head(geoformat2020)  looks like
#
#     varname                                     description size start       type
# 1    FILEID Always equal to ACS Summary File identification    6     1     Record
# 2    STUSAB                       State Postal Abbreviation    2     7     Record
# 3  SUMLEVEL                                   Summary Level    3     9     Record
# 4 COMPONENT                            Geographic Component    2    12     Record
# 5  LOGRECNO                           Logical Record Number    7    14     Record
# 6        US                                              US    1    21 Geographic

#### NOTES FROM OLD PRE-2022 APPROACH:

##################################################################### #

# created geoformat20xx.RData files like this:

############## THE FORMAT IS NOT CSV - IT IS FIXED FORMAT ***** widths taken from PDF technical documentation
# Negative-width fields are used to indicate columns to be skipped, e.g., -5 to skip 5 columns.
# These fields are not seen by read.table and so should not be included in a col.names or colClasses argument (nor in the header line, if present).
#
# For ACS 2007-2012, 2008-2012, and 2009-2013, this is the format: (earlier years differ only in last few fields)
#
#  ftp://ftp.census.gov/acs2012_5yr/summaryfile/ACS_2008-2012_SF_Tech_Doc.pdf
#	"FILEID", "STUSAB", "SUMLEVEL", "COMPONENT", "LOGRECNO",
#	"US", "REGION", "DIVISION", "STATECE", "STATE", "COUNTY", "COUSUB", "PLACE", "TRACT", "BLKGRP", "CONCIT",
#	"AIANHH", "AIANHHFP", "AIHHTLI", "AITSCE", "AITS", "ANRC", "CBSA", "CSA", "METDIV", "MACC", "MEMI",
#	"NECTA", "CNECTA", "NECTADIV", "UA", "BLANK", "CDCURR", "SLDU", "SLDL", "BLANK", "BLANK", "ZCTA5",
#	"SUBMCD", "SDELM", "SDSEC", "SDUNI", "UR", "PCI", "BLANK", "BLANK", "PUMA5", "BLANK", "GEOID", "NAME", "BTTR", "BTBG", "BLANK"
# Tech docs are here:
# ftp://ftp.census.gov/acs2009_5yr/summaryfile/ACS_2005-2009_SF_Tech_Doc.pdf  # see pages 12-14. format of last few fields differs from other years.
# ftp://ftp.census.gov/acs2010_5yr/summaryfile/ACS_2006-2010_SF_Tech_Doc.pdf  # see pages 11-12.
# ftp://ftp.census.gov/acs2011_5yr/summaryfile/ACS_2007-2011_SF_Tech_Doc.pdf  # see pages 11-12.
# ftp://ftp.census.gov/acs2012_5yr/summaryfile/ACS_2008-2012_SF_Tech_Doc.pdf  # see pages 11-12.
# ftp://ftp.census.gov/acs2013_5yr/summaryfile/ACS_2013_SF_Tech_Doc.pdf      # note this year named differently. Pages 10 and 11 show the 2009-2013 geo format is the same as for 2008-2012.
# 2014 geo info verified as having exact same format as 2013.
# 2013 geo info:
# We also provide an Excel template for the geography file named “SFGeoFileTemplate.xls.” (I cannot find the 2009-2013 version yet, as of 10/12/2015)
# The template provides users with two rows containing the variable names and their descriptions (as displayed in the above table) for each column in the geography file. It is meant to be used with the comma delimited version of the geography file.
# The template is available in the User Tools folder for your dataset (i.e., www2.census.gov/acs2013_1yr/summaryfile/UserTools/
# in the zipped “2013_SummaryFileTemplates” folder).
#
#   x <- list(
#     c("FILEID", 6, 1),
#     c("STUSAB", 2, 7),
#     c("SUMLEVEL", 3, 9),
#     c("COMPONENT", 2, 12),
#     c("LOGRECNO", 7, 14),
#     c("US", 1, 21),
#     c("REGION", 1, 22),
#     c("DIVISION", 1, 23),
#     c("STATECE", 2, 24),
#     c("STATE", 2, 26),
#     c("COUNTY", 3, 28),
#     c("COUSUB", 5, 31),
#     c("PLACE", 5, 36),
#     c("TRACT", 6, 41),
#     c("BLKGRP", 1, 47),
#     c("CONCIT", 5, 48),
#     c("AIANHH", 4, 53),
#     c("AIANHHFP", 5, 57),
#     c("AIHHTLI", 1, 62),
#     c("AITSCE", 3, 63),
#     c("AITS", 5, 66),
#     c("ANRC", 5, 71),
#     c("CBSA", 5, 76),
#     c("CSA", 3, 81),
#     c("METDIV", 5, 84),
#     c("MACC", 1, 89),
#     c("MEMI", 1, 90),
#     c("NECTA", 5, 91),
#     c("CNECTA", 3, 96),
#     c("NECTADIV", 5, 99),
#     c("UA", 5, 104),
#     c("BLANK", 5, 109),
#     c("CDCURR", 2, 114),
#     c("SLDU", 3, 116),
#     c("SLDL", 3, 119),
#     c("BLANK", 6, 122),
#     c("BLANK", 3, 128),
#     c("ZCTA5", 5, 131),
#     c("SUBMCD", 5, 136),
#     c("SDELM", 5, 141),
#     c("SDSEC", 5, 146),
#     c("SDUNI", 5, 151),
#     c("UR", 1, 156),
#     c("PCI", 1, 157),
#     c("BLANK", 6, 158),
#     c("BLANK", 5, 164),
#     c("PUMA5", 5, 169),
#     c("BLANK", 5, 174),
#     c("GEOID", 40, 179),
#     c("NAME", 1000, 219),
#     c("BTTR", 6, 1219),
#     c("BTBG", 1, 1225),
#     c("BLANK", 44, 1226)
#   )
#   # 	c("NAME", 1000, 219),  # 200, 219 in 2005-2009 file and in 06-10 files. 07-11 is like 08-12 & 09-13.
#   # 	c("BTTR", 6, 1219),    # field not in the 0509 file. 6, 419 in 06-10.   07-11 is like 08-12 & 09-13.
#   # 	c("BTBG", 1, 1225),    # field not in the 0509 file. 1, 425 in 06-10.   07-11 is like 08-12 & 09-13.
#   # 	c("BLANK", 44, 1226)   # 50, 419 in the 0509 file.  50, 426 in 06-10.   07-11 is like 08-12 & 09-13.
#
#   geoformat <- matrix(unlist(x), nrow=length(x), ncol=length(x[[1]]), byrow=TRUE)
#   rm(x)
#   geoformat <- data.frame(geoformat, stringsAsFactors=FALSE)
#   names(geoformat) <- c("varname", "size", "start")
#   geoformat$size <- as.numeric(geoformat$size)
#   geoformat$start <- as.numeric(geoformat$start)
#
#     geoformat2013 <- geoformat
#     geoformat2012 <- geoformat
#     geoformat2011 <- geoformat
#     geoformat2010 <- geoformat
#     geoformat2009 <- geoformat
#
#     geoformat2010[geoformat2010$varname=='NAME', c('size', 'start')] <- c(200, 219)
#     geoformat2009[geoformat2009$varname=='NAME', c('size', 'start')] <- c(200, 219)
#
#     geoformat2010[geoformat2010$varname=='BLANK' & geoformat2010$start==1226, c('size', 'start')] <- c(50, 426)
#     geoformat2009[geoformat2009$varname=='BLANK' & geoformat2009$start==1226, c('size', 'start')] <- c(50, 419)
#
#     geoformat2010 <- subset(geoformat2010, geoformat2010$varname!='BTTR')
#     geoformat2009 <- subset(geoformat2009, geoformat2009$varname!='BTTR')
#
#     geoformat2010 <- subset(geoformat2010, geoformat2010$varname!='BTBG')
#     geoformat2009 <- subset(geoformat2009, geoformat2009$varname!='BTBG')
#
#     save(geoformat2009, file = 'geoformat2009.RData')
#     save(geoformat2010, file = 'geoformat2010.RData')
#     save(geoformat2011, file = 'geoformat2011.RData')
#     save(geoformat2012, file = 'geoformat2012.RData')
#     save(geoformat2013, file = 'geoformat2013.RData')
#     geoformat2014 <- geoformat
#     save(geoformat2014, file = 'geoformat2014.RData')

################################################################### #



##################### #
## do this first:

library(ACSdownload)
devtools::load_all()

##################### #
set_metadata = function(lookup.this, end.this = end.year) {
  # metadata to be stored as attributes of data object
  met = list(
    date_updated          = as.character(Sys.Date()),
    date_saved_in_package = as.character(Sys.Date()),
    date_downloaded       = as.character(Sys.Date()),
    acs_releasedate =     paste0(end.this, "-12"),  #"2023-12-07",
    acs_version =         paste0(end.this - 4, "-", end.this), # "2018-2022",
    end.year = end.this
  )
  ## if EJAM pkg is installed:
  # lookup.acs2022 <- EJAM:::metadata_add(lookup.acs2022, metadata = met)
  ## which would essentially do this:
  for (i in 1:length(met)) {
    attr(lookup.this, which = names(met)[i]) <- met[[i]]
  }
  return(lookup.this)
}
###################### #
meta_use = function(x) {
  x <- set_metadata(x)
  assign(newname, x)
  text_to_do <- paste0("usethis::use_data(", newname, ", overwrite=TRUE)")
  eval(parse(text = text_to_do))
}
###################### #
downfile = function(yr = end.year) {


  urlx = paste0('https://www2.census.gov/programs-surveys/acs/summary_file/',
                yr,
                '/table-based-SF/documentation/Geos', yr, '5YR.txt'  # e.g.,  Geos20235YR.txt
                # '/documentation/geography/5yr_year_geo/g', yr, '5us.csv'
                )
  destfile = paste0('g', yr, '5us.csv')
  cat("Trying to download from", urlx, "\n")
  z <- try(download.file(
    urlx,
    destfile = destfile
  ))
  if (inherits(z, "try-error")) {stop("Failed to download: ", urlx)}
  cat("Saved as", destfile, "\n")
  return(destfile)
}
######### #
get_use_geoformat = function(yr) {

  td = tempdir()
  dir.create(file.path(td, "acs"), recursive = TRUE)
  oldwd = getwd()
  on.exit(setwd(oldwd))
  setwd(file.path(td, "acs"))

  yr <- as.numeric(yr)
  fname <- downfile(yr)
  x <- read.csv(fname)
  x <- meta_use(x)
  assign(paste0("geoformat", yr), x)
}
################################################################################ #

# GET NEW FILE, NAME IT, ADD METADATA, SAVE FOR USE IN PKG:

x = get_use_geoformat(yr = acsdefaultendyearhere )   # e.g.,   2023

setwd(oldwd)
rm(downfile, meta_use, get_use_geoformat, td, oldwd, set_metadata)
################################################################################ #
## full US geo file, not what I call the geoformat file (which is tiny)
#
## browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/geography/5yr_year_geo/")
## browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2020/documentation/geography/5yr_year_geo/")
## browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/documentation/geography/5yr_year_geo/")
#    browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only/g20215de.txt")
## browseURL("https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/") # no seq-based 2022.
#             https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/Geos20225YR.txt
# FILEID|STUSAB|SUMLEVEL|COMPONENT|US|REGION|DIVISION|STATE|COUNTY|COUSUB|PLACE|TRACT|BLKGRP|CONCIT|AIANHH|AIANHHFP|AIHHTLI|AITS|AITSFP|ANRC|CBSA|CSA|METDIV|MACC|MEMI|NECTA|CNECTA|NECTADIV|UA|CDCURR|SLDU|SLDL|ZCTA5|SUBMCD|SDELM|SDSEC|SDUNI|UR|PCI|PUMA5|GEO_ID|NAME|BTTR|BTBG|TL_GEO_ID
#
#
# 2018 and 2019 lack the normal geo file documentation they used to have
# also, read.geo() used read.fwf() at least for older years. 2018 or 2019 might have csv not just txt format now?
#
# there is this:
#
# <https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/tech_docs/ACS_2018_SF_5YR_Appendices.xls>
################################################################################ #
