# Convert SUMLEVEL codes like "040" or "150" to fipstype strings like "state" or "blockgroup"

Convert SUMLEVEL codes like "040" or "150" to fipstype strings like
"state" or "blockgroup"

## Usage

``` r
fipstype_from_sumlevel(sumlevel)
```

## Arguments

- sumlevel:

  vector of codes like "040" or "150" for state or blockgroup

## Value

vector of character strings like "state" or "county" corresponding to
the sumlevel codes

## See also

[`sumlevel_from_fipstype()`](https://ejanalysis.github.io/ACSdownload/reference/sumlevel_from_fipstype.md)
