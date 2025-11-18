if (FALSE) {
  ##### EXAMPLE OF GETTING ACS DATA FOR ALL US BLOCKGROUPS AND CALCULATING INDICATORS

  library(EJAM)
  library(data.table)

  acsdata <- list()
  x <- get_acs_new()

  #  can just use cbind to combine or join all these tables, and confirmed that:
  # all.equal(x[[1]]$fips, x[[1]]$fips)
  # all.equal(x[[1]]$fips, x[[2]]$fips)
  # all.equal(x[[1]]$fips, x[[3]]$fips)
  # all.equal(x[[1]]$fips, x[[4]]$fips)
  # all.equal(x[[1]]$fips, x[[5]]$fips)
  # all.equal(x[[1]]$fips, x[[6]]$fips)
  # all.equal(x[[1]]$fips, x[[7]]$fips)
  y <- cbind(x[[1]], x[[2]], x[[3]], x[[4]], x[[5]], x[[6]], x[[7]])
  y <- y[, .SD, .SDcols = !duplicated(names(y))]

  acsdata <- EJAM::calc_ejam(
    y,
    formulas = EJAM::formulas_ejscreen_acs$formula,
    keep.old = c("fips", "pop")
  )
  data.table::setnames(acsdata, "fips", "bgfips")

  #   dput(setdiff(names(acsdata) , names(blockgroupstats)) )
  # drop <- c("ageunder5m", "age5to9m", "age10to14m", "age15to17m", "age65to66m",
  #   "age6769m", "age7074m", "age7579m", "age8084m", "age85upm", "ageunder5f",
  #   "age5to9f", "age10to14f", "age15to17f", "age65to66f", "age6769f",
  #   "age7074f", "age7579f", "age8084f", "age85upf", "pop3002", "nonhisp",
  #   "pov50", "pov99", "pov124", "pov149", "pov184", "pov199", "pov2plus",
  #   "m0", "m4", "m6", "m8", "m9", "m10", "m11", "m12", "f0", "f4",
  #   "f6", "f8", "f9", "f10", "f11", "f12", "lingisospanish", "lingisoeuro",
  #   "lingisoasian", "lingisoother", "built1950to1959", "built1940to1949",
  #   "builtpre1940", "nonmins", "num1pov", "num15pov", "num2pov",
  #   "num2pov.alt", "pct1pov", "pct15pov", "pct2pov", "pct2pov.alt"
  # )
  keep <- intersect(names(acsdata), names(EJAM::blockgroupstats))
  acsdata <- acsdata[ , .SD, .SDcols = keep]

  t(acsdata[1:2,])
  # save(acsdata, file = "~/Downloads/acs2023.rda")
}
####################################### ######################################## #

