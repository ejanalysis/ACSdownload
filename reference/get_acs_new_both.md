# Get geography names and ACS 5-year data together

Convenience wrapper: calls
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
for the table data and
[`get_acs_new_geos()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new_geos.md)
for the geography names, and returns both as a list.

## Usage

``` r
get_acs_new_both(
  tables = NULL,
  fips = "blockgroup",
  yr = acsdefaultendyearhere,
  fiveorone = 5
)
```

## Arguments

- tables:

  vector of ACS table codes (e.g. c("B01001", "B03002")), or NULL to use
  [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)'s
  default

- fips:

  see
  [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)

- yr:

  end year of the 5-year ACS summary file

- fiveorone:

  1 or 5; only 5 is tested

## Value

list with elements `geos` (a data.table of geography names) and `dat`
(whatever
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
returned)
