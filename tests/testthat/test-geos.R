# Non-network tests for the geography-filter logic in get_acs_new_geos().
# These guard the integer-vs-zero-padded-string SUMLEVEL mismatch (the Geos
# file stores SUMLEVEL as an integer like 50; sumlevel_from_fipstype() returns
# "050"). We exercise the same comparison the function uses, without hitting
# the network, by stubbing the data.table that fread() would have returned.

make_fake_geos <- function() {
  data.table::data.table(
    STUSAB   = c("AL", "AL", "AL", "AL"),
    SUMLEVEL = c(40L, 50L, 140L, 150L),  # integer, as fread reads the file
    GEO_ID   = c("0400000US01", "0500000US01001",
                 "1400000US01001020100", "1500000US010010201001"),
    NAME     = c("Alabama", "Autauga County, Alabama",
                 "Census Tract 201", "Block Group 1")
  )
}

test_that("integer SUMLEVEL matches the zero-padded string from sumlevel_from_fipstype", {
  geos <- make_fake_geos()
  geos[, fips := ACSdownload:::fips_from_geoid(GEO_ID)]

  # This is the comparison get_acs_new_geos() performs internally.
  want <- as.integer(sumlevel_from_fipstype("county"))
  filtered <- geos[as.integer(SUMLEVEL) %in% want, ]

  expect_equal(nrow(filtered), 1L)
  expect_equal(filtered$fips, "01001")
})

test_that("each supported single-resolution type selects exactly its rows", {
  geos <- make_fake_geos()
  for (type in c("state", "county", "tract", "blockgroup")) {
    want <- as.integer(sumlevel_from_fipstype(type))
    n <- nrow(geos[as.integer(SUMLEVEL) %in% want, ])
    expect_equal(n, 1L, info = type)
  }
})
