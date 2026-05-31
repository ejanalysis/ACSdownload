test_that("acsdefaultendyearhere is a single year >= acsfirstyearavailablehere", {
  expect_length(acsdefaultendyearhere, 1L)
  expect_true(is.numeric(acsdefaultendyearhere))
  expect_gte(as.integer(acsdefaultendyearhere),
             as.integer(acsfirstyearavailablehere))
})

test_that("acs_endyear_like_ejam falls back to local estimator when EJAM is absent", {
  # We can't conditionally uninstall EJAM in a test, so just exercise the
  # path and assert the output shape.
  out <- acs_endyear_like_ejam(as.Date("2026-05-31"))
  expect_type(out, "character")
  expect_length(out, 1L)
  expect_match(out, "^[0-9]{4}$")
})

test_that("acs_endyear_like_ejam returns the latest known release before the as-of date", {
  # The 2020-2024 release date is 2026-01-29 (an actual delay; embedded in
  # the lookup table). Asking as-of 2026-02-01 should produce "2024";
  # asking as-of 2025-12-13 should produce "2023" (the 2019-2023 vintage,
  # released 2024-12-12).
  if (!requireNamespace("EJAM", quietly = TRUE)) {
    expect_equal(acs_endyear_like_ejam(as.Date("2026-02-01")), "2024")
    expect_equal(acs_endyear_like_ejam(as.Date("2025-12-13")), "2023")
  } else {
    # EJAM is installed; just check we got something sane.
    expect_true(acs_endyear_like_ejam(as.Date("2026-02-01")) %in% as.character(2022:2024))
  }
})

test_that("ejscreen_acs_tables matches EJAM ACS2024 length and includes the tract-only tables", {
  # 16 entries, EJAM-ordered, with B17017 + B28002 (the EJAM-corrected
  # tables) and C16001, B18101 at the end (tract-only).
  expect_length(ejscreen_acs_tables, 16L)
  expect_true(all(c("B17017", "B28002", "C16001", "B18101") %in%
                  ejscreen_acs_tables))
  # B28003 is the legacy choice; EJAM replaced it with B28002. We must NOT
  # ship the legacy choice anymore.
  expect_false("B28003" %in% ejscreen_acs_tables)
})
