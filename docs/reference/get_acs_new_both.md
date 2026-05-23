# Get geography names and ACS 5-year data for selected tables and fips or fipstype

Get geography names and ACS 5-year data for selected tables and fips or
fipstype

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

  vector of ACS data table numbers like "B01001" etc. and if NULL, uses
  defaults of
  [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)

- fips:

  "blockgroup" for all US bg, or a vector of fips codes. can also be
  "county", "state", "tract", or vector of one of those fips code types.
  If a fips type, defines the SUMLEVEL variable in the ACS data, such as
  140 for tracts.

- yr:

  end year of 5 year ACS summary file data, such as 2023 for the
  2019-2023 survey released by Census Bureau Dec. 2024.

- fiveorone:

  optional 1 or 5, where 5 is the 5-year sample - only 5-yr tested here

## Value

list of geos + dat, with estimates and margins of error and fips and
SUMLEVEL
