test_that("selective parsing preserves values, columns and geography filtering", {
  cache <- withr::local_tempdir()
  raw <- data.table::data.table(
    GEO_ID = c("0500000US01001", "0500000US01003", "1500000US010010201001"),
    B06004APR_E001 = c(1, 2, 3), B06004APR_E002 = c(4, NA, 6),
    B06004APR_M001 = c(7, 8, 9), B06004APR_M002 = c(10, 11, 12),
    B06004APR_EA001 = c("", "(X)", ""), B06004APR_MA001 = c("", "", "(X)"))
  path <- file.path(cache, "table.dat")
  data.table::fwrite(raw, path, sep = "|")
  local_mocked_bindings(acs_download_many = function(...) path, .package = "ACSdownload")
  for (moe in c(FALSE, TRUE)) for (ann in c(FALSE, TRUE)) {
    for (vars in list(NULL, "B06004APR_002", "absent")) {
      for (geo in list(NULL, "county", "01001")) {
        out <- suppressWarnings(get_acs_new(tables = "B06004APR", yr = 2023,
          fips = geo, variables = vars, keep_moe = moe, keep_annotations = ann))[[1]]
        expected <- data.table::fread(path)
        data.table::setnames(expected, sub("_E([0-9]+)$", "_\\1", names(expected)))
        expected$fips <- c("01001", "01003", "010010201001")
        expected$SUMLEVEL <- c("050", "050", "150")
        data.table::setcolorder(expected, c("GEO_ID", "fips", "SUMLEVEL"))
        cols <- c("GEO_ID", "fips", "SUMLEVEL")
        estimates <- c("B06004APR_001", "B06004APR_002")
        if (!is.null(vars)) estimates <- intersect(estimates, vars)
        cols <- c(cols, estimates)
        if (moe) cols <- c(cols, sub("_([0-9]+)$", "_M\\1", estimates))
        if (ann) cols <- c(cols, "B06004APR_EA001", "B06004APR_MA001")
        expected <- expected[, .SD, .SDcols = cols]
        if (identical(geo, "county")) expected <- expected[1:2]
        if (identical(geo, "01001")) expected <- expected[1]
        expect_equal(out, expected)
      }
    }
  }
})

test_that("temporary download directories are removed on success and failure", {
  download_dir <- NULL
  local_mocked_bindings(acs_download_many = function(urls, cache_dir, ...) {
    download_dir <<- cache_dir
    path <- file.path(cache_dir, "fixture.dat")
    writeLines("GEO_ID|B01001_E001\n0500000US01001|1", path)
    path
  }, .package = "ACSdownload")
  get_acs_new(tables = "B01001", yr = 2023, fips = "county", cache_dir = NULL)
  expect_false(dir.exists(download_dir))
  local_mocked_bindings(acs_download_many = function(urls, cache_dir, ...) {
    download_dir <<- cache_dir
    writeLines("partial", file.path(cache_dir, "partial"))
    stop("failed transfer")
  }, .package = "ACSdownload")
  expect_error(get_acs_new(tables = "B01001", yr = 2023, cache_dir = NULL), "failed transfer")
  expect_false(dir.exists(download_dir))
})
