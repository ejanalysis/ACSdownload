# ---------------------------------------------------------------------------- #
# Robust download layer used by get_acs_new().
#
# `data.table::fread(url)` is a single bare HTTP call with no retry knobs.
# For a job that downloads 16 tables * ~10-200 MB each, one transient
# server hiccup kills everything. This layer:
#
#   * Downloads to a tempfile (or `cache_dir`, if set) via httr2, with
#     timeout and retry/backoff on transient failures.
#   * Returns the local path so callers can fread() it without re-fetching.
#   * Optionally caches downloads in `cache_dir` -- the table-based summary
#     file files are immutable once a vintage ships, so caching is safe.
#   * Optionally runs the per-file fetches in parallel via future.apply,
#     when both `future` and `future.apply` are installed.
# ---------------------------------------------------------------------------- #


#' Download a single Census ACS summary-file URL with retry, timeout, and
#' optional caching.
#'
#' @param url full https URL of the .dat file
#' @param cache_dir if non-NULL, persist the file at
#'   `file.path(cache_dir, basename(url))` and reuse if it already exists
#' @param timeout_sec request timeout per attempt, in seconds
#' @param max_retries number of retry attempts after the first (so total
#'   attempts = `1 + max_retries`)
#' @returns absolute path to the downloaded file
#' @keywords internal
#' @noRd
acs_download_one <- function(url,
                             cache_dir   = NULL,
                             timeout_sec = getOption("ACSdownload.timeout", 300),
                             max_retries = getOption("ACSdownload.retries", 3)) {

  if (!is.null(cache_dir)) {
    if (!dir.exists(cache_dir)) {
      dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    }
    dest <- file.path(cache_dir, basename(url))
    if (file.exists(dest) && file.size(dest) > 0L) {
      return(normalizePath(dest, mustWork = TRUE))
    }
  } else {
    dest <- tempfile(pattern = paste0("acs_", basename(url), "_"),
                     fileext = "")
  }

  if (!requireNamespace("httr2", quietly = TRUE)) {
    stop("httr2 is required to download ACS files. Install it with ",
         "install.packages(\"httr2\").")
  }

  req <- httr2::request(url)
  req <- httr2::req_timeout(req, timeout_sec)
  req <- httr2::req_retry(
    req,
    max_tries     = 1L + max_retries,
    is_transient  = function(resp) {
      st <- httr2::resp_status(resp)
      st == 429L || (st >= 500L && st < 600L)
    },
    backoff       = function(i) min(60, 2^i)  # 2s, 4s, 8s, ... capped at 60s
  )

  resp <- tryCatch(
    httr2::req_perform(req, path = dest),
    error = function(e) {
      stop("failed to download ACS file after ",
           1L + max_retries, " attempts: ", url,
           "\n  underlying error: ", conditionMessage(e),
           call. = FALSE)
    }
  )
  status <- httr2::resp_status(resp)
  if (status >= 400L) {
    stop("HTTP ", status, " for ", url,
         "\n  (check that `yr` and the table code are valid for this vintage)",
         call. = FALSE)
  }
  normalizePath(dest, mustWork = TRUE)
}


#' Download many ACS URLs concurrently when future.apply is available;
#' otherwise sequentially.
#'
#' @param urls character vector of URLs to fetch
#' @param cache_dir see [acs_download_one()]
#' @param timeout_sec see [acs_download_one()]
#' @param max_retries see [acs_download_one()]
#' @param parallel logical; when TRUE and {future, future.apply} are
#'   installed, run downloads via `future.apply::future_lapply()`. The
#'   caller is responsible for setting a `future::plan()` (e.g.
#'   `future::plan(future::multisession, workers = 4)`).
#' @returns character vector of local file paths, in input order
#' @keywords internal
#' @noRd
acs_download_many <- function(urls,
                              cache_dir   = NULL,
                              timeout_sec = getOption("ACSdownload.timeout", 300),
                              max_retries = getOption("ACSdownload.retries", 3),
                              parallel    = FALSE) {

  do_one <- function(u) acs_download_one(
    u,
    cache_dir   = cache_dir,
    timeout_sec = timeout_sec,
    max_retries = max_retries
  )

  if (parallel &&
      requireNamespace("future",        quietly = TRUE) &&
      requireNamespace("future.apply",  quietly = TRUE)) {
    return(unlist(future.apply::future_lapply(urls, do_one, future.seed = NULL)))
  }
  unlist(lapply(urls, do_one))
}