## WHAT OTHER ACS VARIABLES ARE STILL MISSING FROM THIS EXAMPLE?
# # need to add formulas for these, in  EJAM::formulas_ejscreen_acs
#
# e.g., this example lacks disability indicator and pctunder18 that are available via ACS
# setdiff(setdiff(names(blockgroupstats), c(names_geo, names_e)), names(acsdata))
#
# [1] "bgid"                   "Demog.Index"            "Demog.Index.Supp"
# [4] "pctlingiso"             "hhlds"                  "disab_universe"
# [7] "disability"             "pctdisability"          "lowlifex"
# [10] "count.NPL"              "count.TSDF"             "count.ej.80up"
# [13] "count.ej.80up.supp"     "Demog.Index.State"      "Demog.Index.Supp.State"
# [16] "wa"                     "pctwa"                  "ba"
# [19] "pctba"                  "aa"                     "pctaa"
# [22] "aiana"                  "pctaiana"               "nhpia"
# [25] "pctnhpia"               "otheralone"             "pctotheralone"
# [28] "multi"                  "pctmulti"               "under18"
# [31] "pctunder18"             "over17"                 "pctover17"
# [34] "male"                   "pctmale"                "female"
# [37] "pctfemale"              "percapincome"           "poor"
# [40] "pctpoor"                "lan_universe"           "lan_nonenglish"
# [43] "pctlan_nonenglish"      "lan_eng_na"             "lan_spanish"
# [46] "pctlan_spanish"         "lan_ie"                 "pctlan_ie"
# [49] "lan_api"                "pctlan_api"             "lan_other"
# [52] "pctlan_other"           "spanish_li"             "pctspanish_li"
# [55] "ie_li"                  "pctie_li"               "api_li"
# [58] "pctapi_li"              "other_li"               "pctother_li"
# [61] "occupiedunits"          "ownedunits"             "pctownedunits"
# [64] "pctnobroadband"         "lifexyears"             "pctnohealthinsurance"
# [67] "rateheartdisease"       "rateasthma"             "ratecancer"
# [70] "pctflood30"             "pctfire30"              "num_waterdis"
# [73] "num_airpoll"            "num_brownfield"         "num_tri"
# [76] "num_school"             "num_hospital"           "num_church"
# [79] "yesno_tribal"           "yesno_cejstdis"         "yesno_iradis"
# [82] "yesno_airnonatt"        "yesno_impwaters"        "yesno_houseburden"
# [85] "yesno_transdis"         "yesno_fooddesert"       "pctlan_english"
# [88] "pctlan_french"          "pctlan_rus_pol_slav"    "pctlan_other_ie"
# [91] "pctlan_vietnamese"      "pctlan_other_asian"     "pctlan_arabic"
# > dput(setdiff(setdiff(names(blockgroupstats), names_e), names(acsdata)))
#
# acs2add <- c("bgid", "statename", "ST", "countyname", "REGION",
#   "Demog.Index", "Demog.Index.Supp", "Demog.Index.State", "Demog.Index.Supp.State",
#   "pctlingiso", "hhlds", "disab_universe", "disability", "pctdisability",
#   "lowlifex",
#   "wa", "pctwa", "ba", "pctba", "aa", "pctaa", "aiana",
#   "pctaiana", "nhpia", "pctnhpia", "otheralone", "pctotheralone",
#   "multi", "pctmulti", "under18", "pctunder18", "over17", "pctover17",
#   "male", "pctmale", "female", "pctfemale", "percapincome", "poor",
#   "pctpoor",
#   "lan_universe", "lan_nonenglish", "pctlan_nonenglish",
#   "lan_eng_na", "lan_spanish", "pctlan_spanish", "lan_ie", "pctlan_ie",
#   "lan_api", "pctlan_api", "lan_other", "pctlan_other", "spanish_li",
#   "pctspanish_li", "ie_li", "pctie_li", "api_li", "pctapi_li",
#   "other_li", "pctother_li",
#   "occupiedunits", "ownedunits", "pctownedunits",
#   "pctnobroadband", "lifexyears", "pctnohealthinsurance",
#
#   "arealand", "areawater", "Shape_Length", "area",
#   "count.NPL", "count.TSDF", "count.ej.80up", "count.ej.80up.supp",
#   "rateheartdisease", "rateasthma", "ratecancer",
#   "pctflood30", "pctfire30",
#   "num_waterdis", "num_airpoll", "num_brownfield", "num_tri", "num_school", "num_hospital", "num_church",
#   "yesno_tribal", "yesno_cejstdis", "yesno_iradis",
#   "yesno_airnonatt", "yesno_impwaters", "yesno_houseburden", "yesno_transdis", "yesno_fooddesert",
#   "pctlan_english", "pctlan_french", "pctlan_rus_pol_slav",
#   "pctlan_other_ie", "pctlan_vietnamese", "pctlan_other_asian", "pctlan_arabic")

# intersect(acs2add,   formulas_ejscreen_acs$rname)
# [1] "pctlingiso" "hhlds"

####################################### ######################################## #

# DATA ####

