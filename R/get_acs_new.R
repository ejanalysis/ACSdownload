
####################################### ######################################## #


# DATA ####
####################################### ######################################## #


# to download/read the ACS 5year data (2018-2022 survey or later) for selected tables and selected fips or fipstype

#' Get full USA ACS data by table and fips (newer table-based summary file format)
#'
#' Downloads ACS 5-year data for selected tables and fips or fipstype.
#'
#' @param tables vector of ACS data table numbers like "B01001" etc.
#'   Note some tables used by EJSCREEN are only available at tract resolution, namely
#'   "C16001" for detailed specific languages as % of residents, and "B18101" for % with disability.
#'   All resolutions get returned if return_list_not_merged=TRUE, but not if FALSE,
#'   since those tables would prevent clearcut merging to a single table of places based on fips.
#'
#' @param fips "blockgroup" for all US bg, or a vector of fips codes.
#'   can also be "county", "state", "tract", or vector of one of those fips code types.
#'   May support these but untested: "REGION", "American Indian Area/Alaska Native Area/Hawaiian Home Land",
#'   "MSA", "CSA", "Urban Area", "Congressional District", "ZCTA".
#'   If a fips type (e.g., "tract"), defines the SUMLEVEL variable in the ACS data (e.g., "140").
#' @param yr end year of 5 year ACS summary file data, such as 2023 for the 2019-2023 survey released by Census Bureau Dec. 2024.
#' @param fiveorone optional 1 or 5, where 5 is the 5-year sample - only 5-yr tested here
#' @param return_list_not_merged set to FALSE means return a single merged table from all the requested ACS tables, and
#'   otherwise a list of data.tables. See "tables" parameter for more.
#'
#' @returns list of tables or merged single table, with estimates and margins of error and fips and SUMLEVEL
#' @examples
#'  x = get_acs_new(yr=2022, tables = ejscreen_acs_tables[1],
#'    fips="county")
#'  x[[1]]
#'
#'  # acs22 = get_acs_new(yr=2022, tables = ejscreen_acs_tables )
#'  # acs23 = get_acs_new(yr = 2023, return_list_not_merged = FALSE)
#'
#'  \dontrun{
#'    ##### EXAMPLE OF GETTING ACS DATA
#'    ##### FOR ALL US BLOCKGROUPS AND CALCULATING INDICATORS
#'
#'    ### See more complete code for this in the EJAM package!
#'    ## -- below is just a very simplified look:
#'
#'    library(EJAM)
#'    library(data.table)
#'
#'    # x <- get_acs_new() # has problem where not all tables have same number of rows
#'    # even for the blockgroup ones, and last 2 tables are tract resolution
#'    ## so this is easier for getting the bg part:
#'
#'    bg     <- get_acs_new(tables = ejscreen_acs_tables[1:13], return_list_not_merged = FALSE)
#'
#'    acsdata <- list()
#'    acsdata <- EJAM::calc_ejam(
#'      bg,
#'      formulas = EJAM::formulas_ejscreen_acs$formula,
#'          keep.old = c("fips", "pop")
#'    )
#'    data.table::setnames(acsdata, "fips", "bgfips")
#'
#'    #  dput(setdiff(names(acsdata) , names(blockgroupstats)) )
#'
#'    keep <- intersect(names(acsdata), names(EJAM::blockgroupstats))
#'    acsdata <- acsdata[ , .SD, .SDcols = keep]
#'
#'    t(acsdata[1:2,])
#'
#'    # save(acsdata, file = "~/Downloads/acs2023 bg via just ACSdownload pkg example.rda")
#'  }
#'
#' @export
#'
get_acs_new = function(
    tables = ejscreen_acs_tables,
    fips = "blockgroup", # related to sumlevel. note it has no space in it, unlike in tidycensus variable info table
    yr = acsdefaultendyearhere, # e.g., 2023 until 12/2025, then 2024
    fiveorone = '5',
    return_list_not_merged = TRUE
)  {

  stopifnot(length(fiveorone) == 1, nchar(fiveorone) == 1, as.character(fiveorone) %in% c("1", "5"))
  #oldtimeout = options("timeout")
  #options("timeout") <- 120
  #on.exit({options("timeout") <- oldtimeout})

  # also see # EJAM:::acs_bybg()

  ## file name examples
  # [   ]	acsdt5y2022-b06004bpr.dat	2023-10-30 12:34	184K
  # [   ]	acsdt5y2022-b06004c.dat	2023-10-30 12:34	13M
  # [   ]	acsdt5y2022-b06004cpr.dat	2023-10-30 12:34	166K
  # [   ]	acsdt5y2022-b06004d.dat	2023-10-30 12:34	14M
  # [   ]	acsdt5y2022-b06004dpr.dat	2023-10-30 12:34	166K
  # [   ]	acsdt5y2022-b06004e.dat	2023-10-30 12:34	13M
  # [   ]	acsdt5y2022-b06004epr.dat	2023-10-30 12:34	163K
  tables = tolower(tables)
  # url_dat = "https://www2.census.gov/programs-surveys/acs/summary_file/2023/table-based-SF/data/5YRData/"
  # url_dat = "https://www2.census.gov/programs-surveys/acs/summary_file/2023/table-based-SF/data/1YRData/"

  url_dat = paste0("https://www2.census.gov/programs-surveys/acs/summary_file/", yr, "/table-based-SF/data/", fiveorone,"YRData/")
  dfiles = paste0("acsdt", fiveorone,"y", yr, "-", tables, ".dat")
  tablist = list()
  for (i in seq_along(dfiles)) {
    dpath = paste0(url_dat, dfiles[i])

    ## download to tempdir() and read ####

    tablist[[i]] <- data.table::fread(dpath, showProgress = TRUE)

    tablist[[i]]$fips <- fips_from_geoid(tablist[[i]]$GEO_ID)
    tablist[[i]]$SUMLEVEL <- sumlevel_from_geoid(tablist[[i]]$GEO_ID)
    # put these columns first:
    data.table::setcolorder(tablist[[i]], c('GEO_ID', 'fips', 'SUMLEVEL'))
  }
  if (length(tables) != length(tablist)) {
    warning("Not all requested tables were obtained.")
  }

  # could filter to just selected variables in each table here or elsewhere

  if (is.null(fips)) {
    # no fips filtering, but user would have to have passed fips=NULL since default is not NULL
  } else {
    ###################### #
    # sumlevel[ftype %in% "REGION"] <- "20"
    # sumlevel[ftype %in% "American Indian Area/Alaska Native Area/Hawaiian Home Land"] <- "250"
    # sumlevel[ftype %in% "MSA"] <- "310"
    # sumlevel[ftype %in% "CSA"] <- "330"
    # sumlevel[ftype %in% "Urban Area"] <- "400"
    # sumlevel[ftype %in% "Congressional District"] <- "500"
    # sumlevel[ftype %in% "ZCTA"] <- "860"
    ###################### #
    # could filter to just selected rows/geographies, either by type of fips or  vector of specific fips
    if (fips[1] %in% c("block", "blockgroup", "tract", "city", "county", "state",
                       "REGION", "American Indian Area/Alaska Native Area/Hawaiian Home Land",
                       "MSA", "CSA", "Urban Area", "Congressional District", "ZCTA"
    )) {
      if (length(fips) > 1) {stop("can get only 1 type of geography / sumlevel at a time, such as 'blockgroup' ")}
      sumlevel = sumlevel_from_fipstype(fips)
      for (i in seq_along(dfiles)) {
        tablist[[i]] <- tablist[[i]][SUMLEVEL %in% sumlevel, ]
      }
    } else {
      fipscodes_requested <- fips
      for (i in seq_along(dfiles)) {
        tablist[[i]] <- tablist[[i]][fips %in% fipscodes_requested, ]
        ## but do we want to retain order of fips requested?

      }
    } # end of fips filter
    ###################### #
  }
  # Rename estimate columns to work well with formulas_ejscreen_acs$formulas.
  # Census table-based summary file columns look like "B01001_E001" (estimate)
  # and "B01001_M001" (margin of error); strip the "E" only when it sits between
  # the underscore and the trailing numeric variable index, to avoid touching
  # any unrelated column names that happen to contain "_E".
  for (i in seq_along(tablist))  {
    names(tablist[[i]]) <- gsub("_E([0-9]+)$", "_\\1", names(tablist[[i]]))
  }

  names(tablist) <- toupper(as.vector(tables))

  rowcounts <- sapply(tablist, NROW)
  sumlevels <- unlist(sapply(tablist, function(z) unique(z$SUMLEVEL)))


  if (return_list_not_merged) {
    if (length(unique(sumlevels)) > 1) {warning("tables are at differing spatial resolutions like block group vs tract")}
    if (any(rowcounts %in% 0)) {
      warning("Some tables had zero rows")
      cat("These tables had zero rows: ", paste0(names(tablist)[rowcounts %in% 0], collapse = ", "), "\n")
    }
    if (length(unique(rowcounts)) > 1) {
      warning("note: not every table had the same number of rows (places)")
      cat("Row counts of tables: \n")
      print(data.frame(table = names(tablist), rowcount = rowcounts, note = ifelse(rowcounts != rowcounts[1], "**", "")))
    }
    return(tablist)

  } else {

    # try join all the tables to get 1 column per variable all in 1 table, or
    # perhaps could even use cbind if we know GEOIDS are identical across tables but they are not if resolution available varies like if fips=NULL
    # but if we did filter to limit based on fips that will result in all being the same sumlevel, so should be same length and probably identical geoids, but do join to be safe

    if (length(unique(sumlevels)) > 1) {stop("this function will not merge tables that are at differing spatial resolutions like block group vs tract")}
    if (any(rowcounts %in% 0)) {
      warning("Some tables had zero rows - omitting those")
      cat("These tables had zero rows: ", paste0(names(tablist)[rowcounts %in% 0], collapse = ", "), "\n")
      tablist = tablist[rowcounts > 0]
      rowcounts <- sapply(tablist, NROW)
      sumlevels <- unlist(sapply(tablist, function(z) unique(z$SUMLEVEL)))
    }
    if (length(tablist) == 0) {
      stop("No tables to merge after removing zero-row tables")
    }
    if (length(unique(rowcounts)) > 1) {
      warning("caution: not every table being merged had the same number of rows (places)")
      cat("Row counts of tables: \n")
      print(data.frame(table = names(tablist), rowcount = rowcounts, note = ifelse(rowcounts != rowcounts[1], "**", "")))
    }

    tabmerged <- tablist[[1]]

    if (length(tablist) > 1) {
      for (i in 2:length(tablist)) {
        x <- tablist[[i]]
        # avoid duplicating shared columns not used as merge key
        x[, GEO_ID := NULL]
        x[, SUMLEVEL := NULL]
        tabmerged <- merge(tabmerged, x, by = "fips")
      }
    }

    return(tabmerged)
  }
}
####################################### ######################################## #
####################################### ######################################## #

