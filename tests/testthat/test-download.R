# Offline cache tests and public-interface retry tests against a local HTTP server.
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

test_that("transport timeouts retry through the public HTTP interface", {
  skip_if_not_installed("webfakes")
  app <- webfakes::new_app()
  app$locals$n <- 0L
  app$get("/retry.dat", function(req, res) {
    if (is.null(res$locals$counted)) {
      req$app$locals$n <- req$app$locals$n + 1L
      res$locals$counted <- TRUE
      if (req$app$locals$n == 1L) return(res$delay(1.5))
    }
    res$send("GEO_ID|B01001_E001\n0500000US01001|42\n")
  })
  app$get("/count", function(req, res) res$send(as.character(req$app$locals$n)))
  server <- webfakes::new_app_process(app)
  withr::defer(server$stop())
  path <- ACSdownload:::acs_download_one(server$url("/retry.dat"),
                                        timeout_sec = 0.5, max_retries = 1)
  withr::defer(unlink(path))
  expect_equal(readLines(path), c("GEO_ID|B01001_E001", "0500000US01001|42"))
  count <- httr2::req_perform(httr2::request(server$url("/count")))
  expect_equal(httr2::resp_body_string(count), "2")
})

test_that("permanent HTTP errors do not retry", {
  skip_if_not_installed("webfakes")
  app <- webfakes::new_app()
  app$locals$n <- 0L
  app$get("/missing.dat", function(req, res) {
    req$app$locals$n <- req$app$locals$n + 1L
    res$set_status(404)$send("missing")
  })
  app$get("/count", function(req, res) res$send(as.character(req$app$locals$n)))
  server <- webfakes::new_app_process(app)
  withr::defer(server$stop())
  expect_error(ACSdownload:::acs_download_one(server$url("/missing.dat"), max_retries = 3),
               "up to 4 attempts")
  count <- httr2::req_perform(httr2::request(server$url("/count")))
  expect_equal(httr2::resp_body_string(count), "1")
})

test_that("verified cache hits need no writable lock file", {
  cache <- withr::local_tempdir()
  calls <- mock_acs_transfer()
  local_mocked_bindings(req_perform = calls$perform, .package = "httr2")
  url <- "https://example.invalid/a.dat"
  path <- ACSdownload:::acs_download_one(url, cache)
  local_mocked_bindings(lock = function(...) stop("cache is read-only"), .package = "filelock")
  expect_identical(ACSdownload:::acs_download_one(url, cache), path)
  expect_equal(calls$n, 1L)
})

test_that("lock budget covers retries and abandoned staging files are replaced", {
  cache <- withr::local_tempdir()
  url <- "https://example.invalid/a.dat"
  part <- file.path(cache, "a.dat.part")
  marker_part <- file.path(cache, "a.dat.complete.rds.part")
  writeLines("abandoned partial data", part)
  writeLines("abandoned record", marker_part)
  calls <- mock_acs_transfer()
  local_mocked_bindings(req_perform = calls$perform, .package = "httr2")
  real_lock <- filelock::lock
  wait_ms <- NULL
  local_mocked_bindings(lock = function(path, timeout, ...) {
    wait_ms <<- timeout
    real_lock(path, timeout = timeout, ...)
  }, .package = "filelock")
  path <- ACSdownload:::acs_download_one(url, cache, timeout_sec = 2, max_retries = 3)
  expect_gte(wait_ms, (4 * 2 + 2 + 4 + 8) * 1000)
  expect_true(ACSdownload:::.acs_cache_valid(path, url))
  expect_false(file.exists(part))
  expect_false(file.exists(marker_part))
})
