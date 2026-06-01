# ---------------------------------------------------------------------------- #
# Public entry point: download and parse ACS 5-year table-based summary file
# data for selected tables and fips or fips type, nationwide in bulk.
#
# Supporting helpers (fips/geoid/sumlevel parsers, geography lookup, the
# download layer, input validators) live in R/fips.R, R/sumlevel.R, R/geos.R,
# R/utils-download.R, and R/utils-validate.R.
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
#' Downloads are made resilient by an httr2 retry/timeout layer
#' (`R/utils-download.R`); set `cache_dir` to persist files across calls
#' (recommended: `tools::R_user_dir("ACSdownload", "cache")`). With
#' `parallel = TRUE`, downloads run via `future.apply::future_lapply()` --
#' set a `future::plan()` (e.g. `future::plan(future::multisession,
#' workers = 4)`) before calling.
#'
#' @param tables vector of ACS data table codes like "B01001" or "C17002".
#'   Race/ethnicity-suffixed (e.g. "B03002H") and Puerto Rico Community
#'   Survey tables (e.g. "B05001PR", "B06004APR") are also accepted.
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
#'     (only "blockgroup", "tract", "county", "state", "city" are well-tested);
#'   * a vector of fips codes (all the same width / geography type);
#'   * `NULL` for no row filtering.
#'
#' @param yr end year of the 5-year ACS summary file (e.g. 2024 for the
#'   2020-2024 survey released by Census Bureau Jan. 2026). Validated
#'   against `acsfirstyearavailablehere` (the floor) and `current_year + 1`
#'   (the ceiling); bad values fail before any HTTP call.
#'
#' @param fiveorone 1 or 5; only the 5-year sample is tested here.
#'
#' @param return_list_not_merged if `TRUE` (the default) return a named
#'   list with one data.table per requested table; if `FALSE`, merge all
#'   tables on `fips` and return a single data.table.
#'
#' @param cache_dir optional path to a directory in which to persist the
#'   downloaded .dat files. The table-based SF files are immutable once a
#'   vintage ships, so caching is safe and dramatically speeds up repeat
#'   calls. Defaults to `getOption("ACSdownload.cache_dir", NULL)`.
#'
#' @param timeout_sec per-request timeout in seconds for each .dat
#'   download. Defaults to `getOption("ACSdownload.timeout", 300)`.
#'
#' @param max_retries number of retry attempts after the first for
#'   transient HTTP failures (HTTP 429 and 5xx). Defaults to
#'   `getOption("ACSdownload.retries", 3)`.
#'
#' @param parallel if `TRUE` and both `future` and `future.apply` are
#'   installed, fetch the .dat files concurrently. The caller must set a
#'   `future::plan()` first.
#'
#' @param variables optional character vector of specific estimate variable
#'   codes to keep, like `c("B25034_001", "B25034_002")`. Names are matched
#'   in the post-rename form (no `_E` infix). When NULL (the default), all
#'   estimate columns from the requested tables are kept.
#'
#' @param keep_moe if `TRUE` (the default), keep the margin-of-error
#'   columns (`<table>_M<nnn>`); if `FALSE`, drop them.
#'
#' @param keep_annotations if `TRUE`, keep the annotation columns
#'   (`<table>_EA<nnn>`, `<table>_MA<nnn>`) that some vintages include;
#'   the default `FALSE` drops them.
#'
#' @param quiet if `FALSE` (the default) and the `cli` package is
#'   installed, show a progress bar over the (sequential) downloads.
#'   Ignored when `parallel = TRUE`.
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
#'      return_list_not_merged = FALSE,
#'      cache_dir = tools::R_user_dir("ACSdownload", "cache")
#'    )
#'  }
#'
#' @export
get_acs_new <- function(
    tables                 = ejscreen_acs_tables,
    fips                   = "blockgroup",
    yr                     = acsdefaultendyearhere,
    fiveorone              = "5",
    return_list_not_merged = TRUE,
    cache_dir              = getOption("ACSdownload.cache_dir", NULL),
    timeout_sec            = getOption("ACSdownload.timeout",   300),
    max_retries            = getOption("ACSdownload.retries",   3),
    parallel               = FALSE,
    variables              = NULL,
    keep_moe               = TRUE,
    keep_annotations       = FALSE,
    quiet                  = FALSE
)  {

  # ---- 1. Validate everything up front so we never download into a bad job ----
  fiveorone <- validate_fiveorone(fiveorone)
  yr        <- validate_acs_endyear(yr)
  tables    <- validate_acs_tables(tables)   # uppercased
  fips      <- validate_fips_arg(fips)

  # ---- 2. Build URLs ------------------------------------------------------
  url_dat <- paste0(
    "https://www2.census.gov/programs-surveys/acs/summary_file/",
    yr, "/table-based-SF/data/", fiveorone, "YRData/"
  )
  dfiles <- paste0("acsdt", fiveorone, "y", yr, "-", tolower(tables), ".dat")
  urls   <- paste0(url_dat, dfiles)

  # ---- 3. Download with retry / timeout / optional cache / optional parallel
  local_paths <- acs_download_many(
    urls,
    cache_dir   = cache_dir,
    timeout_sec = timeout_sec,
    max_retries = max_retries,
    parallel    = parallel,
    quiet       = quiet
  )

  # ---- 4. Read each .dat into a data.table and attach fips/SUMLEVEL ------
  tablist <- vector("list", length(local_paths))
  for (i in seq_along(local_paths)) {
    tablist[[i]] <- data.table::fread(local_paths[[i]], showProgress = FALSE)
    tablist[[i]]$fips     <- fips_from_geoid(tablist[[i]]$GEO_ID)
    tablist[[i]]$SUMLEVEL <- sumlevel_from_geoid(tablist[[i]]$GEO_ID)
    data.table::setcolorder(tablist[[i]], c("GEO_ID", "fips", "SUMLEVEL"))
  }
  if (length(tables) != length(tablist)) {
    warning("Not all requested tables were obtained.")
  }

  # ---- 5. Row filter: by SUMLEVEL (type name) or by fips codes ----------
  if (!is.null(fips)) {
    if (fips[1] %in% .supported_fipstypes()) {
      sumlevel <- sumlevel_from_fipstype(fips)
      for (i in seq_along(tablist)) {
        tablist[[i]] <- tablist[[i]][SUMLEVEL %in% sumlevel, ]
      }
    } else {
      fipscodes_requested <- fips
      for (i in seq_along(tablist)) {
        tablist[[i]] <- tablist[[i]][fips %in% fipscodes_requested, ]
      }
    }
  }

  # ---- 6. Rename estimate columns to match formulas_ejscreen_acs ---------
  # Census columns look like "B01001_E001" (estimate) and "B01001_M001" (MOE).
  # Drop the "_E" infix only when it sits between underscore and a numeric
  # index, so unrelated "_E" substrings are untouched.
  for (i in seq_along(tablist)) {
    names(tablist[[i]]) <- gsub("_E([0-9]+)$", "_\\1", names(tablist[[i]]))
  }
  names(tablist) <- toupper(as.vector(tables))

  # ---- 6b. Optional column selection (variables, keep_moe, keep_annotations) ---
  tablist <- .filter_acs_columns(
    tablist,
    variables        = variables,
    keep_moe         = keep_moe,
    keep_annotations = keep_annotations
  )

  rowcounts <- sapply(tablist, NROW)
  sumlevels <- unlist(sapply(tablist, function(z) unique(z$SUMLEVEL)))

  # ---- 7. Return list, or merge -----------------------------------------
  if (return_list_not_merged) {
    if (length(unique(sumlevels)) > 1) {
      warning("tables are at differing spatial resolutions like block group vs tract")
    }
    if (any(rowcounts %in% 0)) {
      warning("Some tables had zero rows")
      message("These tables had zero rows: ",
              paste0(names(tablist)[rowcounts %in% 0], collapse = ", "))
    }
    if (length(unique(rowcounts)) > 1) {
      warning("note: not every table had the same number of rows (places)")
      message("Row counts of tables:")
      print(data.frame(
        table    = names(tablist),
        rowcount = rowcounts,
        note     = ifelse(rowcounts != rowcounts[1], "**", "")
      ))
    }
    return(tablist)
  }

  # return_list_not_merged = FALSE: join on fips
  if (length(unique(sumlevels)) > 1) {
    stop("this function will not merge tables that are at differing ",
         "spatial resolutions like block group vs tract")
  }
  if (any(rowcounts %in% 0)) {
    warning("Some tables had zero rows - omitting those")
    message("These tables had zero rows: ",
            paste0(names(tablist)[rowcounts %in% 0], collapse = ", "))
    tablist   <- tablist[rowcounts > 0]
    rowcounts <- sapply(tablist, NROW)
    sumlevels <- unlist(sapply(tablist, function(z) unique(z$SUMLEVEL)))
  }
  if (length(tablist) == 0) {
    stop("No tables to merge after removing zero-row tables")
  }
  if (length(unique(rowcounts)) > 1) {
    warning("caution: not every table being merged had the same number of rows (places)")
    message("Row counts of tables:")
    print(data.frame(
      table    = names(tablist),
      rowcount = rowcounts,
      note     = ifelse(rowcounts != rowcounts[1], "**", "")
    ))
  }

  tabmerged <- tablist[[1]]
  if (length(tablist) > 1) {
    for (i in 2:length(tablist)) {
      x <- tablist[[i]]
      x[, GEO_ID   := NULL]
      x[, SUMLEVEL := NULL]
      tabmerged <- merge(tabmerged, x, by = "fips")
    }
  }
  return(tabmerged)
}


