# Offline cache tests; transport retries are exercised below httr2's retry loop.
acs_test_body <- "GEO_ID|B01001_E001\n1500000US010010201001|42"

mock_acs_transfer <- function(body = acs_test_body) {
  calls <- new.env(parent = emptyenv())
  calls$n <- 0L
  calls$perform <- function(req, path) {
    calls$n <- calls$n + 1L
    writeLines(body, path)
    httr2::response(200)
  }
  calls
}

test_that("only verified completed downloads are reused", {
  cache <- withr::local_tempdir()
  url <- "https://example.invalid/a.dat"
  dest <- file.path(cache, "a.dat")
  writeLines("legacy partial file", dest)
  calls <- mock_acs_transfer()
  local_mocked_bindings(req_perform = calls$perform, .package = "httr2")
  out <- ACSdownload:::acs_download_one(url, cache, max_retries = 0)
  expect_equal(calls$n, 1L)
  expect_equal(readLines(out), strsplit(acs_test_body, "\n")[[1]])
  expect_true(ACSdownload:::.acs_cache_valid(out, url))
  expect_equal(ACSdownload:::acs_download_one(url, cache), out)
  expect_equal(calls$n, 1L)
  # Same length corruption must also be detected.
  writeLines(sub("42", "99", acs_test_body), dest)
  ACSdownload:::acs_download_one(url, cache)
  expect_equal(calls$n, 2L)
  ACSdownload:::acs_download_one("https://another.invalid/a.dat", cache)
  expect_equal(calls$n, 3L)
  expect_false(any(grepl("^\\.acs-", list.files(cache, all.files = TRUE))))
})

test_that("failed transfers preserve prior files and remove staging files", {
  cache <- withr::local_tempdir()
  dest <- file.path(cache, "a.dat")
  writeLines("unverified old file", dest)
  local_mocked_bindings(req_perform = function(req, path) {
    writeLines(acs_test_body, path)
    stop("connection interrupted")
  }, .package = "httr2")
  expect_error(ACSdownload:::acs_download_one("https://example.invalid/a.dat", cache),
               "failed to download ACS file")
  expect_equal(readLines(dest), "unverified old file")
  expect_false(file.exists(paste0(dest, ".complete.rds")))
  expect_false(any(grepl("^\\.acs-", list.files(cache, all.files = TRUE))))
})

test_that("HTML errors cannot become completed cache files", {
  cache <- withr::local_tempdir()
  calls <- mock_acs_transfer("<html>Server error</html>")
  local_mocked_bindings(req_perform = calls$perform, .package = "httr2")
  expect_error(ACSdownload:::acs_download_one("https://example.invalid/a.dat", cache),
               "not an ACS summary table")
  expect_false(file.exists(file.path(cache, "a.dat")))
})

test_that("download_many preserves input order", {
  cache <- withr::local_tempdir()
  calls <- mock_acs_transfer()
  local_mocked_bindings(req_perform = calls$perform, .package = "httr2")
  urls <- paste0("https://example.invalid/", c("c", "a", "b"), ".dat")
  paths <- ACSdownload:::acs_download_many(urls, cache, quiet = TRUE)
  expect_equal(basename(paths), basename(urls))
})

test_that("transport failures retry", {
  calls <- 0L
  local_mocked_bindings(req_perform1 = function(req, req_prep, path, ...) {
    calls <<- calls + 1L
    if (calls == 1L) return(structure(list(message = "connection reset", call = NULL),
                                    class = c("httr2_failure", "error", "condition")))
    writeLines(acs_test_body, path)
    httr2::response(200)
  }, .package = "httr2")
  path <- ACSdownload:::acs_download_one("https://example.invalid/a.dat", max_retries = 1)
  withr::defer(unlink(path))
  expect_equal(calls, 2L)
  expect_equal(readLines(path), strsplit(acs_test_body, "\n")[[1]])
})

test_that("permanent HTTP errors do not retry", {
  calls <- 0L
  local_mocked_bindings(req_perform1 = function(...) {
    calls <<- calls + 1L
    httr2::response(404)
  }, .package = "httr2")
  expect_error(ACSdownload:::acs_download_one("https://example.invalid/a.dat", max_retries = 3),
               "up to 4 attempts")
  expect_equal(calls, 1L)
})
