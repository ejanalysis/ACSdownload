test_that("sumlevel_from_fipstype maps every supported type", {
  expect_equal(sumlevel_from_fipstype("state"),      "040")
  expect_equal(sumlevel_from_fipstype("county"),     "050")
  expect_equal(sumlevel_from_fipstype("city"),       "160")
  expect_equal(sumlevel_from_fipstype("tract"),      "140")
  expect_equal(sumlevel_from_fipstype("blockgroup"), "150")
  expect_equal(sumlevel_from_fipstype("REGION"),     "020")
  expect_equal(sumlevel_from_fipstype("MSA"),        "310")
  expect_equal(sumlevel_from_fipstype("CSA"),        "330")
  expect_equal(sumlevel_from_fipstype("ZCTA"),       "860")
  expect_equal(sumlevel_from_fipstype("Urban Area"), "400")
  expect_equal(sumlevel_from_fipstype("Congressional District"), "500")
})

test_that("sumlevel_from_fipstype is case-insensitive on input", {
  expect_equal(sumlevel_from_fipstype("REGION"),
               sumlevel_from_fipstype("region"))
  expect_equal(sumlevel_from_fipstype("BLOCKGROUP"),
               sumlevel_from_fipstype("blockgroup"))
})

test_that("sumlevel_from_fipstype always returns 3-character codes (matches sumlevel_from_geoid output)", {
  out <- sumlevel_from_fipstype(c("state", "REGION", "blockgroup", "ZCTA"))
  expect_true(all(nchar(out) == 3))
})

test_that("sumlevel_from_fipstype returns NA for unsupported and for block", {
  expect_true(is.na(sumlevel_from_fipstype("block")))
  expect_true(is.na(sumlevel_from_fipstype("not a type")))
})

test_that("fipstype_from_sumlevel round-trips with sumlevel_from_fipstype", {
  types <- c("state", "county", "city", "tract", "blockgroup",
             "REGION", "MSA", "CSA", "Urban Area",
             "Congressional District", "ZCTA")
  expect_equal(fipstype_from_sumlevel(sumlevel_from_fipstype(types)), types)
})
