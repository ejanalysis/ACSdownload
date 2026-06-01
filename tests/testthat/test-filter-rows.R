# Non-network tests for .filter_rows_by_fips_codes(): a fips code's width can
# collide across geography levels (county 01001 vs ZCTA 01001), so the filter
# must combine the suffix match with the inferred SUMLEVEL.

make_multilevel <- function() {
  data.table::data.table(
    GEO_ID   = c("0500000US01001", "8600000US01001",
                 "0500000US06037", "0400000US01"),
    fips     = c("01001", "01001", "06037", "01"),
    SUMLEVEL = c("050", "860", "050", "040"),  # county, ZCTA, county, state
    B19301_001 = c(10, 20, 30, 40)
  )
}

test_that("a 5-digit code returns only the county, not the same-suffix ZCTA", {
  dt <- make_multilevel()
  out <- ACSdownload:::.filter_rows_by_fips_codes(dt, "01001")
  expect_equal(nrow(out), 1L)
  expect_equal(out$SUMLEVEL, "050")
  expect_equal(out$GEO_ID, "0500000US01001")
})

test_that("a 2-digit code returns only the state level", {
  dt <- make_multilevel()
  out <- ACSdownload:::.filter_rows_by_fips_codes(dt, "01")
  expect_equal(nrow(out), 1L)
  expect_equal(out$SUMLEVEL, "040")
})

test_that("multiple county codes return only those counties", {
  dt <- make_multilevel()
  out <- ACSdownload:::.filter_rows_by_fips_codes(dt, c("01001", "06037"))
  expect_setequal(out$fips, c("01001", "06037"))
  expect_true(all(out$SUMLEVEL == "050"))
})

test_that("tract-width codes infer SUMLEVEL 140", {
  dt <- data.table::data.table(
    GEO_ID   = c("1400000US01001020100", "1500000US010010201001"),
    fips     = c("01001020100", "010010201001"),
    SUMLEVEL = c("140", "150"),  # tract, blockgroup
    B19301_001 = c(1, 2)
  )
  out <- ACSdownload:::.filter_rows_by_fips_codes(dt, "01001020100")
  expect_equal(nrow(out), 1L)
  expect_equal(out$SUMLEVEL, "140")
})
