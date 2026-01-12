# newer way to get the geography names AND also get the ACS 5year data for selected tables and fips or fipstype

newer way to get the geography names AND also get the ACS 5year data for
selected tables and fips or fipstype

## Usage

``` r
get_acs_new_geos(yr = acsdefaultendyearhere, fips = "blockgroup")
```

## Arguments

- yr:

  end year of 5 year ACS summary file data, such as 2023 for the
  2019-2023 survey released by Census Bureau Dec. 2024.

- fips:

  "blockgroups" for all US bg, or a vector of fips codes. can also be
  "county", "state", "tract", or vector of one of those fips code types

## Value

table with geographies - names and fips and SUMLEVEL