# to get the geography names AND also get the ACS 5year data for selected tables and fips or fipstype

#' Get geography names and ACS 5-year data for selected tables and fips or fipstype
#'
#' @param tables vector of ACS data table numbers like "B01001" etc. and if NULL, uses defaults of [get_acs_new()]
#' @param fips "blockgroup" for all US bg, or a vector of fips codes.
#'   can also be "county", "state", "tract", or vector of one of those fips code types.
#'   If a fips type, defines the SUMLEVEL variable in the ACS data, such as 140 for tracts.
#' @param yr end year of 5 year ACS summary file data, such as 2023 for the 2019-2023 survey released by Census Bureau Dec. 2024.
#' @param fiveorone optional 1 or 5, where 5 is the 5-year sample - only 5-yr tested here
#'
#' @returns list of geos + dat, with estimates and margins of error and fips and SUMLEVEL
#'
#' @keywords internal
#'
get_acs_new_both = function(
    tables = NULL,
    fips = "blockgroup",
    yr = acsdefaultendyearhere, # e.g., 2023 until 12/2025, then 2024
    fiveorone = 5) {

if (is.null(tables)) {
  dat  <- get_acs_new(fips = fips, yr = yr, fiveorone = fiveorone)
} else {
  dat  <- get_acs_new(fips = fips, yr = yr, fiveorone = fiveorone, tables = tables)
}
  geos <- get_acs_new_geos(fips = fips, yr = yr)

  # length(dat)
  # sapply(dat, NROW)
  # sapply(dat, NCOL)
  # names(dat[[1]])
  #   (dat[[1]])[1:5, 1:10]

  ########### #
  # JOIN on GEO_ID? ####

  return(list(geos = geos, dat = dat))
}
####################################### ######################################## #

