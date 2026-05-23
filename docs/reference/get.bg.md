# Get just the Census block group part of existing ACS data

Helper function to return just the block group resolution part of a
dataset in
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)

## Usage

``` r
get.bg(merged.tables.mine)
```

## Arguments

- merged.tables.mine:

  Required set of tables in format used by
  [`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)

## Value

subset of the inputs, same format

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
[`get.tracts()`](https://ejanalysis.github.io/ACSdownload/reference/get.tracts.md)
