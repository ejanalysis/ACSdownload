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
#     files are reused only with matching completion records.
#   * Optionally runs the per-file fetches in parallel via future.apply,
#     when both `future` and `future.apply` are installed.
# ---------------------------------------------------------------------------- #


#' Download a single Census ACS summary-file URL with retry, timeout, and
#' optional caching.
#'
#' @param url full https URL of the .dat file
#' @param cache_dir if non-NULL, persist the file at
#'   `file.path(cache_dir, basename(url))` and reuse only with a matching completion record
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

  if (length(max_retries) != 1L || !is.finite(max_retries) || max_retries < 0 || max_retries != floor(max_retries)) {
    stop("max_retries must be one nonnegative integer")
  }
  if (length(timeout_sec) != 1L || !is.finite(timeout_sec) || timeout_sec <= 0) {
    stop("timeout_sec must be one positive finite number")
  }
  cached <- !is.null(cache_dir)
  if (cached) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    dest <- file.path(cache_dir, basename(url))
    # Completed entries can be read from a read-only cache without a lock.
    if (.acs_cache_valid(dest, url)) return(normalizePath(dest, mustWork = TRUE))
    # A holder may need every attempt and its backoff before publishing.
    backoff_budget <- sum(pmin(60, 2^seq_len(min(max_retries, 6)))) +
      max(0, max_retries - 6) * 60
    lock_wait <- ((1 + max_retries) * timeout_sec + backoff_budget + 5) * 1000
    lock <- filelock::lock(paste0(dest, ".lock"), timeout = lock_wait)
    if (is.null(lock)) stop("Timed out waiting for another process to finish downloading the ACS file: ", dest)
    on.exit(filelock::unlock(lock), add = TRUE)
    if (.acs_cache_valid(dest, url)) return(normalizePath(dest, mustWork = TRUE))
  } else {
    dest <- tempfile(pattern = "acs_")
  }
  # Same directory permits atomic rename. Neither partial downloads nor partial
  # completion records are ever visible as reusable cache entries.
  staging <- if (cached) paste0(dest, ".part") else tempfile(pattern = ".acs-download-", tmpdir = dirname(dest))
  marker <- paste0(dest, ".complete.rds")
  marker_tmp <- if (cached) paste0(marker, ".part") else tempfile(pattern = ".acs-complete-", tmpdir = dirname(dest))
  # Under the lock these fixed paths belong to this writer; replace leftovers
  # from a previous process killed before its on.exit cleanup could run.
  unlink(c(staging, marker_tmp))
  on.exit(unlink(c(staging, marker_tmp)), add = TRUE)

  req <- httr2::request(url)
  req <- httr2::req_timeout(req, timeout_sec)
  req <- httr2::req_retry(req,
    max_tries = 1L + max_retries,
    retry_on_failure = TRUE,
    is_transient = function(resp) {
      st <- httr2::resp_status(resp)
      st == 429L || (st >= 500L && st < 600L)
    },
    backoff = function(i) min(60, 2^i))
  resp <- tryCatch(httr2::req_perform(req, path = staging), error = function(e) {
    stop("failed to download ACS file (up to ", 1L + max_retries, " attempts): ", url,
         "\n  underlying error: ", conditionMessage(e), call. = FALSE)
  })
  if (httr2::resp_status(resp) != 200L || !file.exists(staging) || file.size(staging) == 0) {
    stop("ACS download did not return a complete, nonempty HTTP 200 response: ", url)
  }
  header <- tryCatch(names(data.table::fread(staging, nrows = 0L, showProgress = FALSE)),
                     error = function(e) character())
  if (!"GEO_ID" %in% header || !any(grepl("^[BC][0-9]{5}[A-Z]*_E[0-9]+$", header))) {
    stop("Downloaded file is not an ACS summary table: ", url)
  }
  if (cached) {
    saveRDS(list(version = 1L, url = url, size = unname(file.size(staging)),
                 md5 = unname(tools::md5sum(staging))), marker_tmp)
  }
  # Only an absent or unverified entry reaches here; verified files are reused above.
  # Windows cannot replace an existing file by rename. The lock protects this fallback.
  publish <- function(from, to) {
    if (.Platform$OS.type == "windows" && file.exists(to)) unlink(to)
    if (!file.rename(from, to)) stop("Could not publish ACS download: ", to)
  }
  publish(staging, dest)
  if (cached) publish(marker_tmp, marker)
  normalizePath(dest, mustWork = TRUE)
}


# A valid cache entry must be from a completed transfer of this exact URL and
# still have the recorded contents. Legacy nonempty files alone are not trusted.
.acs_cache_valid <- function(path, url) {
  tryCatch({
    record <- readRDS(paste0(path, ".complete.rds"))
    is.list(record) && identical(record$version, 1L) && identical(record$url, url) &&
      file.exists(path) && isTRUE(file.size(path) > 0) &&
      identical(unname(file.size(path)), record$size) &&
      identical(unname(tools::md5sum(path)), record$md5)
  }, error = function(e) FALSE, warning = function(w) FALSE)
}


#' Download many ACS URLs concurrently when future.apply is available;
#' otherwise sequentially.
#'
#' @param urls character vector of URLs to fetch
#' @param cache_dir see `acs_download_one()`
#' @param timeout_sec see `acs_download_one()`
#' @param max_retries see `acs_download_one()`
#' @param parallel logical; when TRUE and {future, future.apply} are
#'   installed, run downloads via `future.apply::future_lapply()`. The
#'   caller is responsible for setting a `future::plan()` (e.g.
#'   `future::plan(future::multisession, workers = 4)`).
#' @param quiet if FALSE (and `cli` is installed), show a progress bar over
#'   the sequential downloads. Ignored for parallel downloads.
#' @returns character vector of local file paths, in input order
#' @keywords internal
#' @noRd
acs_download_many <- function(urls,
                              cache_dir   = NULL,
                              timeout_sec = getOption("ACSdownload.timeout", 300),
                              max_retries = getOption("ACSdownload.retries", 3),
                              parallel    = FALSE,
                              quiet       = FALSE) {

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

  # Sequential path, with an optional cli progress bar.
  show_progress <- !quiet &&
    length(urls) > 1L &&
    requireNamespace("cli", quietly = TRUE)

  if (show_progress) {
    out <- character(length(urls))
    cli::cli_progress_bar("Downloading ACS tables", total = length(urls))
    for (i in seq_along(urls)) {
      out[i] <- do_one(urls[i])
      cli::cli_progress_update()
    }
    cli::cli_progress_done()
    return(out)
  }

  unlist(lapply(urls, do_one))
}
