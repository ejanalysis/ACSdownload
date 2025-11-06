#' @title Read and concatenate state geo files from Census ACS
#'
#' @description Reads and merges geo files that have been obtained from the US Census Bureau FTP site for American Community Survey (ACS) data.
#'   It uses read.fwf() at least for older years.
#'
#' @details
#'   Note that if this finds the geographic file in folder already, it will not download it again even if that file was corrupt.
#'   Extracts just block group (SUMLEVEL=150) and tract (SUMLEVEL=140) geo information (not county info., since data files used in this package lack county info.)
#'   The NAME field works on pc but mac can hit an error if trying to read the NAME field. Due to encoding? specifying encoding didn't help.\cr
#'   (name is very long and not essential)\cr
#'   Error in substring(x, first, last) : \cr
#'   invalid multibyte string at '<f1>onc<69>to Chapter; Navajo Nation Reservation and Off-Reservation Trust Land, AZ--NM--UT \cr
#'   Format of files is here: <ftp://ftp.census.gov/acs2012_5yr/summaryfile/ACS_2008-2012_SF_Tech_Doc.pdf>
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
#' @seealso [get.acs()], [download.geo()]
#' @export
read.geo <-
  function(mystates,
           folder = getwd(),
           end.year = acsdefaultendyearhere_func(),
           silent = FALSE) {
    ############# #
    # concatenate geos over all states
    ############# #


    validate.end.year(end.year)

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
      x2021 = geoformat2021
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
