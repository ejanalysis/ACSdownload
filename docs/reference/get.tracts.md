# Get just the Census tracts part of existing ACS data

Helper function to return just the tract resolution part of a dataset in
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)

## Usage

``` r
get.tracts(merged.tables.mine)
```

## Arguments

- merged.tables.mine:

  Required set of tables in format used by
  [`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)

## Value

subset of the inputs, same format

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
[`get.bg()`](https://ejanalysis.github.io/ACSdownload/reference/get.bg.md)