# GEOGRAPHIES ####

# to get the geography names for selected fips or fipstype

#' Get the geography names (and fips/SUMLEVEL) for selected fips or fipstype
#'
#' @param yr end year of 5 year ACS summary file data, such as 2023 for the 2019-2023 survey released by Census Bureau Dec. 2024.
#' @param fips "blockgroup" for all US bg, or a vector of fips codes.
#'   can also be "county", "state", "tract", or vector of one of those fips code types
#'
#' @returns table with geographies - names and fips and SUMLEVEL
#'
#' @keywords internal
#'
get_acs_new_geos = function(
    yr = acsdefaultendyearhere, # e.g., 2023 until 12/2025, then 2024
    fips = "blockgroup") {

  url_geos = paste0("https://www2.census.gov/programs-surveys/acs/summary_file/",
                    yr, "/table-based-SF/documentation/Geos", yr, "5YR.txt")
  geos = data.table::fread(url_geos)

  # Add fips column up front so it can be referenced by the filters below.
  geos[ , fips := fips_from_geoid(GEO_ID)]

  ###################### #
  # could filter to just selected rows/geographies, either by type of fips or  vector of specific fips
  if (!is.null(fips)) {
    if (fips[1] %in% c("block", "blockgroup", "tract", "city", "county", "state",
                       "REGION", "American Indian Area/Alaska Native Area/Hawaiian Home Land",
                       "MSA", "CSA", "Urban Area", "Congressional District", "ZCTA"
    )) {
      # if (length(fips) > 1) {stop("can get only 1 type of geography / sumlevel at a time, such as 'blockgroup' ")}
      sumlevel = sumlevel_from_fipstype(fips)
      geos <- geos[SUMLEVEL %in% sumlevel, ]
    } else {
      fipscodes_requested <- fips
      geos <- geos[fips %in% fipscodes_requested, ]
      ## but do we want to retain order of fips requested?

    } # end of fips filter
    ###################### #
  }

  geos = geos[ , .(STUSAB, SUMLEVEL, GEO_ID, fips)]

  return(geos)
}
####################################### ######################################## #

