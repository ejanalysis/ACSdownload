#' @title get ACS summaryfile specified tables for entire USA, all blockgroups or all tracts
#' @description Uses Census Bureau new format files that offer the full USA in 1 file per table,
#'   via FTP or https.
#'   Does not get Puerto Rico (PR) as coded.
#'   Note API provides better list of variable names, in order as found on summary files, than documentation does.
#' @param tables 'ejscreen' or else one or more table codes like 'b01001' or c("B01001", "B03002")
#' @param end.year 2020 or another available year
#' @param dataset default is 5, for 5-year summary file data like 2016-2020 ACS
#' @param sumlevel default is 150 for blockgroups. 140 is tracts.
#' @param output.path folder / path where to save the downloaded files
#'
#' @return list of data.frames, one per table requested
#' 
#' @export
#'
get.acs.all <- function(tables="B01001", end.year=2020, dataset='5', sumlevel=150, output.path = file.path('~', 'acsoutput') ) {
  # new format for 5yr summary file ACS
  # makes it easier to get one table for every blockgroup in the US

  # table_for_sumlevel
  ejscreentables <- c("B01001", "B03002", "B15002", "C16002", "C17002", "B25034", 'B23025') # added B23025 unemployement
  # ACSdownload::get.table.info(c("B01001", "B03002", "B15002", "C16002", "C17002", "B25034", 'B23025'))
  # C16002 replaced B16004 that was older ACS source for what had been called linguistic isolation, now called limited English speaking households.
  # if tables equals or contains 'ejscreen' then replace the 'ejscreen' part with the default tables as follows, leaving any other tables specified in addition to ejscreen tables:
  if (any(tolower(tables) == 'ejscreen')) {
    tables <- c(ejscreentables, tables[tolower(tables) != 'ejscreen'])
  }
  # 1    B03002    1 B03002.001                                                       Total:
  # 2    B03002    2 B03002.002     Not Hispanic or Latino:
  #   3    B03002    3 B03002.003                                                  White alone
  #   4    B03002    4 B03002.004                              Black or African American alone
  #   5    B03002    5 B03002.005                      American Indian and Alaska Native alone
  #   6    B03002    6 B03002.006                                                  Asian alone
  #   7    B03002    7 B03002.007             Native Hawaiian and Other Pacific Islander alone
  #   8    B03002    8 B03002.008                                        Some other race alone
  #   9    B03002    9 B03002.009                                           Two or more races
  #   12   B03002   12 B03002.012   Hispanic or Latino

    # end.year = acsdefaultendyearhere_func()
  end.year <- as.character(end.year)
  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(2016:(thisyear - 1)))) {stop('end.year must be a plausible year')}

  # python example:
  #   https://github.com/uscensusbureau/acs-summary-file/blob/master/Python/example2.py
  #   https://github.com/uscensusbureau/acs-summary-file/wiki/Python-Table-Data-for-All-Tracts

  # 'https://www2.census.gov/programs-surveys/acs/summary_file/2020/prototype/5YRData/'
  # ftpsite <- "ftp2.census.gov"
  # list_files_ftp('ftp://ftp2.census.gov/acs_latest_data/summary_file/2020/prototype/5YRData')
  # 'https://www2.census.gov/programs-surveys/acs/summary_file/2020/prototype/5YRData/acsdt5y2020-b01001.dat'

  baseurl <- 'ftp://ftp2.census.gov/acs_latest_data/summary_file/{year}/prototype/{dataset}YRData'
  # 'https://www2.census.gov/programs-surveys/acs/summary_file/'
  baseurl <- gsub('\\{year\\}', end.year, baseurl)
  baseurl <- gsub('\\{dataset\\}', dataset, baseurl)
  httpurl <- gsub('ftp://ftp2', 'https://www2', baseurl)

  files <- list_files_ftp(baseurl)
  files <- grep(pattern = '\\.dat$', x=files, value=TRUE) # almost all the files are .dat
  # files provides full paths including filename

  if (!('*' %in% tables)) {
    wanted <- paste0(baseurl, '/acsdt5y', end.year, '-', tolower(tables), '.dat')
    # fullpath incl filename

    notfound <- setdiff(wanted, files)
    if (length(notfound) > 0) {message(paste0('Not found: ', paste(notfound, collapse = ', ')))}
    wanted <- intersect(wanted, files) # just try to download the available ones
  } else {
    # keep them all
  }

  if (!dir.exists(output.path)) {dir.create(output.path)}

  wanted_https <- gsub('ftp://ftp2', 'https://www2', wanted)
  x <- list()
  for (i in seq_along(wanted)) {
    # but note (http faster than ftp)
    #
    # this could be more robust code, check for failed download and retry, etc.
    # downloading part seems very slow !  >6 minutes for all US blockgroupsu for just 1 table, reading from file as it downloads
    # but read_delim() is very fast and read.delim is good enough.
    # x[[i]] <- readr::read_delim(wanted[i], delim = '|')

    x[[i]] <- read.delim(wanted[i], sep = '|')

    # or if already downloaded:
    # x[[i]] <- read.delim(file.path(output.path, gsub(paste0(baseurl,'/'),'', wanted[i])), sep = '|')


    # x <- try(
    #   download.file(
    #     # url = wanted_https[i],  # does not work via https, just ftp for some reason. maybe epa proxy issues?
    #     url = wanted[i],
    #     destfile = file.path(output.path, gsub(paste0(baseurl,'/'),'', wanted[i]))
    #   )
    # )

    # retain only blockgroups if sumlevel is 150, tracts if it is 140.
    x[[i]] <- x[[i]][substr(x[[i]][, 'GEO_ID'], 1, 3) == sumlevel, ]

    x[[i]]$FIPS   <- substr(x[[i]][, 'GEO_ID'], 10, 21)

    readr::write_csv(x[[i]], file = paste0(tables[i], '.csv')) # should really ensure this is same as current table
  }

# these files do include PR and DC but no Island Territories.

  # assumes all were found:
  names(x) <- tolower(tables)
  save(x, file.path(output.path, 'acsdata.rda'))
  invisible(x)
}


