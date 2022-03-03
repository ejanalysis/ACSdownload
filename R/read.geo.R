#' @title Read and concatenate state geo files from Census ACS
#'
#' @description Reads and merges geo files that have been obtained from the US Census Bureau FTP site for American Community Survey (ACS) data.
#'   It uses read.fwf() at least for older years. 2018 or 2019 might have csv not just txt format now?
#'   
#' @details
#'   Note that if this finds the geographic file in folder already, it will not download it again even if that file was corrupt.
#'   Extracts just block group (SUMLEVEL=150) and tract (SUMLEVEL=140) geo information (not county info., since data files used in this package lack county info.)
#'   The NAME field works on pc but mac can hit an error if trying to read the NAME field. Due to encoding? specifying encoding didn't help.\cr
#'   (name is very long and not essential)\cr
#'   Error in substring(x, first, last) : \cr
#'   invalid multibyte string at '<f1>onc<69>to Chapter; Navajo Nation Reservation and Off-Reservation Trust Land, AZ--NM--UT \cr
#'   Format of files is here: \code{\url{ftp://ftp.census.gov/acs2012_5yr/summaryfile/ACS_2008-2012_SF_Tech_Doc.pdf}}
#' @param mystates Character vector of one or more states/DC/PR, as 2-character state abbreviations. Default is all states/DC/PR.
#' @param folder Optional path to where files are stored, defaults to getwd()
#' @param end.year End year of 5-year data, like "2018"
#' @param silent Default is FALSE. Whether to send progress info to standard output.
#' @return Returns a large data.frame of selected geographic information on
#'   all block groups and tracts in the specified states/DC/PR, with just these fields:\cr
#'   "STUSAB", "SUMLEVEL", "LOGRECNO", "STATE", "COUNTY", "TRACT", "BLKGRP", "GEOID"
#' @examples
#'  \dontrun{
#'   geo <- read.geo( c("dc", "de") )
#'  }
#' @seealso \code{\link{get.acs}}, \code{\link{download.geo}}
#' @export
read.geo <-
  function(mystates,
           folder = getwd(),
           end.year = acsdefaultendyearhere_func(),
           silent = FALSE) {
    ############# #
    # concatenate geos over all states
    ############# #
    
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
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    geoformat <- switch(
      paste('x', end.year, sep = ''),
      x2009 = geoformat2009,
      x2010 = geoformat2010,
      x2011 = geoformat2011,
      x2012 = geoformat2012,
      x2013 = geoformat2013,
      x2014 = geoformat2014,
      x2015 = geoformat2015,
      x2016 = geoformat2016,
      x2017 = geoformat2017,
      x2018 = geoformat2018,
      x2019 = geoformat2019,
      x2020 = geoformat2020,
      x2021 = geoformat2021,
      x2022 = geoformat2022
      )
    
    # just import these:
    #	(name is very long and not essential)
    # 	LOGRECNO IS ESSENTIAL FOR JOIN TO DATA FILES OR TIGER SHAPEFILES
    
    #	geofields <- c(
    #		"SUMLEVEL", "LOGRECNO", "STATE", "COUNTY", "TRACT", "BLKGRP", "GEOID", "NAME"
    #	)
    
    #	THE NAME FIELD IS PROBLEMATIC / ENCODING PROBLEM? ON MAC OSX, AND NOT ESSENTIAL SO DROP IT:
    geofields <- c("STUSAB",
                   "SUMLEVEL",
                   "LOGRECNO",
                   "STATE",
                   "COUNTY",
                   "TRACT",
                   "BLKGRP",
                   "GEOID")
    
    #  THESE COULD BE DROPPED ALSO AT LEAST AFTER THE KEY FIELD IS CREATED:
    #  LOGRECNO STATE COUNTY  TRACT BLKGRP
    
    getwidths <- function(geofields, geoformat) {
      mygeoformat <-
        geoformat[which(geoformat$varname %in% geofields), c("start", "size")]
      lastcell <-
        max(geoformat$start) + geoformat$size[which(geoformat$start == max(geoformat$start))]
      mywidths <- vector()
      for (i in 1:length(mygeoformat[, 1])) {
        # create the first entry in the list of widths
        if (i == 1) {
          if (mygeoformat$start[i] > 1) {
            # I don't want the first field, so skip all before 1st wanted via negative width
            mywidths <- -1 * (mygeoformat$start[i] - 1)
            # specify width of this first desired field
            mywidths <- c(mywidths, mygeoformat$size[i])
          } else {
            # I do want the first field, so just use this one's width as the 1st width
            mywidths <- mygeoformat$size[i]
          }
        } else {
          # create subsequent entries in list of widths
          # append to prior widths a negative for any intervening columns to drop & then append this width
          cells.to.drop.since.last <-
            mygeoformat$start[i] - sum(abs(mywidths)) - 1
          if (cells.to.drop.since.last > 0) {
            mywidths <- c(mywidths, -1 * cells.to.drop.since.last)
          }
          mywidths <- c(mywidths, mygeoformat$size[i])
        }
      }
      # add the last entry to skip any remaining columns
      mywidths <- c(mywidths, -1 * (lastcell - sum(abs(mywidths))))
      return(mywidths)
    }
    
    
    gfiles.not.us <- geofile(mystates, end.year = end.year)
    # REMOVE THE US NATIONWIDE GEO FILE IN CASE THE USER SPECIFIED IT (SINCE IT DOESN'T ACTUALLY HAVE BLOCK GROUPS AND TRACTS)
    gfiles.not.us <-
      gfiles.not.us[gfiles.not.us != geofile("us", end.year = end.year)]
    
    bigtable.g <- data.frame()
    #cat('  Parsing geo files:\n')
    
    i <- 1
    for (this.file in gfiles.not.us) {
      #cat(this.file)
      if (!silent) {
        cat(mystates[mystates != 'us'][i], ' ')
      }
      i <- i + 1
      
      
      # NOTE: SPECIAL CHARACTERS IN THIS FILE ARE A PROBLEM FOR MAC OSX:
      # It seems to be Latin1 encoding, but OSX had trouble reading NAME field despite specifying encoding
      # also tried  fileEncoding="latin1"
      
      this.data <- read.fwf(
        file.path(folder, this.file),
        widths = getwidths(geofields, geoformat),
        as.is = TRUE,
        header = FALSE,
        fileEncoding = "ISO-8859-1",
        encoding = "ISO-8859-1",
        strip.white = TRUE,
        nrows = 295000,
        comment.char = "",
        colClasses = rep("character", length(geofields))
      )
      
      if (length(this.data[, 1]) == 0) {
        stop(paste('Problem reading file', this.file))
      }
      
      names(this.data) <- geofields  # only for imported fields
      
      # Drop all rows except for tract and block group, from this geo table. Block group is SUMLEVEL 150.
      this.data <-
        this.data[this.data$SUMLEVEL == "140" |
                    this.data$SUMLEVEL == "150" ,]
      
      if (length(this.data[, 1]) == 0) {
        stop(paste('Problem reading file', this.file))
      }
      
      # Append this state to the others imported so far
      bigtable.g <- rbind(bigtable.g, this.data)
    }
    if (!silent) {
      cat('\n')
    }
    return(bigtable.g)
  }