# helper functions for ACS/Census geographies etc.

####################################### ######################################## #

# try to get fips code but that is not possible given ONLY the right hand part of GEO_ID
# -- you need to check sumlevel in left half of geoid,
# or you could even join to geos to distinguish between 5 character Zip vs County, e.g.
# and various other ambiguous cases

sumlevel_from_geoid = function(geoid) {
  sumlevel = gsub("^(...).*US(.*)", "\\1", geoid)
  return(sumlevel)
}
####################################### ######################################## #

# see  EJAM::fips_lead_zero()

fips_lead_zero_acs = function (fips, quiet = TRUE) {

  just_numerals = function(x) {
    !grepl("[^0123456789]", x)
  }
  fips[!just_numerals(fips)] <- NA
  fips[nchar(fips, keepNA = FALSE) == 0] <- NA
  fips[nchar(fips, keepNA = FALSE) == 1] <- paste0("0", fips[nchar(fips,
                                                                   keepNA = FALSE) == 1])
  fips[nchar(fips, keepNA = FALSE) == 3] <- NA
  fips[nchar(fips, keepNA = FALSE) == 4] <- paste0("0", fips[nchar(fips,
                                                                   keepNA = FALSE) == 4])
  fips[nchar(fips, keepNA = FALSE) == 6] <- paste0("0", fips[nchar(fips,
                                                                   keepNA = FALSE) == 6])
  fips[nchar(fips, keepNA = FALSE) == 8] <- NA
  fips[nchar(fips, keepNA = FALSE) == 9] <- NA
  lens = nchar(fips, keepNA = FALSE)
  if (11 %in% lens) {
    warning("ambiguous fips specified - 11 digits means could be tract if NOT missing a leading zero or blockgroup missing leading zero")
    # tfips = unique(substr(EJAM::blockgroupstats$bgfips, 1, 11))
    # valid_tract = fips[lens == 11] %in% tfips
    # fips[lens == 11][!valid_tract] <- paste0("0", fips[lens == 11][!valid_tract])
  }
  fips[nchar(fips, keepNA = FALSE) == 10] <- paste0("0", fips[nchar(fips,
                                                                    keepNA = FALSE) == 10])
  fips[nchar(fips, keepNA = FALSE) == 13] <- NA
  fips[nchar(fips, keepNA = FALSE) == 14] <- paste0("0", fips[nchar(fips,
                                                                    keepNA = FALSE) == 14])
  fips[nchar(fips, keepNA = FALSE) >= 16] <- NA
  suppressWarnings({
    fips[is.na(as.numeric(fips))] <- NA
  })
  if (!quiet) {
    if (anyNA(fips)) {
      howmanyna = sum(is.na(fips))
      warning(howmanyna, " fips had invalid number of characters (digits) or were NA values")
    }
  }
  return(fips)
}
####################################### ######################################## #

