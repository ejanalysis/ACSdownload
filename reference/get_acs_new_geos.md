# Read the geography names (and fips/SUMLEVEL) for a Census ACS vintage

Downloads the Geos5YR.txt sidecar from the table-based summary file
release, attaches a `fips` column, and optionally filters by a geography
type name (e.g. "blockgroup") or a vector of specific fips codes.

## Usage

``` r
get_acs_new_geos(yr = acsdefaultendyearhere, fips = "blockgroup")
```

## Arguments

- yr:

  end year of the 5-year ACS summary file (e.g. 2024 for the 2020-2024
  survey released by Census Bureau Jan. 2026)

- fips:

  one of: a single geography type name ("blockgroup", "tract", "county",
  "state", "city", "REGION", "MSA", "CSA", "Urban Area", "Congressional
  District", "ZCTA", or "American Indian Area/Alaska Native
  Area/Hawaiian Home Land"), or a vector of specific fips codes, or NULL
  for no filtering

## Value

a data.table with columns STUSAB, SUMLEVEL, GEO_ID, fips
