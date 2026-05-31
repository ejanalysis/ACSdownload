# Live end-to-end tests that actually hit the Census Bureau. These are the
# canary for URL/format drift between ACS vintages. They are skipped on CRAN
# and when offline, and they fetch the smallest thing possible (a single
# small table filtered to one state) to stay quick.

skip_if_offline_census <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_offline("www2.census.gov")
  if (!requireNamespace("httr2", quietly = TRUE)) {
    testthat::skip("httr2 not installed")
  }
}

# Use a vintage we know is published. 2023 (the 2019-2023 release) has been
# available since 2024-12-12 and is stable.
LIVE_YR <- 2023L

test_that("get_acs_new fetches a single small table at county resolution", {
  skip_if_offline_census()

  cache <- withr::local_tempdir()
  res <- get_acs_new(
    yr        = LIVE_YR,
    tables    = "B19301",       # per capita income: 1 estimate + 1 MOE column
    fips      = "county",
    cache_dir = cache,
    quiet     = TRUE
  )

  expect_type(res, "list")
  expect_named(res, "B19301")
  dt <- res[["B19301"]]
  expect_s3_class(dt, "data.table")
  expect_true(all(c("GEO_ID", "fips", "SUMLEVEL", "B19301_001") %in% names(dt)))
  # ~3,221 counties; assert a sane lower bound rather than an exact count.
  expect_gt(nrow(dt), 3000L)
  expect_true(all(dt$SUMLEVEL == "050"))
})

test_that("get_acs_new merges two same-resolution tables on fips", {
  skip_if_offline_census()

  cache <- withr::local_tempdir()
  merged <- get_acs_new(
    yr        = LIVE_YR,
    tables    = c("B19301", "B01001"),
    fips      = "county",
    return_list_not_merged = FALSE,
    cache_dir = cache,
    quiet     = TRUE
  )
  expect_s3_class(merged, "data.table")
  expect_true("B19301_001" %in% names(merged))
  expect_true("B01001_001" %in% names(merged))
  # fips is the merge key and must be unique per county.
  expect_equal(anyDuplicated(merged$fips), 0L)
})

test_that("get_acs_new_geos returns named geographies for a vintage", {
  skip_if_offline_census()

  geos <- ACSdownload:::get_acs_new_geos(yr = LIVE_YR, fips = "county")
  expect_s3_class(geos, "data.table")
  expect_true(all(c("STUSAB", "SUMLEVEL", "GEO_ID", "fips") %in% names(geos)))
  # SUMLEVEL comes from the Geos file as an integer (50), not "050".
  expect_true(all(as.integer(geos$SUMLEVEL) == 50L))
  expect_gt(nrow(geos), 3000L)
})

test_that("get_acs_new errors clearly on a nonexistent table for the vintage", {
  skip_if_offline_census()

  # Valid-looking code that does not exist as a downloadable file.
  expect_error(
    get_acs_new(yr = LIVE_YR, tables = "B99999", fips = "county",
                cache_dir = NULL, timeout_sec = 30, max_retries = 0,
                quiet = TRUE),
    "failed to download|HTTP"
  )
})
