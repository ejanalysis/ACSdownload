test_that("url_acs_table returns general-info URL when fips is NULL or empty", {
  expect_equal(
    url_acs_table(tables = "B01001", fips = NULL, yr = 2024, fiveorone = 5),
    "https://data.census.gov/table/ACSDT5Y2024.B01001"
  )
  expect_equal(
    url_acs_table(tables = c("B01001", "C17002"), fips = "", yr = 2024),
    c(
      "https://data.census.gov/table/ACSDT5Y2024.B01001",
      "https://data.census.gov/table/ACSDT5Y2024.C17002"
    )
  )
})

test_that("url_acs_table builds a table-for-fips URL with sumlevel by type", {
  suppressWarnings({
    url <- url_acs_table(tables = "C16001", fips = "34023001419", yr = 2024)
  })
  expect_match(url, "data.census.gov/table\\?q=C16001")
  expect_match(url, "g=1400000US34023001419")  # tract -> sumlevel 140
  expect_match(url, "y=2024")
})

test_that("url_acs_table uses sumlevel 150 for blockgroup-width fips", {
  url <- url_acs_table(tables = "C16001", fips = "340230014191", yr = 2024)
  expect_match(url, "g=1500000US340230014191")
})