# to download/read the ACS 5year data for selected tables and selected fips or fipstype

#' newer way to get full USA ACS data by table and fips
#' get the ACS 5year data for selected tables and fips or fipstype
#'
#' @param tables vector of ACS data table numbers like "B01001" etc.
#' @param fips "blockgroups" for all US bg, or a vector of fips codes.
#'   can also be "county", "state", "tract", or vector of one of those fips code types.
#'   May support these but untested: "REGION", "American Indian Area/Alaska Native Area/Hawaiian Home Land",
#'   "MSA", "CSA", "Urban Area", "Congressional District", "ZCTA".
#'   If a fips type (e.g., "tract"), defines the SUMLEVEL variable in the ACS data (e.g., "140").
#' @param yr end year of 5 year ACS summary file data, such as 2023 for the 2019-2023 survey released by Census Bureau Dec. 2024.
#' @param fiveorone optional 1 or 5, where 5 is the 5-year sample - only 5-yr tested here
#'
#' @returns table with estimates and margins of error and fips and SUMLEVEL
#'
#' @export
#'
get_acs_new = function(
    tables = ejscreen_acs_tables,
    fips = "blockgroup", # related to sumlevel. note it has no space in it, unlike in tidycensus variable info table
    yr = acsdefaultendyearhere, # e.g., 2023 until 12/2025, then 2024
    fiveorone = '5'
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
  }

  # could join all the tables to get 1 column per variable all in 1 table, or even use cbind if we know GEOIDS are identical across tables but they are not if resolution available varies

  # could filter to just selected variables in each table here or elsewhere

  if (is.null(fips)) {
    # no fips filtering
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
  # rename variables to work well with formulas_ejscreen_acs$formulas
  for (i in 1:length(tablist))  {
    names(tablist[[i]]) <- gsub("_E", "_", names(tablist[[i]] ))
  }
  return(tablist)
}
####################################### ######################################## #
####################################### ######################################## #

# to get the geography names AND also get the ACS 5year data for selected tables and fips or fipstype

