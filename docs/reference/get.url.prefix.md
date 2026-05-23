# Get URL prefix for folder(s) with ACS 5-year summary file data

Returns part of URL of folders (on Census Bureau site) with zip file(s)
based on end year.

## Usage

``` r
get.url.prefix(end.year = acsdefaultendyearhere)
```

## Arguments

- end.year:

  Optional end year for 5-year summary file, as character, but ignored
  if url.prefix is specified

## Value

Returns character vector that is first part of URL such as
"https://www2.census.gov/programs-surveys/acs/summary_file/2021/data/5_year_seq_by_state/2020/Tracts_Block_Groups_Only"
"https://www2.census.gov/programs-surveys/acs/summary_file/2021/sequence-based-SF/data/5_year_seq_by_state/Delaware/Tracts_Block_Groups_Only"
"ftp://ftp.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset"

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
[`url.to.find.zipfile()`](https://ejanalysis.github.io/ACSdownload/reference/url.to.find.zipfile.md),
[`download.geo()`](https://ejanalysis.github.io/ACSdownload/reference/download.geo.md)

## Examples

``` r
browseURL(get.url.prefix(2022))
```
