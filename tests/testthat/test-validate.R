test_that("validate_acs_tables uppercases and accepts canonical patterns", {
  expect_equal(
    ACSdownload:::validate_acs_tables(c("b01001", "C17002", "B03002H")),
    c("B01001", "C17002", "B03002H")
  )
})

test_that("validate_acs_tables accepts Puerto Rico (PR) table suffixes", {
  expect_equal(
    ACSdownload:::validate_acs_tables(c("b05001pr", "B06001PR", "B06004APR")),
    c("B05001PR", "B06001PR", "B06004APR")
  )
})

test_that("validate_acs_tables rejects empty input and bad codes", {
  expect_error(ACSdownload:::validate_acs_tables(character(0)),
               "must contain at least one")
  expect_error(ACSdownload:::validate_acs_tables(c("B01001", "XX")),
               "invalid ACS table code")
  expect_error(ACSdownload:::validate_acs_tables(c("B01001", NA)), "NA")
  expect_error(ACSdownload:::validate_acs_tables(c("B01001", "")), "empty")
  expect_error(ACSdownload:::validate_acs_tables("B999999"),
               "invalid ACS table code")  # 6 digits not 5
  # A lone trailing "P" is not the PR suffix.
  expect_error(ACSdownload:::validate_acs_tables("B05001P"),
               "invalid ACS table code")
})

test_that("validate_fiveorone accepts 1 or 5 as char or numeric", {
  expect_equal(ACSdownload:::validate_fiveorone(5),   "5")
  expect_equal(ACSdownload:::validate_fiveorone("5"), "5")
  expect_equal(ACSdownload:::validate_fiveorone(1),   "1")
  expect_error(ACSdownload:::validate_fiveorone(3),  "must be 1 or 5")
  expect_error(ACSdownload:::validate_fiveorone(c(1, 5)), "single value")
})

test_that("validate_fips_arg accepts NULL, a single type name, or a numeric fips vector", {
  expect_null(ACSdownload:::validate_fips_arg(NULL))
  expect_equal(ACSdownload:::validate_fips_arg("blockgroup"), "blockgroup")
  expect_equal(
    ACSdownload:::validate_fips_arg(c("01001", "06037")),
    c("01001", "06037")
  )
})

test_that("validate_fips_arg restores leading zeros lost by numeric input", {
  # A bare numeric county code missing its leading zero.
  expect_equal(ACSdownload:::validate_fips_arg(1001), "01001")
  expect_equal(
    ACSdownload:::validate_fips_arg(c(1001, 6037)),
    c("01001", "06037")
  )
  # Character codes missing a zero are normalized too, and a mix of
  # zero-padded and unpadded forms of the SAME geography is not a width mix.
  expect_equal(
    ACSdownload:::validate_fips_arg(c("1001", "01001")),
    c("01001", "01001")
  )
  # A 10-digit tract code (leading zero lost) normalizes to the 11-char form.
  expect_equal(ACSdownload:::validate_fips_arg(1001020100), "01001020100")
})

test_that("validate_fips_arg leaves 11-digit codes alone (tract vs blockgroup is ambiguous)", {
  # 11 digits could be a complete tract OR a blockgroup missing its leading
  # zero; fips_lead_zero_acs() cannot disambiguate, so the value is returned
  # as-is (treated as a tract). Pass blockgroups as the full 12-char string.
  expect_equal(ACSdownload:::validate_fips_arg("10010201001"), "10010201001")
  expect_equal(ACSdownload:::validate_fips_arg("010010201001"), "010010201001")
})

test_that("validate_fips_arg coerces large numeric fips without scientific notation", {
  # as.character(100000) is "1e+05"; the validator must avoid that.
  expect_equal(ACSdownload:::validate_fips_arg(100000), "0100000")  # 7-digit place
})

test_that("validate_fips_arg rejects codes with impossible digit widths", {
  expect_error(ACSdownload:::validate_fips_arg("100"),       # 3 digits
               "invalid number of digits")
  expect_error(ACSdownload:::validate_fips_arg(c("01001", "12345678")),  # 8 digits
               "invalid number of digits")
})

test_that("validate_fips_arg rejects mixed type-name + codes", {
  expect_error(
    ACSdownload:::validate_fips_arg(c("blockgroup", "01001")),
    "mixes a known geography type name"
  )
})

test_that("validate_fips_arg rejects multiple type names", {
  expect_error(
    ACSdownload:::validate_fips_arg(c("blockgroup", "tract")),
    "only one type of geography"
  )
})

test_that("validate_fips_arg rejects non-numeric junk in a fips vector", {
  expect_error(
    ACSdownload:::validate_fips_arg(c("01001", "not_a_fips")),
    "neither a recognized geography type name nor numeric fips codes"
  )
})

test_that("validate_fips_arg rejects a mix of fips widths (different geography types)", {
  # 5-digit county + 11-digit tract => two SUMLEVELs would leak through.
  expect_error(
    ACSdownload:::validate_fips_arg(c("01001", "01001020100")),
    "mixes codes of differing widths"
  )
  # All-same-width vectors still pass unchanged.
  expect_equal(
    ACSdownload:::validate_fips_arg(c("01001", "06037", "36061")),
    c("01001", "06037", "36061")
  )
  expect_equal(
    ACSdownload:::validate_fips_arg(c("010010201001", "060372011001")),
    c("010010201001", "060372011001")
  )
})

test_that("validate_acs_endyear bounds-check uses package data floor", {
  expect_equal(ACSdownload:::validate_acs_endyear(2024), "2024")
  expect_equal(ACSdownload:::validate_acs_endyear("2024"), "2024")
  expect_error(
    ACSdownload:::validate_acs_endyear(2010),
    "outside the supported range"
  )
  expect_error(
    ACSdownload:::validate_acs_endyear("not a year"),
    "parseable as an integer year"
  )
  expect_error(
    ACSdownload:::validate_acs_endyear(c(2024, 2025)),
    "single non-NA value"
  )
})