#' newer way to get full USA ACS data by table and fips
#' read the geography names AND also get the ACS 5year data for selected tables and fips or fipstype
#'
#' @param tables vector of ACS data table numbers like "B01001" etc. and if NULL, uses defaults of [get_acs_new()]
#' @param fips "blockgroups" for all US bg, or a vector of fips codes.
#'   can also be "county", "state", "tract", or vector of one of those fips code types.
#'   If a fips type, defines the SUMLEVEL variable in the ACS data, such as 140 for
#' @param yr end year of 5 year ACS summary file data, such as 2023 for the 2019-2023 survey released by Census Bureau Dec. 2024.
#' @param fiveorone optional 1 or 5, where 5 is the 5-year sample - only 5-yr tested here
#'
#' @returns list of geos + dat, estimates and margins of error and fips and SUMELEVEL
#'
#' @export
#'
get_acs_new_both = function(
    tables = NULL,
    fips = "blockgroups",
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

#' newer way to get the geography names AND also get the ACS 5year data for selected tables and fips or fipstype
#'
#' @param yr end year of 5 year ACS summary file data, such as 2023 for the 2019-2023 survey released by Census Bureau Dec. 2024.
#' @param fips "blockgroups" for all US bg, or a vector of fips codes.
#'   can also be "county", "state", "tract", or vector of one of those fips code types
#'
#' @returns table with geographies - names and fips and SUMLEVEL
#'
#' @export
#'
get_acs_new_geos = function(
    yr = acsdefaultendyearhere, # e.g., 2023 until 12/2025, then 2024
    fips = "blockgroup") {

  url_geos = paste0("https://www2.census.gov/programs-surveys/acs/summary_file/",
                    yr, "/table-based-SF/documentation/Geos", yr, "5YR.txt")
  geos = data.table::fread(url_geos)

  ###################### #
  # could filter to just selected rows/geographies, either by type of fips or  vector of specific fips
  if (is.null(fips)) {
    # no fips filtering
  } else {
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

  geos = geos[SUMLEVEL == sumlevel, .(STUSAB, SUMLEVEL, GEO_ID)]

  geos[ , fips := fips_from_geoid(GEO_ID)]

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

fipstype_acs = function (fips) {

  if (length(fips) == 0 || !is.vector(fips) || !is.atomic(fips)) {
    return(NULL)
  }
  ftype <- rep(NA, length(fips))
  fips <- fips_lead_zero_acs(fips = fips)
  n <- nchar(fips, keepNA = FALSE)
  ftype[n == 15] <- "block"
  ftype[n == 12] <- "blockgroup"
  ftype[n == 11] <- "tract"
  ftype[n == 7] <- "city"
  ftype[n == 5] <- "county"
  ftype[!is.na(fips) & nchar(fips) == 2] <- "state"

  # Note zip code or ZCTA actually, has 5 digits like county and we cannot disambiguate here. assumes county.

  # Could add detection of other types like REGION, MSA, CSA, ZCTA, etc. ***




  if (anyNA(ftype)) {
    howmanyna <- sum(is.na(ftype))
    warning("NA returned for ", howmanyna,
            " fips that do not seem to be block, blockgroup, tract, city/CDP, county, or state FIPS (lengths with leading zeroes should be 15,12,11,7,5,2 respectively")
  }
  return(ftype)
}
####################################### ######################################## #

sumlevel_from_fipstype = function(ftype) {

  ## see https://www.census.gov/programs-surveys/acs/geography-acs/reference-materials.2023.html#list-tab-2123892609
  # ACS_2023_5-Year_Geocount file
  # https://www2.census.gov/programs-surveys/acs/geography/areas_published/ACS_2023_5-Year_Geocount.xlsx

  sumlevel = rep(NA, length(ftype))

  sumlevel[ftype %in% "state"] <- "040"
  sumlevel[ftype %in% "county"] <- "050"
  sumlevel[ftype %in% "city"] <- "160"
  sumlevel[ftype %in% "tract"] <- "140"
  sumlevel[ftype %in% "blockgroup"] <- "150"

  sumlevel[ftype %in% "REGION"] <- "20"
  sumlevel[ftype %in% "American Indian Area/Alaska Native Area/Hawaiian Home Land"] <- "250"
  sumlevel[ftype %in% "MSA"] <- "310"
  sumlevel[ftype %in% "CSA"] <- "330"
  sumlevel[ftype %in% "Urban Area"] <- "400"
  sumlevel[ftype %in% "Congressional District"] <- "500"
  sumlevel[ftype %in% "ZCTA"] <- "860"
  sumlevel[ftype %in% "block"] <- NA

  # 20 "REGION"
  # 250 "American Indian Area/Alaska Native Area/Hawaiian Home Land"
  # 310 "MSA
  # 330 "CSA"
  # 400 "Urban Area"
  # 500 "Congressional District"
  # 860 "ZCTA"
  # sumlevel[ftype %in% "block"] <- NA

  # stopifnot(all(!is.na(sumlevel)))
  return(sumlevel)
}
####################################### ######################################## #

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

  fips = gsub("^.*US(.*)", "\\1", geoid)
  sumlevel <- sumlevel_from_geoid(geoid)
  ftype_based_only_on_digits = fipstype_acs(fips)
  ftype_based_only_on_sumlevel = fipstype_from_sumlevel(sumlevel)
  ftype_based_only_on_digits[is.na(ftype_based_only_on_digits)] <- 0
  ftype_based_only_on_sumlevel[is.na(ftype_based_only_on_sumlevel)] <- -1
  fips[ftype_based_only_on_digits != ftype_based_only_on_sumlevel] <- NA
  # fips[nchar(fips) == 0] <- NA
  return(fips)
}
####################################### ######################################## #

