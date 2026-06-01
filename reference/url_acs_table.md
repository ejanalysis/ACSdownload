# Build data.census.gov URLs for one or more ACS 5-year tables

Produces URLs to either general information about a table or a
table-for-fips view.

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

  one or more table codes like "B01001" or c("B01001", "C17002")

- fips:

  optional vector of fips codes such as "34023001419"; NULL or empty
  string means "just the general info URL for each table"

- yr:

  end year of the 5-year ACS summary file

- fiveorone:

  1 or 5

## Value

character vector of URLs, one per (table x fips) pair

## See also

`EJAM::url_acs_table_info()` for a richer EJSCREEN-aware variant

## Examples

``` r
  url_acs_table()
#>  [1] "https://data.census.gov/table/ACSDT5Y2024.B25034"
#>  [2] "https://data.census.gov/table/ACSDT5Y2024.B01001"
#>  [3] "https://data.census.gov/table/ACSDT5Y2024.B03002"
#>  [4] "https://data.census.gov/table/ACSDT5Y2024.B02001"
#>  [5] "https://data.census.gov/table/ACSDT5Y2024.B15002"
#>  [6] "https://data.census.gov/table/ACSDT5Y2024.B23025"
#>  [7] "https://data.census.gov/table/ACSDT5Y2024.C17002"
#>  [8] "https://data.census.gov/table/ACSDT5Y2024.B17017"
#>  [9] "https://data.census.gov/table/ACSDT5Y2024.B19301"
#> [10] "https://data.census.gov/table/ACSDT5Y2024.B25032"
#> [11] "https://data.census.gov/table/ACSDT5Y2024.B28002"
#> [12] "https://data.census.gov/table/ACSDT5Y2024.B27010"
#> [13] "https://data.census.gov/table/ACSDT5Y2024.C16002"
#> [14] "https://data.census.gov/table/ACSDT5Y2024.B16004"
#> [15] "https://data.census.gov/table/ACSDT5Y2024.C16001"
#> [16] "https://data.census.gov/table/ACSDT5Y2024.B18101"
  # browseURL(url_acs_table(tables = "C17002", yr = 2024))
```