# Filter the per-table data.tables down to user-requested variables,
# margin-of-error (MOE), and annotation columns. Always retains the
# bookkeeping columns GEO_ID, fips, SUMLEVEL.
#
# Column-name semantics (post-rename in get_acs_new()). <TABLE> is the table
# code, which may carry a race suffix (A-I) and/or a Puerto Rico suffix (PR),
# e.g. B01001, B03002H, B05001PR, B06004APR:
#   estimate    : <TABLE>_<NNN>
#   MOE         : <TABLE>_M<NNN>
#   estimate ann: <TABLE>_EA<NNN>
#   MOE      ann: <TABLE>_MA<NNN>
.filter_acs_columns <- function(tablist,
                                variables        = NULL,
                                keep_moe         = TRUE,
                                keep_annotations = FALSE) {

  if (is.null(variables) && isTRUE(keep_moe) && isTRUE(keep_annotations)) {
    return(tablist)
  }

  bookkeeping <- c("GEO_ID", "fips", "SUMLEVEL")
  tab_pat     <- "[BC][0-9]{5}[A-I]?(PR)?"  # table code incl. race/PR suffixes
  est_pat     <- paste0("^", tab_pat, "_[0-9]+$")
  moe_pat     <- paste0("^", tab_pat, "_M[0-9]+$")
  ann_pat     <- paste0("^", tab_pat, "_(EA|MA)[0-9]+$")

  for (i in seq_along(tablist)) {
    nm <- names(tablist[[i]])
    is_est <- grepl(est_pat, nm)
    is_moe <- grepl(moe_pat, nm)
    is_ann <- grepl(ann_pat, nm)
    is_bk  <- nm %in% bookkeeping

    keep <- is_bk
    if (is.null(variables)) {
      keep <- keep | is_est
    } else {
      keep <- keep | (is_est & nm %in% variables)
    }
    if (isTRUE(keep_moe)) {
      if (is.null(variables)) {
        keep <- keep | is_moe
      } else {
        # Keep MOE columns whose corresponding estimate variable was requested.
        est_for_moe <- sub("_M([0-9]+)$", "_\\1", nm)
        keep <- keep | (is_moe & est_for_moe %in% variables)
      }
    }
    if (isTRUE(keep_annotations)) {
      keep <- keep | is_ann
    }

    tablist[[i]] <- tablist[[i]][, .SD, .SDcols = nm[keep]]
  }
  tablist
}
