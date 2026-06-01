test_that("sumlevel_from_geoid extracts the first 3 chars", {
  expect_equal(
    ACSdownload:::sumlevel_from_geoid(c("1500000US010010201001",
                                       "1400000US01001020100",
                                       "0500000US01001",
                                       "0400000US01")),
    c("150", "140", "050", "040")
  )
})

test_that("fips_from_geoid extracts the substring after 'US'", {
  geoids <- c(
    "1500000US010010201001",   # blockgroup
    "1400000US01001020100",    # tract
    "0500000US01001",          # county
    "8600000US00601",          # ZCTA (5 digits, NOT a county; the disagreement-NA bug)
    "0400000US01",             # state
    "0200000US1"               # REGION (1 digit)
  )
  expect_equal(
    ACSdownload:::fips_from_geoid(geoids),
    c("010010201001", "01001020100", "01001", "00601", "01", "1")
  )
})

test_that("fips_from_geoid returns NA for inputs without an 'US' delimiter", {
  expect_true(is.na(ACSdownload:::fips_from_geoid("junk-without-marker")))
})

test_that("fips_from_geoid returns NA for inputs with empty fips suffix", {
  expect_true(is.na(ACSdownload:::fips_from_geoid("1500000US")))
})

test_that("fips_lead_zero_acs restores leading zeros for standard widths", {
  expect_equal(
    ACSdownload:::fips_lead_zero_acs(c("1", "100", "1000", "100000", "10000000", "1000000000000")),
    # 1 -> 01 (state), 100 stays NA (3-char invalid), 1000 -> 01000 (county),
    # 100000 -> 0100000 (city), 10000000 -> NA (8-char invalid),
    # 1000000000000 -> NA (13-char invalid)
    c("01", NA, "01000", "0100000", NA, NA)
  )
})

test_that("fips_lead_zero_acs resolves 11-digit codes via the state-FIPS heuristic", {
  # Tract reading valid (state 01), blockgroup reading impossible ("00"):
  # unambiguously a tract -> left as-is, no warning.
  expect_silent(
    out <- ACSdownload:::fips_lead_zero_acs("01001020100")
  )
  expect_equal(out, "01001020100")

  # Blockgroup-missing-zero: tract reading "90" is not a valid state but the
  # blockgroup reading "09" (Connecticut) is -> restore the leading zero.
  expect_equal(
    ACSdownload:::fips_lead_zero_acs("90010201001"),
    "090010201001"
  )

  # Genuinely ambiguous (state 40 tract vs state 04 blockgroup): default to
  # tract, and warn only when not quiet.
  expect_equal(
    ACSdownload:::fips_lead_zero_acs("40131165002", quiet = TRUE),
    "40131165002"
  )
  expect_warning(
    ACSdownload:::fips_lead_zero_acs("40131165002", quiet = FALSE),
    "ambiguous"
  )

  # Neither reading is a valid state -> NA.
  expect_true(is.na(
    suppressWarnings(ACSdownload:::fips_lead_zero_acs("70123456789"))
  ))
})

test_that("fips_lead_zero_acs uses an authoritative tract list when supplied", {
  tracts <- c("40131165002")  # pretend this exact 11-digit value is a real tract
  # In the table, the value stays a tract.
  expect_equal(
    ACSdownload:::fips_lead_zero_acs("40131165002", tract_fips = tracts),
    "40131165002"
  )
  # Not in the table -> treated as a blockgroup missing its leading zero.
  expect_equal(
    ACSdownload:::fips_lead_zero_acs("40131165003", tract_fips = tracts),
    "040131165003"
  )
})

test_that("fipstype_acs classifies by width after leading-zero restoration", {
  suppressWarnings({
    expect_equal(
      ACSdownload:::fipstype_acs(c("01", "01001", "01001020100",
                                   "010010201001", "010010201001001")),
      c("state", "county", "tract", "blockgroup", "block")
    )
  })
})
