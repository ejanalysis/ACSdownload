# ACSdownload

[![R-CMD-check](https://github.com/ejanalysis/ACSdownload/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ejanalysis/ACSdownload/actions/workflows/R-CMD-check.yaml)

Bulk-download tables from the U.S. Census Bureau's American Community
Survey (ACS) 5-year summary file -- entire-USA-at-once, no API key, one
file per table.

`ACSdownload` reads the Census Bureau's
[table-based summary file](https://www.census.gov/programs-surveys/acs/data/summary-file.html)
(introduced for the 2018-2022 vintage). The 3.x series only supports this
format; for the older sequence-file format, use the 2.x series or
`tidycensus`.

## Why this package

The Census Bureau makes it easy to download one State at a time. The
`tidycensus` package makes it easy to pull modest slices via the Census
API. But if you want every block group in the US for a dozen tables --
something EJSCREEN and similar tools need -- both options are slow and
awkward. There are over 240,000 block groups and 85,000 tracts.

`ACSdownload` does it as ~one HTTP fetch per table to the Census Bureau's
public bulk files, with retry / timeout / optional on-disk caching baked
in. A 16-table block-group pull is typically a few minutes wall-clock on
a residential connection, and the second run is instant when caching is
enabled.

## Installation

```r
# install.packages("devtools")
devtools::install_github("ejanalysis/ACSdownload")
```

## Quick start

The function you want is `get_acs_new()`:

```r
library(ACSdownload)

# Just one table, for one geography type
b25034 <- get_acs_new(
  yr     = 2024,
  tables = "B25034",
  fips   = "county"
)
b25034[["B25034"]][1:3, 1:5]

# Full EJSCREEN block-group pull, merged into one wide table
bg <- get_acs_new(
  yr     = 2024,
  fips   = "blockgroup",
  tables = setdiff(ejscreen_acs_tables, c("C16001", "B18101")),
  return_list_not_merged = FALSE,
  cache_dir = tools::R_user_dir("ACSdownload", "cache")
)
```

`C16001` and `B18101` are tract-only tables; passing them with
`fips = "blockgroup"` filters them to zero rows. With
`return_list_not_merged = FALSE` they get dropped from the merge with a
warning, which is usually what you want.

## What you get back

Each downloaded table arrives as a `data.table` with:

* `GEO_ID`, `fips`, `SUMLEVEL` -- bookkeeping
* `<TABLE>_<NNN>`  -- estimate columns (the leading `_E` is stripped)
* `<TABLE>_M<NNN>` -- margin-of-error columns

Want a human-readable label for `B01001_001`? Use `acs_label()`:

```r
acs_label(c("B01001_001", "B01001_M001", "C16001_002"))
#>   variable_id table_id              label                                                table_title                    universe
#> 1: B01001_001   B01001             Total:                                                 Sex by Age            Total population
#> 2: B01001_M001  B01001             Total:                                                 Sex by Age            Total population
#> 3: C16001_002   C16001 Speak only English Language Spoken at Home for the Population 5 Years and Over Population 5 years and over
```

`acs_label()` is backed by `acs_table_shells`, a 28k-row lookup
bundled with the package, parsed from the official Census table
shells file.

## Caching, retry, timeout, parallelism

`get_acs_new()` accepts:

| arg                | default                                        | what it does                                                          |
| ------------------ | ---------------------------------------------- | --------------------------------------------------------------------- |
| `cache_dir`        | `getOption("ACSdownload.cache_dir", NULL)`     | persist .dat files; second call returns instantly                     |
| `timeout_sec`      | `getOption("ACSdownload.timeout", 300)`        | per-request timeout in seconds                                        |
| `max_retries`      | `getOption("ACSdownload.retries", 3)`          | retry-with-backoff on HTTP 429 / 5xx                                  |
| `parallel`         | `FALSE`                                        | concurrent downloads via `future.apply` (caller sets `future::plan()`)|
| `variables`        | `NULL`                                         | keep only these estimate columns                                      |
| `keep_moe`         | `TRUE`                                         | keep `_M<nnn>` margin-of-error columns                                |
| `keep_annotations` | `FALSE`                                        | keep `_EA<nnn>` / `_MA<nnn>` annotation columns                       |

Recommended for repeat work:

```r
options(ACSdownload.cache_dir = tools::R_user_dir("ACSdownload", "cache"))

future::plan(future::multisession, workers = 4)
bg <- get_acs_new(parallel = TRUE, ...)
```

## Related

* [tidycensus](https://walker-data.com/tidycensus/index.html) -- API-driven, easier for small slices, requires a key.
* [EJAM](https://github.com/ejanalysis/EJAM) -- the EPA EJSCREEN / EJAM
  toolchain that consumes the data this package produces. EJAM's
  `tables_ejscreen_acs` is the authoritative list of EJSCREEN tables and
  is mirrored here as `ejscreen_acs_tables`.

## Documentation

[Function reference](https://ejanalysis.github.io/ACSdownload/reference/index.html)
