# ---------------------------------------------------------------------------- #
# Public entry point: download and parse ACS 5-year table-based summary file
# data for selected tables and fips or fips type, nationwide in bulk.
#
# Supporting helpers (fips/geoid/sumlevel parsers, geography lookup) live in
# R/fips.R, R/sumlevel.R, and R/geos.R. The robust download wrapper used here
# lives in R/utils-download.R.
# ---------------------------------------------------------------------------- #


#' Get full USA ACS data by table and fips (table-based summary file format)
#'
#' Downloads ACS 5-year data for the requested tables and either a single
#' geography type (e.g. "blockgroup") or a vector of specific fips codes.
#' Returns either a list of one data.table per table (the default) or a
#' single merged data.table.
#'
#' Targets the Census Bureau "table-based" summary file format introduced
#' for the 2018-2022 5-year survey (released December 2023) and used since.
#' See <https://www.census.gov/programs-surveys/acs/data/summary-file.html>.
#'
#' @param tables vector of ACS data table codes like "B01001" or "C17002".
#'   Some EJSCREEN tables are only published at tract resolution (notably
#'   "C16001" for detailed languages spoken at home and "B18101" for
#'   disability); when `return_list_not_merged = FALSE` and `fips =
#'   "blockgroup"`, those tables filter to zero rows and are dropped from
#'   the merge with a warning.
#'
#' @param fips one of:
#'   * a single geography type name: "blockgroup", "tract", "county",
#'     "state", "city", "REGION", "MSA", "CSA", "Urban Area",
#'     "Congressional District", "ZCTA", or
#'     "American Indian Area/Alaska Native Area/Hawaiian Home Land"
#'     (the last seven are recognized but only "blockgroup", "tract",
#'     "county", "state", "city" are well-tested);
#'   * a vector of fips codes (all of the same width / geography type);
#'   * `NULL` for no row filtering.
#'   When a type name is supplied, the SUMLEVEL filter is applied
#'   (e.g. "blockgroup" -> SUMLEVEL "150").
#'
#' @param yr end year of the 5-year ACS summary file (e.g. 2024 for the
#'   2020-2024 survey released by Census Bureau Jan. 2026).
#'
#' @param fiveorone 1 or 5; only the 5-year sample is tested in this package.
#'
#' @param return_list_not_merged if `TRUE` (the default) return a named list
#'   with one data.table per requested table; if `FALSE`, merge all tables
#'   on `fips` and return a single data.table. The merge cannot succeed if
#'   tables are at different spatial resolutions, so requesting tract-only
#'   tables alongside blockgroup tables with `return_list_not_merged =
#'   FALSE` will drop the empty tables (or stop, if no tables remain).
#'
#' @returns a named list of data.tables (one per table) or a single merged
#'   data.table, each with `GEO_ID`, `fips`, `SUMLEVEL`, and the estimate
#'   (`<table>_<nnn>`) and margin-of-error (`<table>_M<nnn>`) columns from
#'   the Census file. Estimate column names have the leading "_E" stripped
#'   for compatibility with `EJAM::formulas_ejscreen_acs$formula`.
#'
#' @examples
#'  \dontrun{
#'    x <- get_acs_new(yr = 2024, tables = "B25034", fips = "county")
#'    x[["B25034"]][1:3, 1:5]
#'
#'    # Full EJSCREEN block-group pull (excluding the two tract-only tables):
#'    bg <- get_acs_new(
#'      yr = 2024,
#'      fips = "blockgroup",
#'      tables = setdiff(ejscreen_acs_tables, c("C16001", "B18101")),
#'      return_list_not_merged = FALSE
#'    )
#'  }
#'
#' @export
get_acs_new <- function(
    tables = ejscreen_acs_tables,
    fips = "blockgroup",
    yr = acsdefaultendyearhere,
    fiveorone = "5",
    return_list_not_merged = TRUE
)  {

  stopifnot(
    length(fiveorone) == 1,
    nchar(fiveorone) == 1,
    as.character(fiveorone) %in% c("1", "5")
  )

  tables <- tolower(tables)

  url_dat <- paste0(
    "https://www2.census.gov/programs-surveys/acs/summary_file/",
    yr, "/table-based-SF/data/", fiveorone, "YRData/"
  )
  dfiles <- paste0("acsdt", fiveorone, "y", yr, "-", tables, ".dat")

  tablist <- list()
  for (i in seq_along(dfiles)) {
    dpath <- paste0(url_dat, dfiles[i])
    tablist[[i]] <- data.table::fread(dpath, showProgress = TRUE)

    tablist[[i]]$fips     <- fips_from_geoid(tablist[[i]]$GEO_ID)
    tablist[[i]]$SUMLEVEL <- sumlevel_from_geoid(tablist[[i]]$GEO_ID)
    data.table::setcolorder(tablist[[i]], c("GEO_ID", "fips", "SUMLEVEL"))
  }
  if (length(tables) != length(tablist)) {
    warning("Not all requested tables were obtained.")
  }

  # Row filtering: by SUMLEVEL (if a type name was passed) or by fips codes.
  if (!is.null(fips)) {
    if (fips[1] %in% .supported_fipstypes()) {
      if (length(fips) > 1) {
        stop("can get only 1 type of geography / sumlevel at a time, ",
             "such as 'blockgroup'")
      }
      sumlevel <- sumlevel_from_fipstype(fips)
      for (i in seq_along(dfiles)) {
        tablist[[i]] <- tablist[[i]][SUMLEVEL %in% sumlevel, ]
      }
    } else {
      fipscodes_requested <- fips
      for (i in seq_along(dfiles)) {
        tablist[[i]] <- tablist[[i]][fips %in% fipscodes_requested, ]
      }
    }
  }

  # Rename estimate columns to drop the "_E" infix used by Census, so the
  # output matches the variable names that EJAM::formulas_ejscreen_acs uses.
  # Census columns look like "B01001_E001" (estimate) and "B01001_M001"
  # (margin of error). Anchor the regex so unrelated "_E" substrings are not
  # touched.
  for (i in seq_along(tablist)) {
    names(tablist[[i]]) <- gsub("_E([0-9]+)$", "_\\1", names(tablist[[i]]))
  }

  names(tablist) <- toupper(as.vector(tables))

  rowcounts <- sapply(tablist, NROW)
  sumlevels <- unlist(sapply(tablist, function(z) unique(z$SUMLEVEL)))

  if (return_list_not_merged) {
    if (length(unique(sumlevels)) > 1) {
      warning("tables are at differing spatial resolutions like block group vs tract")
    }
    if (any(rowcounts %in% 0)) {
      warning("Some tables had zero rows")
      cat("These tables had zero rows: ",
          paste0(names(tablist)[rowcounts %in% 0], collapse = ", "), "\n")
    }
    if (length(unique(rowcounts)) > 1) {
      warning("note: not every table had the same number of rows (places)")
      cat("Row counts of tables: \n")
      print(data.frame(
        table = names(tablist),
        rowcount = rowcounts,
        note = ifelse(rowcounts != rowcounts[1], "**", "")
      ))
    }
    return(tablist)
  }

  # return_list_not_merged = FALSE: join all the tables on fips.
  if (length(unique(sumlevels)) > 1) {
    stop("this function will not merge tables that are at differing ",
         "spatial resolutions like block group vs tract")
  }
  if (any(rowcounts %in% 0)) {
    warning("Some tables had zero rows - omitting those")
    cat("These tables had zero rows: ",
        paste0(names(tablist)[rowcounts %in% 0], collapse = ", "), "\n")
    tablist <- tablist[rowcounts > 0]
    rowcounts <- sapply(tablist, NROW)
    sumlevels <- unlist(sapply(tablist, function(z) unique(z$SUMLEVEL)))
  }
  if (length(tablist) == 0) {
    stop("No tables to merge after removing zero-row tables")
  }
  if (length(unique(rowcounts)) > 1) {
    warning("caution: not every table being merged had the same number of rows (places)")
    cat("Row counts of tables: \n")
    print(data.frame(
      table = names(tablist),
      rowcount = rowcounts,
      note = ifelse(rowcounts != rowcounts[1], "**", "")
    ))
  }

  tabmerged <- tablist[[1]]
  if (length(tablist) > 1) {
    for (i in 2:length(tablist)) {
      x <- tablist[[i]]
      # Drop shared non-key columns to avoid .x / .y suffixes in the merge.
      x[, GEO_ID := NULL]
      x[, SUMLEVEL := NULL]
      tabmerged <- merge(tabmerged, x, by = "fips")
    }
  }
  return(tabmerged)
}
