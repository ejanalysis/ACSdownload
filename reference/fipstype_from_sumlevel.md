# Convert SUMLEVEL codes (e.g. "040", "150") to fipstype strings (e.g. "state", "blockgroup")

Inverse of
[`sumlevel_from_fipstype()`](https://ejanalysis.github.io/ACSdownload/reference/sumlevel_from_fipstype.md).
Accepts SUMLEVEL as character or numeric. Returns NA for codes the
package does not recognize.

## Usage

``` r
fipstype_from_sumlevel(sumlevel)
```

## Arguments

- sumlevel:

  character or numeric vector of SUMLEVEL codes

## Value

character vector of fipstype strings

## See also

[`sumlevel_from_fipstype()`](https://ejanalysis.github.io/ACSdownload/reference/sumlevel_from_fipstype.md)
