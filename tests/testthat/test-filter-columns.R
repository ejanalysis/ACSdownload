make_fake <- function(tabname, n = 3) {
  cols <- c(
    "GEO_ID", "fips", "SUMLEVEL",
    paste0(tabname, "_",  sprintf("%03d", seq_len(n))),  # estimates
    paste0(tabname, "_M", sprintf("%03d", seq_len(n))),  # MOE
    paste0(tabname, "_EA", sprintf("%03d", seq_len(n))), # estimate annotation
    paste0(tabname, "_MA", sprintf("%03d", seq_len(n)))  # MOE annotation
  )
  data.table::as.data.table(
    setNames(replicate(length(cols), 1:2, simplify = FALSE), cols)
  )
}

test_that("default keep_moe=TRUE / no variables / no annotations behavior", {
  tl <- list(B01001 = make_fake("B01001"))
  out <- ACSdownload:::.filter_acs_columns(tl)
  expect_setequal(
    names(out$B01001),
    c("GEO_ID", "fips", "SUMLEVEL",
      "B01001_001", "B01001_002", "B01001_003",
      "B01001_M001", "B01001_M002", "B01001_M003")
  )
})

test_that("variables filter keeps only the requested estimate columns + their MOE", {
  tl <- list(B01001 = make_fake("B01001"))
  out <- ACSdownload:::.filter_acs_columns(
    tl, variables = c("B01001_001", "B01001_003")
  )
  expect_setequal(
    names(out$B01001),
    c("GEO_ID", "fips", "SUMLEVEL",
      "B01001_001", "B01001_003",
      "B01001_M001", "B01001_M003")
  )
})

test_that("keep_moe=FALSE drops the MOE columns", {
  tl <- list(B01001 = make_fake("B01001"))
  out <- ACSdownload:::.filter_acs_columns(tl, keep_moe = FALSE)
  expect_false(any(grepl("_M[0-9]+$", names(out$B01001))))
  expect_true(all(c("B01001_001", "B01001_002", "B01001_003") %in% names(out$B01001)))
})

test_that("keep_annotations=TRUE keeps the EA/MA columns", {
  tl <- list(B01001 = make_fake("B01001"))
  out <- ACSdownload:::.filter_acs_columns(tl, keep_annotations = TRUE)
  expect_true(any(grepl("_EA[0-9]+$", names(out$B01001))))
  expect_true(any(grepl("_MA[0-9]+$", names(out$B01001))))
})

test_that("bookkeeping columns are always retained", {
  tl <- list(B01001 = make_fake("B01001"))
  out <- ACSdownload:::.filter_acs_columns(tl, variables = "ZZ_NONE")
  expect_setequal(names(out$B01001), c("GEO_ID", "fips", "SUMLEVEL"))
})
