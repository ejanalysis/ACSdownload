# get URL(s) of ACS 5-year table(s) for general info or for FIPS code(s) (blockgroup or tract) at census.gov See [`EJAM::url_acs_table_info()`](https://public-environmental-data-partners.github.io/EJAM/reference/url_acs_table_info.html) for a more likely to be updated version

get URL(s) of ACS 5-year table(s) for general info or for FIPS code(s)
(blockgroup or tract) at census.gov See
[`EJAM::url_acs_table_info()`](https://public-environmental-data-partners.github.io/EJAM/reference/url_acs_table_info.html)
for a more likely to be updated version

## Usage

``` r
url_acs_table(
  tables = ejscreen_acs_tables,
  fips = NULL,
  yr = acsdefaultendyearhere,
  fiveorone = 5
)
```

## Arguments

- tables:

  "C16002" or c("B01001","C17002") for example

- fips:

  "34023001419" for example (or NULL or "" for general info)

- yr:

  2023 for example

- fiveorone:

  can be 1 or 5

## Value

one or more urls, as character vector

## Examples

``` r
url_acs_table()
  # browseURL(url_acs_table(tables = "C17002", yr = 2022))
  # Census 2020 tables are at e.g., "https://data.census.gov/table/DECENNIALPL2020.P1"
```
