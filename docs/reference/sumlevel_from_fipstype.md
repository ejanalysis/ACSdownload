# Get the SUMLEVEL code like "040" or "150" from the fipstype string like "state" or "blockgroup"

Get the SUMLEVEL code like "040" or "150" from the fipstype string like
"state" or "blockgroup"

## Usage

``` r
sumlevel_from_fipstype(ftype)
```

## Arguments

- ftype:

  ignores case, vector of fipstype strings like "state", "county",
  "city", "tract", "blockgroup",

## Value

vector of summary levels

## See also

[`fipstype_from_sumlevel()`](reference/fipstype_from_sumlevel.md)