# convert fips to a string designating the Census unit type, like "block" or "blockgroup"
# see EJAM::fipstype()

fipstype_acs = function (fips) {

  if (length(fips) == 0 || !is.vector(fips) || !is.atomic(fips)) {
    return(NULL)
  }
  ftype <- rep(NA, length(fips))
  suppressWarnings({ # suppress warnings about how ambiguous if 11 digits before leading zero added
  fips <- fips_lead_zero_acs(fips = fips)
  })
  n <- nchar(fips, keepNA = FALSE)
  ftype[n == 15] <- "block"
  ftype[n == 12] <- "blockgroup"
  ftype[n == 11] <- "tract"
  ftype[n == 7] <- "city"
  ftype[n == 5] <- "county"  ## cannot distinguish from ZCTA/zip code just based on 5 digit length !
  ftype[!is.na(fips) & nchar(fips) == 2] <- "state"

  # Note zip code or ZCTA actually, has 5 digits like county and we cannot disambiguate here. assumes county.

  # Could add detection of other types like REGION, MSA, CSA, but not ZCTA, etc. ***




  if (anyNA(ftype)) {
    howmanyna <- sum(is.na(ftype))
    warning("NA returned for ", howmanyna,
            " fips that do not seem to be block, blockgroup, tract, city/CDP, county, or state FIPS (lengths with leading zeroes should be 15,12,11,7,5,2 respectively")
  }
  return(ftype)
}
####################################### ######################################## #

