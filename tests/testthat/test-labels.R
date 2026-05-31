test_that("acs_label returns a data.table with the expected columns", {
  out <- acs_label("B01001_001")
  expect_s3_class(out, "data.table")
  expect_named(
    out,
    c("variable_id", "table_id", "label", "table_title", "universe")
  )
  expect_equal(out$variable_id, "B01001_001")
  expect_equal(out$table_id, "B01001")
  expect_match(out$label, "Total", fixed = TRUE)
})

test_that("acs_label normalizes margin-of-error variable codes", {
  est <- acs_label("B01001_001")
  moe <- acs_label("B01001_M001")
  expect_equal(moe$label,       est$label)
  expect_equal(moe$table_id,    est$table_id)
  expect_equal(moe$table_title, est$table_title)
})

test_that("acs_label returns NA for unknown codes but preserves the input", {
  out <- acs_label(c("B01001_001", "BOGUS_001"))
  expect_equal(out$variable_id, c("B01001_001", "BOGUS_001"))
  expect_true(is.na(out$label[2]))
  expect_true(is.na(out$table_id[2]))
})

test_that("acs_label is vectorized over variable_id", {
  out <- acs_label(c("B01001_001", "B01001_002", "C16001_002"))
  expect_equal(nrow(out), 3L)
  expect_equal(out$variable_id, c("B01001_001", "B01001_002", "C16001_002"))
})
