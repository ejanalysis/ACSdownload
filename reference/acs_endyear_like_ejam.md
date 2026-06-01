# Estimate the latest ACS 5-year end year Census Bureau has published

Mirrors the `guess_census_has_published = TRUE` branch of
[`EJAM::acs_endyear()`](https://public-environmental-data-partners.github.io/EJAM/reference/acs_endyear.html).
Prefers
[`EJAM::acs_endyear()`](https://public-environmental-data-partners.github.io/EJAM/reference/acs_endyear.html)
when the EJAM package is installed, falling back to a self-contained
estimator that uses the typical Census release lag (~1 year after the
survey period ends) and the known release dates of recent vintages.

## Usage

``` r
acs_endyear_like_ejam(guess_as_of = Sys.Date())
```

## Arguments

- guess_as_of:

  optional `Date` to estimate as-of; defaults to today

## Value

a single character year like `"2024"` for the 2020-2024 ACS 5-year
survey

## Details

Use this when you want today's "best guess" of which vintage's
`summary_file/<yr>/` directory should exist on www2.census.gov.

## See also

[`EJAM::acs_endyear()`](https://public-environmental-data-partners.github.io/EJAM/reference/acs_endyear.html)
