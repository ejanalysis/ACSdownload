# Get the SUMLEVEL code (e.g. "040", "150") from a fipstype string (e.g. "state", "blockgroup")

SUMLEVEL strings extracted from a Census GEO_ID are always 3 characters
(e.g. "020", "040", "150"), so this function returns 3-character strings
to match that width.

## Usage

``` r
sumlevel_from_fipstype(ftype)
```

## Arguments

- ftype:

  character vector of fipstype strings; case-insensitive

## Value

character vector of 3-character SUMLEVEL codes, NA for unsupported

## Details

Supported types (case-insensitive): state, county, city, tract,
blockgroup, REGION, American Indian Area/Alaska Native Area/Hawaiian
Home Land, MSA, CSA, Urban Area, Congressional District, ZCTA. The
"block" type has no Census SUMLEVEL and returns NA.

## See also

[`fipstype_from_sumlevel()`](https://ejanalysis.github.io/ACSdownload/reference/fipstype_from_sumlevel.md)

Census reference:
<https://www.census.gov/programs-surveys/acs/geography-acs/reference-materials.2023.html>
(ACS_2023_5-Year_Geocount file).
