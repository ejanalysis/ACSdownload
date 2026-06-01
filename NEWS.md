# ACSdownload 3.0.0

This is a major refactor. The pre-2022 sequence-file code path is gone;
only the table-based summary file format (introduced for the 2018-2022
vintage) is supported. The 2.x series remains on the `v2.4.0-pre-refactor`
tag for anyone who still needs the old path.

## Breaking changes

* `get_acs_old()` and every helper that supported the sequence-file
  format (downloading, parsing, geo-file parsing, NHGIS helpers, lookup
  tables, etc.) are removed. About 47 source files and a dozen `.rda`
  data objects were deleted.
* Minimum R version bumped to 4.0.
* `acsfirstyearavailablehere`: 2018 -> 2022 (the floor of what
  `get_acs_new()` can target).
* `acsdefaultendyearhere`: 2023 -> 2024 (the 2020-2024 ACS vintage,
  released by Census Bureau on 2026-01-29).
* `ejscreen_acs_tables` updated to mirror `EJAM::tables_ejscreen_acs`
  (the authoritative list) on the ACS2024 branch: 16 entries instead of
  15, adds `B17017`, replaces legacy `B28003` with `B28002`. Code that
  did `ejscreen_acs_tables[1:13]` to skip tract-only tables now wants
  `setdiff(ejscreen_acs_tables, c("C16001", "B18101"))` (or `[1:14]`).
* `data.table` is now properly declared in `Imports:` (was only in
  `NAMESPACE`); `magrittr` was removed from `Imports:` (unused).

## New features

* **Robust downloads.** `get_acs_new()` no longer bare-`fread()`s URLs.
  An `httr2`-backed download layer handles timeout, retry-with-backoff on
  transient HTTP failures, and optional caching:
  * `cache_dir` (default off) -- persist .dat files; subsequent calls
    are instant. Recommended:
    `tools::R_user_dir("ACSdownload", "cache")`.
  * `timeout_sec` (default 300) -- per-request timeout.
  * `max_retries` (default 3) -- retries on HTTP 429 / 5xx.
* **Optional parallel downloads.** `parallel = TRUE` fetches via
  `future.apply::future_lapply()` when both `future` and `future.apply`
  are installed; the caller is responsible for setting a `future::plan()`.
* **Fail-fast input validation.** Bad table codes, bad fips arguments,
  bad years are rejected before any HTTP call, with helpful messages.
* **Variable selection.** New `variables`, `keep_moe`,
  `keep_annotations` arguments let you trim columns at fetch time.
* **`acs_label()`** -- exported helper that turns variable codes
  (e.g. `"B01001_001"`) into human-readable labels, parent table titles,
  and population universes. Backed by a new bundled lookup
  `acs_table_shells` (28,331 rows, parsed from the official Census 2022
  5-year Table Shells file).
* **`acs_endyear_like_ejam()`** -- exported helper that returns the
  latest ACS 5-year end year Census Bureau has published. Prefers EJAM's
  own `acs_endyear()` when EJAM is installed (resolved dynamically from
  EJAM's namespace, so it works whether or not that build exports it),
  falling back to a self-contained estimator otherwise.
* **Progress + quiet.** `get_acs_new(quiet = FALSE)` shows a `cli`
  progress bar over sequential downloads when `cli` is installed.
* **`get_acs_old()`** is now a defunct shim: instead of "could not find
  function", callers get a clear error pointing at `get_acs_new()` and
  the `v2.4.0-pre-refactor` tag.

## Bug fixes

* 11-digit FIPS codes are now disambiguated instead of always being assumed
  to be tracts (and instead of an unconditional "ambiguous" warning). An
  11-digit value can be a complete tract or a 12-character blockgroup that
  lost its leading zero. `fips_lead_zero_acs()` now resolves this with a
  deterministic state-FIPS heuristic (a blockgroup only loses a leading zero
  when its state code is 01-09, so only one reading is usually plausible);
  e.g. a Connecticut blockgroup `"90010201001"` is restored to
  `"090010201001"`. For the rare case where both readings are plausible
  (e.g. state-40 tract vs state-04 blockgroup) it defaults to tract, and an
  authoritative tract list can be passed via the new `tract_fips` argument
  (`.ejam_tract_fips()` supplies `EJAM::blockgroupstats`'s tract list when
  EJAM is installed). Values whose first digits are not a valid state under
  either reading become NA.
* Numeric `fips` codes that lost their leading zeros are now normalized
  before filtering. `get_acs_new(fips = 1001)` previously validated to
  `"1001"` and matched no rows, because the GEO_ID-derived fips carry their
  zeros (`"01001"`). `validate_fips_arg()` now restores canonical Census
  widths via `fips_lead_zero_acs()`, and coerces numeric input with
  `format(scientific = FALSE)` so large codes don't become e.g. `"1e+05"`.
  Codes with impossible digit widths are rejected with a clear message; the
  same-width (single geography type) check runs after normalization.
* Puerto Rico Community Survey tables (the `PR`-suffixed variants, e.g.
  `B05001PR`, `B06004APR`) are accepted again. The input validator added in
  3.0.0 rejected them before download even though the files exist and the
  shipped table shells include those IDs; the table-code pattern now allows
  an optional `PR` suffix, as do the estimate/MOE/annotation column patterns
  used for `variables` / `keep_moe` / `keep_annotations` filtering.
* `get_acs_new_geos()` returned zero rows when filtering by a geography
  type name (e.g. `fips = "county"`). The Geos sidecar file stores
  `SUMLEVEL` as an integer (`50`), but `sumlevel_from_fipstype()` returns
  a zero-padded string (`"050"`), so the filter never matched. The
  comparison is now numeric. (Bug present since the function was added;
  caught by the new live integration test.)

## Internal / housekeeping

* Source code split by concern into `R/get_acs_new.R`, `R/geos.R`,
  `R/fips.R`, `R/sumlevel.R`, `R/labels.R`, `R/defaults.R`,
  `R/utils-download.R`, `R/utils-validate.R`.
* `R/url_acs_table.R` no longer carries duplicate `fipstype_simplified()`
  / `fips_lead_zero_simplified()` helpers; uses the canonical ones from
  `R/fips.R`.
* New `tests/testthat/` suite: 92 expectations covering helpers,
  validators, defaults, label lookup, column filter, and the download
  layer. `R CMD check`: 0 errors, 0 warnings, 0 notes.
* `.github/workflows/R-CMD-check.yaml` -- standard r-lib/actions matrix
  for macOS, Windows, and Ubuntu (release + oldrel-1).
* The 5.6 MB `inst/ACS20225YR_Table_Shells.txt` source file moved to
  `data-raw/`, so installs no longer carry it.

# ACSdownload 2.4.0

The final pre-refactor release in the 2.x series. See
[the GitHub release notes](https://github.com/ejanalysis/ACSdownload/releases/tag/v2.4.0)
for the changes since 2.3.0, and the `v2.4.0-pre-refactor` tag to access
this exact tree.
