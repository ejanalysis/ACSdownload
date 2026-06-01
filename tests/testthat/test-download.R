# Download-layer tests. We avoid hitting Census by using httr2 mocking.

test_that("acs_download_one caches files and returns them on subsequent calls", {
  skip_if_not_installed("httr2")

  cache <- withr::local_tempdir()
  fake_url <- "https://example.invalid/acsdt5y2024-b01001.dat"
  dest <- file.path(cache, "acsdt5y2024-b01001.dat")
  writeLines("GEO_ID|B01001_E001\n1500000US000000000000|1\n", dest)

  # File already present in the cache -> no HTTP call required.
  out <- ACSdownload:::acs_download_one(fake_url, cache_dir = cache,
                                        timeout_sec = 5, max_retries = 0)
  expect_equal(normalizePath(out), normalizePath(dest))
})

test_that("acs_download_many returns paths in input order", {
  skip_if_not_installed("httr2")

  cache <- withr::local_tempdir()
  urls <- c("https://example.invalid/a.dat",
            "https://example.invalid/b.dat",
            "https://example.invalid/c.dat")
  for (u in urls) {
    writeLines("x", file.path(cache, basename(u)))
  }

  out <- ACSdownload:::acs_download_many(urls, cache_dir = cache,
                                         timeout_sec = 5, max_retries = 0,
                                         parallel = FALSE)
  expect_equal(basename(out), basename(urls))
})

test_that("acs_download_one wraps the failure with our message when httr2 cannot reach the host", {
  skip_if_not_installed("httr2")
  skip_on_cran()

  # An unrouteable host that should fail immediately, not slowly.
  expect_error(
    ACSdownload:::acs_download_one(
      "http://127.0.0.1:1/never_listens.dat",
      cache_dir   = NULL,
      timeout_sec = 2,
      max_retries = 0
    ),
    "failed to download"
  )
})
