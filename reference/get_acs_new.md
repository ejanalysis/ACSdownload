# Get full USA ACS data by table and fips (table-based summary file format)

Downloads ACS 5-year data for the requested tables and either a single
geography type (e.g. "blockgroup") or a vector of specific fips codes.
Returns either a list of one data.table per table (the default) or a
single merged data.table.

## Usage

``` r
get_acs_new(
  tables = ejscreen_acs_tables,
  fips = "blockgroup",
  yr = acsdefaultendyearhere,
  fiveorone = "5",
  return_list_not_merged = TRUE,
  cache_dir = getOption("ACSdownload.cache_dir", NULL),
  timeout_sec = getOption("ACSdownload.timeout", 300),
  max_retries = getOption("ACSdownload.retries", 3),
  parallel = FALSE,
  variables = NULL,
  keep_moe = TRUE,
  keep_annotations = FALSE,
  quiet = FALSE
)
```

## Arguments

- tables:

  vector of ACS data table codes like "B01001" or "C17002".
  Race/ethnicity-suffixed (e.g. "B03002H") and Puerto Rico Community
  Survey tables (e.g. "B05001PR", "B06004APR") are also accepted. Some
  EJSCREEN tables are only published at tract resolution (notably
  "C16001" for detailed languages spoken at home and "B18101" for
  disability); when `return_list_not_merged = FALSE` and
  `fips = "blockgroup"`, those tables filter to zero rows and are
  dropped from the merge with a warning.

- fips:

  one of:

  - a single geography type name: "blockgroup", "tract", "county",
    "state", "city", "REGION", "MSA", "CSA", "Urban Area",
    "Congressional District", "ZCTA", or "American Indian Area/Alaska
    Native Area/Hawaiian Home Land" (only "blockgroup", "tract",
    "county", "state", "city" are well-tested);

  - a vector of fips codes (all the same width / geography type).
    Numeric codes are normalized to canonical Census widths (e.g. `1001`
    becomes `"01001"`). The geography level is inferred from the code
    width and applied as a SUMLEVEL filter so results are not mixed
    across levels that share a code suffix; a 5-digit code is treated as
    a **county** (not a ZCTA). To pull ZCTAs, use `fips = "ZCTA"`.

  - `NULL` for no row filtering.

- yr:

  end year of the 5-year ACS summary file (e.g. 2024 for the 2020-2024
  survey released by Census Bureau Jan. 2026). Validated against
  `acsfirstyearavailablehere` (the floor) and `current_year + 1` (the
  ceiling); bad values fail before any HTTP call.

- fiveorone:

  1 or 5; only the 5-year sample is tested here.

- return_list_not_merged:

  if `TRUE` (the default) return a named list with one data.table per
  requested table; if `FALSE`, merge all tables on `fips` and return a
  single data.table.

- cache_dir:

  optional path to a directory in which to persist the downloaded .dat
  files. The table-based SF files are immutable once a vintage ships, so
  caching is safe and dramatically speeds up repeat calls. Defaults to
  `getOption("ACSdownload.cache_dir", NULL)`.

- timeout_sec:

  per-request timeout in seconds for each .dat download. Defaults to
  `getOption("ACSdownload.timeout", 300)`.

- max_retries:

  number of retry attempts after the first for transient HTTP failures
  (HTTP 429 and 5xx). Defaults to `getOption("ACSdownload.retries", 3)`.

- parallel:

  if `TRUE` and both `future` and `future.apply` are installed, fetch
  the .dat files concurrently. The caller must set a
  [`future::plan()`](https://future.futureverse.org/reference/plan.html)
  first.

- variables:

  optional character vector of specific estimate variable codes to keep,
  like `c("B25034_001", "B25034_002")`. Names are matched in the
  post-rename form (no `_E` infix). When NULL (the default), all
  estimate columns from the requested tables are kept.

- keep_moe:

  if `TRUE` (the default), keep the margin-of-error columns
  (`<table>_M<nnn>`); if `FALSE`, drop them.

- keep_annotations:

  if `TRUE`, keep the annotation columns (`<table>_EA<nnn>`,
  `<table>_MA<nnn>`) that some vintages include; the default `FALSE`
  drops them.

- quiet:

  if `FALSE` (the default) and the `cli` package is installed, show a
  progress bar over the (sequential) downloads. Ignored when
  `parallel = TRUE`.

## Value

a named list of data.tables (one per table) or a single merged
data.table, each with `GEO_ID`, `fips`, `SUMLEVEL`, and the estimate
(`<table>_<nnn>`) and margin-of-error (`<table>_M<nnn>`) columns from
the Census file. Estimate column names have the leading "\_E" stripped
for compatibility with `EJAM::formulas_ejscreen_acs$formula`.

## Details

Targets the Census Bureau "table-based" summary file format introduced
for the 2018-2022 5-year survey (released December 2023) and used since.
See
<https://www.census.gov/programs-surveys/acs/data/summary-file.html>.

Downloads are made resilient by an httr2 retry/timeout layer
(`R/utils-download.R`); set `cache_dir` to persist files across calls
(recommended: `tools::R_user_dir("ACSdownload", "cache")`). With
`parallel = TRUE`, downloads run via
[`future.apply::future_lapply()`](https://future.apply.futureverse.org/reference/future_lapply.html)
– set a
[`future::plan()`](https://future.futureverse.org/reference/plan.html)
(e.g. `future::plan(future::multisession, workers = 4)`) before calling.

## Examples

``` r
 if (FALSE) { # \dontrun{
   x <- get_acs_new(yr = 2024, tables = "B25034", fips = "county")
   x[["B25034"]][1:3, 1:5]

   # Full EJSCREEN block-group pull (excluding the two tract-only tables):
   bg <- get_acs_new(
     yr = 2024,
     fips = "blockgroup",
     tables = setdiff(ejscreen_acs_tables, c("C16001", "B18101")),
     return_list_not_merged = FALSE,
     cache_dir = tools::R_user_dir("ACSdownload", "cache")
   )
 } # }
```
