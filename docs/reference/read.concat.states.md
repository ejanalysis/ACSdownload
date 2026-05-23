# Read and concatenate State files of ACS data

Read the unzipped csv files of estimates and MOE (margin of error) for
American Community Survey (ACS) 5-year summary file data obtained from
US Census FTP site. These State-specific csv files are combined into a
single national result for each Census data table.

## Usage

``` r
read.concat.states(
  tables,
  mystates,
  geo,
  needed,
  folder = getwd(),
  output.path,
  end.year = acsdefaultendyearhere,
  save.files = TRUE,
  sumlevel = "both",
  testing = FALSE,
  dt = TRUE,
  silent = FALSE
)
```

## Arguments

- tables:

  Optional character vector of table numbers needed such as 'B01001',
  but default is all tables from each sequence file found.

- mystates:

  Optional character vector of 2-character state abbreviations. Default
  is all states for which matching filenames are found in folder.

- geo:

  Optional table of geographic identifiers that elsewhere would be
  merged with data here. If provided, it is used here to look up data
  file length, based on state abbrev's list. See
  [`get.read.geo()`](https://ejanalysis.github.io/ACSdownload/reference/get.read.geo.md)
  If geo is not provided, the function still reads each file whatever
  its length.

- needed:

  Optional data.frame specifying which variables to keep from each
  table. Default is to keep all. See
  [`set.needed()`](https://ejanalysis.github.io/ACSdownload/reference/set.needed.md)
  and
  [`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)

- folder:

  Default is current working directory. Specifies where the csv files
  are to be found.

- output.path:

  Default is whatever the parameter `folder` is set to. Results as
  .RData files are saved here if save.files=TRUE.

- end.year:

  Optional, specifies end year of 5-year summary file.

- save.files:

  Default is TRUE, in which case it saves each resulting table/ data
  file on disk.

- sumlevel:

  Default is "both". Specifies if "tracts" or "blockgroups" or "both"
  should be returned.

- testing:

  Default is FALSE. If TRUE, prints filenames but does not unzip them,
  and prints more messages.

- dt:

  Optional logical, TRUE by default, specifies whether data.table::fread
  should be used instead of read.csv

- silent:

  Default is FALSE. Whether to send progress info to standard output.

## Value

Returns a list of data.frames, where each element of the list is one ACS
table, such as table B01001.

## Details

This can use read.csv (takes about 1 minute total for one table, all
states, est and moe). It can use data.table::fread (default method),
which is faster.

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)
