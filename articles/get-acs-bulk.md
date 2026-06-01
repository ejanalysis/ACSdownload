# Bulk-downloading ACS 5-year data

This vignette walks through the typical end-to-end use of
[`ACSdownload::get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md):
which call shape to use, how to keep your laptop healthy when fetching
every block group in the country, and how to turn the resulting cryptic
column codes into readable labels.

## The one call you usually want

``` r

library(ACSdownload)

bg <- get_acs_new(
  yr        = 2024,
  fips      = "blockgroup",
  tables    = setdiff(ejscreen_acs_tables, c("C16001", "B18101")),
  return_list_not_merged = FALSE,
  cache_dir = tools::R_user_dir("ACSdownload", "cache")
)
```

What that does:

- `yr = 2024` – targets the 2020-2024 vintage (released 2026-01-29). Use
  [`acs_endyear_like_ejam()`](https://ejanalysis.github.io/ACSdownload/reference/acs_endyear_like_ejam.md)
  if you want today’s “best guess” of the latest published vintage:

  ``` r

  acs_endyear_like_ejam()
  ```

- `fips = "blockgroup"` – filters every table to SUMLEVEL 150 rows.

- `tables = setdiff(...)` – the full EJSCREEN list except the two
  tract-only tables (`C16001`, `B18101`), since asking for them at
  blockgroup resolution produces zero rows.

- `return_list_not_merged = FALSE` – merges everything on `fips` and
  hands you one wide `data.table` instead of a list of 14.

- `cache_dir = ...` – persists the downloaded `.dat` files. The table-
  based summary file files are immutable once a vintage ships, so the
  second time you run this call it completes in milliseconds.

## Why this is faster than the API

There are about **244,000 block groups** in the U.S. Pulling 16 tables
nationwide via the Census API would mean tens of thousands of paginated
requests, an API key, and rate limits.
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
does **16 large file fetches** – one per table – and lets
[`data.table::fread()`](https://rdrr.io/pkg/data.table/man/fread.html)
parse each one in a few seconds. On a residential connection a full
block- group pull is typically 3-10 minutes wall-clock, and ~zero on the
second run with caching.

## Why those two tables get dropped

`C16001` (detailed languages spoken) and `B18101` (disability) are
published at tract resolution only. EJSCREEN repeats their tract values
onto each blockgroup in the tract; if you need that behavior, fetch them
separately:

``` r

tracts <- get_acs_new(
  yr     = 2024,
  fips   = "tract",
  tables = c("C16001", "B18101")
)
```

and join into your block-group table afterwards on the tract substring
of `fips`.

## Parallel + retry

If the network is misbehaving,
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
retries each table on HTTP 429 / 5xx with exponential backoff (default 3
retries). If 16 sequential downloads is too slow, opt into parallelism:

``` r

future::plan(future::multisession, workers = 4)

bg <- get_acs_new(
  yr        = 2024,
  fips      = "blockgroup",
  tables    = setdiff(ejscreen_acs_tables, c("C16001", "B18101")),
  parallel  = TRUE,
  cache_dir = tools::R_user_dir("ACSdownload", "cache")
)
```

You need both `future` and `future.apply` installed. The caller is
responsible for setting a
[`future::plan()`](https://future.futureverse.org/reference/plan.html);
without one, parallel runs sequentially.

## Decoding the column names

The columns look like `B25034_001`, `B25034_002`, `B25034_M001`, …
That’s: table code, then `_<NNN>` for estimates or `_M<NNN>` for margins
of error. To turn those into something readable:

``` r

acs_label(c("B25034_001", "B25034_002", "B25034_M002"))
```

[`acs_label()`](https://ejanalysis.github.io/ACSdownload/reference/acs_label.md)
accepts either estimate or MOE column names; both map to the same label.
It returns NA for codes that don’t appear in the shipped lookup, which
is built from the Census 2022 5-year table shells.

## Picking just what you need

You don’t always want every column from every table. `variables` narrows
the column selection at fetch time:

``` r

just_pre1960 <- get_acs_new(
  yr        = 2024,
  fips      = "blockgroup",
  tables    = "B25034",
  variables = c("B25034_001", "B25034_010", "B25034_011"),
  keep_moe  = FALSE
)
```

- `variables` is matched in the post-rename form (no `_E` infix).
- `keep_moe = FALSE` drops margin-of-error columns.
- `keep_annotations = TRUE` keeps `_EA<nnn>` / `_MA<nnn>` annotation
  columns (some vintages include them; v3 drops them by default).

## When something goes wrong

The first thing to try if
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
errors:

1.  **`yr` out of range?** `validate_acs_endyear()` rejects years below
    2022 or above today’s year + 1.
2.  **Unknown table code?** `validate_acs_tables()` enforces
    `^[BC][0-9]{5}[A-I]?$`. Common typo: passing the EJSCREEN-style name
    (e.g. `"pop"`) instead of the Census code.
3.  **HTTP 404?** Means the table doesn’t exist for that vintage. Check
    `url_acs_table(tables = "...", yr = ...)` for the table’s
    data.census.gov landing page.
