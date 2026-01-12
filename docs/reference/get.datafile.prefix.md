# Get first part of ACS datafile name.

Get the first part of the datafile name for the ACS 5-year summary file
datafiles on the US Census Bureau FTP site.

## Usage

``` r
get.datafile.prefix(end.year = acsdefaultendyearhere)
```

## Arguments

- end.year:

  Optional character, such as "2012", specifying last year of 5-year
  summary file data.

## See also

[`get_acs_old()`](reference/get_acs_old.md),
[`datafile()`](reference/datafile.md),
[`geofile()`](reference/geofile.md),
[`get.zipfile.prefix()`](reference/get.zipfile.prefix.md)
