# Get URL (without filename) for ACS 5-year summary file data

Returns first part of URL(s) of folders (on Census Bureau FTP site) with
zip file(s) based on end year.

## Usage

``` r
get.url.prefix.lookup.table(end.year)
```

## Arguments

- end.year:

  Optional end year for 5-year summary file, as character, like '2022'

## Value

Returns character element that is first part of URL such as
"https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/documentation/"

## See also

[`get_acs_old()`](reference/get_acs_old.md),
[`get.lookup.acs()`](reference/get.lookup.acs.md),
[`get.lookup.file.name()`](reference/get.lookup.file.name.md)
