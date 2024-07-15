#' @title Download File with Information about ACS 5-Year Summary File Tables
#'
#' @description
#'   Download and read lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
#'   namely which sequence files on the FTP site contain which tables and which variables.
#'   NOTE: This is largely obsolete now that data(lookup.acs2013) and similar files for other years are in this package.
#' @details
#'
#' For information on new Summary File format visit:
#'
#'  https://www.census.gov/programs-surveys/acs/data/summary-file.html
#'
#'     Lookup table of sequence files and variables was here:  \cr
#'  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt>  \cr
#'  \cr\cr
#'   The 2014-2018 folders are here:  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/geography/>  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/user_tools/>  \cr
#'  \cr
#'     Data tables by state by seqfile were here:  \cr
#'  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Alabama/Tracts_Block_Groups_Only/>  \cr
#'   such as  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Alabama/Tracts_Block_Groups_Only/20175al0001000.zip>  \cr
#'  \cr
#'     Geographies in Excel spreadsheets were here:  \cr
#'  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/geography/5yr_year_geo/>  \cr
#'   such as  \cr
#'   <https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/geography/5yr_year_geo/ak.xlsx>  \cr
#' @param end.year Character, optional, like '2020', which specifies the 2016-2020 dataset.
#'   Defines which 5-year summary file to use, based on end-year.
#'   Can be acsfirstyearavailablehere or later. Data for end.year='2019' were released in December 2020, for example.
#'   The 2017-2021 American Community Survey 5-year estimates are scheduled to be released on Thursday, December 8, 2022.
#'
#' @param folder Optional path to where to download file to, defaults to temp folder.
#' @param silent Optional, default is FALSE. Whether to send progress info to standard output (like the screen)
#' @return By default, returns a data.frame with these fields:
#'   \itemize{
#'     \item $ Table.ID               : chr  "B00001" "B00001" "B00001" "B00002" ...
#'     \item $ Sequence.Number        : chr  "0001" "0001" "0001" "0001" ...
#'     \item $ Line.Number            : num  NA NA 1 NA NA 1 NA NA 1 2 ...
#'     \item $ Start.Position         : num  7 NA NA 8 NA NA 7 NA NA NA ...
#'     \item $ Total.Cells.in.Table   : chr  "1 CELL" "" "" "1 CELL" ...
#'     \item $ Total.Cells.in.Sequence: num  NA NA NA 2 NA NA NA NA NA NA ...
#'     \item $ Table.Title            : chr  "UNWEIGHTED SAMPLE COUNT OF THE POPULATION" "Universe:  Total population" "Total" "UNWEIGHTED SAMPLE HOUSING UNITS" ...
#'     \item $ Subject.Area           : chr  "Unweighted Count" "" "" "Unweighted Count" ...
#'   }
#'   For ACS 2008-2012: \cr
#'   length(my.lookup[,1]) \cr
#'   [1] 24741\cr
#'   names(my.lookup)\cr
#'   [1] "File.ID"                 "Table.ID"                "Sequence.Number"         "Line.Number"             "Start.Position"\cr
#'   [6] "Total.Cells.in.Table"    "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"\cr
#' @seealso [acs::acs.lookup()] which does something similar but is more flexible & robust.
#'   Also see [get.lookup.acs()] which does the same without downloading file -- uses the copy in data()
#'   Also see `data(lookup.acs2013)` and similar data for other years.
#'   Also see [get.acs()], [get.lookup.file.name()], [get.url.prefix.lookup.table()]
#' @examples
#'  \dontrun{
#'  lookup.acs <- download.lookup.acs(2022)
#'  }
#'
download.lookup.acs <- function(end.year = acsdefaultendyearhere_func(),
                                folder = NULL,
                                silent = FALSE) {

  ########################################################### #

  # folder to download to ####

  if (missing(folder)) {
    folder = tempdir()
    folder = file.path(folder, "acs")
    if (!dir.exists(folder)) {
    dir.create(folder)
      }

    # Use a temp directory to download the file.
  }
  oldir = getwd()
  on.exit(setwd(oldir))
  setwd(folder)

  ######################## #

  # end.year ####
  validate.end.year(end.year)

# xxxxx

  # urlx = get(paste0("url", substr(end.year,3,4)))
  # filex = paste0(end.year, "_ACS5_lookup.txt")
  # lookx = paste0("lookup.acs", end.year)

# xxxxx

  my.url.prefix.lookup.table <-
    get.url.prefix.lookup.table(end.year)

  my.lookup.file.name <- get.lookup.file.name(end.year)
  my.lookup.file.name.dated <-
    paste(end.year, my.lookup.file.name, sep = '')
  print(my.lookup.file.name.dated)

  ########################################################### #

  # download it ####

  if (!file.exists(file.path(folder, my.lookup.file.name.dated)) |
      file.size(file.path(folder, my.lookup.file.name.dated)) == 0) {

    if (!silent) {
      cat(
        "  Downloading lookup table with table and variable names from",

        # paste(my.url.prefix.lookup.table, my.lookup.file.name, sep = ""),
        "\n"
      )
    }
    try(
      # download.file(urlx, destfile = filex)

      download.file(
        paste(my.url.prefix.lookup.table, my.lookup.file.name, sep = ""),
        file.path(folder, my.lookup.file.name.dated)
      )
    )

    if (!file.exists(file.path(folder, my.lookup.file.name.dated)) |
        file.size(file.path(folder, my.lookup.file.name.dated)) == 0) {
      stop('Failed to download lookup table of variable names by table')
    }
    # could add error checking here to verify it was downloaded correctly
  }

  if (!silent) {
    cat("  Reading lookup table with table and variable names\n")
  }
  ########################################################### #

  #  clean it

  ########################################################### #
  if (end.year == 2009) {
    # The 2009 table was provided as xls not txt. Other years have a txt file with this info.
    # colnames are the same but read_excel imports it differently than read.csv does
    #2012:  [File ID,]Table ID, Sequence Number,  Line Number, Start Position,  Total Cells in Table, Total Cells in Sequence,  Table Title, Subject Area
    #2009:  File ID,	Table ID,	Sequence Number,	Line Number, Start Position,	Total Cells in Table,	Total Cells in Sequence,	Table Title, Subject Area
    my.lookup <- readxl::read_excel(
      file.path(folder, my.lookup.file.name.dated),
      col_types = c(
        "text",
        "text",
        "text",
        "numeric",
        "numeric",
        "text",
        "numeric",
        "text",
        "text"
      )
    )
    # replace spaces with periods in colnames, which read.csv does automatically but read_excel does not:
    names(my.lookup) <- gsub(' ', '.', names(my.lookup))
    # remove the last row, which gets imported as <NA> and NA values
    my.lookup <- my.lookup[!is.na(my.lookup$Table.ID),]
    # The 2009 file has NA values instead of blanks in some columns
    my.lookup$Subject.Area[is.na(my.lookup$Subject.Area)] <- ''
    my.lookup$Total.Cells.in.Table[is.na(my.lookup$Total.Cells.in.Table)] <-
      ''

  } else {
    if (end.year == 2011) {
      # 2011 format was different:
      #"fileid","Table ID","seq",   "Line Number Decimal M Lines", "position", "cells",   "total","Long Table Title","subject_area"
      #"ACSSF","B00001","0001",   ".", "7","1 CELL",    ".", "UNWEIGHTED SAMPLE COUNT OF THE POPULATION", "Unweighted Count"
      my.lookup <- read.csv(
        file.path(folder, my.lookup.file.name.dated),
        stringsAsFactors = FALSE,
        colClasses = c(
          "character",
          "character",
          "character",
          "character",
          "character",
          "character",
          "character",
          "character",
          "character"
        )
      )
      names(my.lookup) <-
        c(
          'File ID',
          'Table ID',
          'Sequence Number',
          'Line Number',
          'Start Position',
          'Total Cells in Table',
          'Total Cells in Sequence',
          'Table Title',
          'Subject Area'
        )
      names(my.lookup) <- gsub(' ', '.', names(my.lookup))

      my.lookup$Line.Number[my.lookup$Line.Number == '.'] <- NA
      my.lookup$Line.Number <- as.numeric(my.lookup$Line.Number)
      my.lookup$Total.Cells.in.Sequence[my.lookup$Total.Cells.in.Sequence ==
                                          '.'] <- NA
      my.lookup$Total.Cells.in.Sequence <-
        as.numeric(my.lookup$Total.Cells.in.Sequence)
      my.lookup$Start.Position[my.lookup$Start.Position == '.'] <-
        NA
      my.lookup$Start.Position <-
        as.numeric(my.lookup$Start.Position)

    } else {
      if (end.year > 2011 & end.year < 2022) {
        #e.g., 2012:  [File ID,]Table ID, Sequence Number,  Line Number, Start Position,  Total Cells in Table, Total Cells in Sequence,  Table Title, Subject Area
        my.lookup <- read.csv(
          file.path(folder, my.lookup.file.name.dated),
          stringsAsFactors = FALSE,
          colClasses = c(
            "character",
            "character",
            "character",
            "numeric",
            "numeric",
            "character",
            "numeric",
            "character",
            "character"
          )
        )
      } else {
        # end.year is 2022 or later

        my.lookup <- read.delim(file.path(folder, my.lookup.file.name.dated), sep = "|")

        # See [https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/]

      }
    }
  }
  # done cleaning it
  ########################################################### #

  if (end.year < 2021) {
    # add leading zeroes so seqnum always has 4 characters (e.g., '0001' or '0105')
    my.lookup$File.ID <- NULL
    my.lookup$Sequence.Number <-
      analyze.stuff::lead.zeroes(floor(as.numeric(my.lookup$Sequence.Number)), 4)
  }


  return(my.lookup)
}