#' Get the SUMLEVEL code like "040" or "150" from the fipstype string like "state" or "blockgroup"
#'
#' @param ftype ignores case, vector of fipstype strings like "state", "county", "city", "tract", "blockgroup",
#'
#' @returns vector of summary levels
#' @seealso [fipstype_from_sumlevel()]
#'
#' @export
#'
sumlevel_from_fipstype = function(ftype) {

  ## see https://www.census.gov/programs-surveys/acs/geography-acs/reference-materials.2023.html#list-tab-2123892609
  # ACS_2023_5-Year_Geocount file
  # https://www2.census.gov/programs-surveys/acs/geography/areas_published/ACS_2023_5-Year_Geocount.xlsx

  ftype = tolower(ftype)

  sumlevel = rep(NA, length(ftype))

  sumlevel[ftype %in% "state"] <- "040"
  sumlevel[ftype %in% "county"] <- "050"
  sumlevel[ftype %in% "city"] <- "160"
  sumlevel[ftype %in% "tract"] <- "140"
  sumlevel[ftype %in% "blockgroup"] <- "150"

  sumlevel[ftype %in% tolower("REGION")] <- "020"
  sumlevel[ftype %in% tolower("American Indian Area/Alaska Native Area/Hawaiian Home Land")] <- "250"
  sumlevel[ftype %in% tolower("MSA")] <- "310"
  sumlevel[ftype %in% tolower("CSA")] <- "330"
  sumlevel[ftype %in% tolower("Urban Area")] <- "400"
  sumlevel[ftype %in% tolower("Congressional District")] <- "500"
  sumlevel[ftype %in% tolower("ZCTA")] <- "860"
  sumlevel[ftype %in% "block"] <- NA

  # SUMLEVEL strings extracted from GEO_ID are always 3 characters (e.g., "020", "040", "150"),
  # so the strings returned here must match that width.
  # 020 "REGION"
  # 250 "American Indian Area/Alaska Native Area/Hawaiian Home Land"
  # 310 "MSA"
  # 330 "CSA"
  # 400 "Urban Area"
  # 500 "Congressional District"
  # 860 "ZCTA"

  # stopifnot(all(!is.na(sumlevel)))
  return(sumlevel)
}
####################################### ######################################## #

#' Convert SUMLEVEL codes like "040" or "150" to fipstype strings like "state" or "blockgroup"
#'
#' @param sumlevel vector of codes like "040" or "150" for state or blockgroup
#'
#' @returns vector of character strings like "state" or "county" corresponding to the sumlevel codes
#' @seealso [sumlevel_from_fipstype()]
#'
#' @export
#'
fipstype_from_sumlevel = function(sumlevel) {

  x = rep(NA, length(sumlevel))
  sumlevel <- as.numeric(sumlevel)
  x[sumlevel %in% 40] <-  "state"
  x[sumlevel %in% 50] <-  "county"
  x[sumlevel %in% 160] <-  "city"
  x[sumlevel %in% 140] <-  "tract"
  x[sumlevel %in% 150] <-  "blockgroup"

  x[sumlevel %in% 20] <-  "REGION"
  x[sumlevel %in% 250] <-  "American Indian Area/Alaska Native Area/Hawaiian Home Land"
  x[sumlevel %in% 310] <-  "MSA"
  x[sumlevel %in% 330] <-  "CSA"
  x[sumlevel %in% 400] <-  "Urban Area"
  x[sumlevel %in% 500] <-  "Congressional District"
  x[sumlevel %in% 860] <-  "ZCTA"
  # x[is.na(sumlevel)] <-  "block"

  # stopifnot(all(!is.na(x)))
  return(x)
}
####################################### ######################################## #

fips_from_geoid = function(geoid) {

  # Census GEO_ID strings have the form "<sumlevel><suffix>US<fips>", e.g.,
  # "1500000US010010201001" for a blockgroup. Take everything after "US".
  # SUMLEVEL is authoritative for the geography type; we deliberately do NOT
  # cross-check against a digit-count heuristic here because several geography
  # types (ZCTA, MSA, Urban Area, Congressional District, ...) have fips widths
  # that collide with other types and would be wrongly flagged as invalid.
  has_us <- grepl("US", geoid, fixed = TRUE)
  fips <- gsub("^.*US(.*)", "\\1", geoid)
  fips[!has_us] <- NA
  fips[!is.na(fips) & nchar(fips) == 0] <- NA
  return(fips)
}
####################################### ######################################## #

