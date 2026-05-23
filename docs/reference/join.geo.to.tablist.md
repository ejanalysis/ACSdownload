# Join US ACS data and US geo files on FIPS

Read the processed csv files of estimates and MOE (margin of error) for
American Community Survey (ACS) 5-year summary file data obtained from
US Census FTP site, and join with geographic information from geo file.

## Usage

``` r
join.geo.to.tablist(
  mygeo,
  my.list.of.tables,
  save.csv = FALSE,
  sumlevel = "both",
  folder = getwd(),
  testing = FALSE,
  end.year = acsdefaultendyearhere
)
```

## Arguments

- mygeo:

  Required geo file. See
  [`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)
  and
  [`get.read.geo()`](https://ejanalysis.github.io/ACSdownload/reference/get.read.geo.md)

- my.list.of.tables:

  List of data tables resulting from prior steps in
  [`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)

- save.csv:

  FALSE by default. Specifies whether to save each data table as csv
  format file.

- sumlevel:

  Default is "both", specifies if "tracts" or "blockgroups" or "both"
  should be used.

- folder:

  Default is current working directory.

- testing:

  Default is FALSE. If TRUE, prints more information.

- end.year:

  Default is "" – used in naming file if save.csv=TRUE

## Value

Returns a list of data.frames, where each element of the list is one ACS
table, such as table B01001.

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)
and
[`get.read.geo()`](https://ejanalysis.github.io/ACSdownload/reference/get.read.geo.md)
