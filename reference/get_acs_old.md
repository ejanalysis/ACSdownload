# Defunct: download ACS data in the pre-2022 sequence-file format

`get_acs_old()` and the entire sequence-file code path were removed in
ACSdownload 3.0.0. Use
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md),
which reads the Census Bureau's table-based summary file format
(available for end year 2022 and later).

## Usage

``` r
get_acs_old(...)
```

## Arguments

- ...:

  ignored

## Value

This function always stops with an error.

## Details

If you specifically need the old sequence-file format for an end year of
2021 or earlier, install the final 2.x release:
`remotes::install_github("ejanalysis/ACSdownload@v2.4.0-pre-refactor")`.
