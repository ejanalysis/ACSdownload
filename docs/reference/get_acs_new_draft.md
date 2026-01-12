# New draft function to get ACS summaryfile specified tables for entire USA, all blockgroups or all tracts

Uses Census Bureau new format files that offer the full USA in 1 file
per table

## Usage

``` r
get_acs_new_draft(
  tables = "B01001",
  end.year = 2020,
  dataset = "5",
  sumlevel = 150,
  output.path = file.path("~", "acsoutput")
)
```

## Arguments

- tables:

  'ejscreen' or else one or more table codes like 'b01001' or
  c("B01001", "B03002")

- end.year:

  2020 or another available year

- dataset:

  default is 5, for 5-year summary file data like 2016-2020 ACS

- sumlevel:

  default is 150 for blockgroups. 140 is tracts.

- output.path:

  folder / path where to save the downloaded files

## Value

list of data.frames, one per table requested

## Details

Also see [`get_acs_new()`](reference/get_acs_new.md) - A new version of
this using data.table pkg to read directly from url

Does get Puerto Rico (PR) ?

Note API provides better list of variable names, in order as found on
summary files, than documentation does.

For information on this new Summary File format visit:

https://www.census.gov/programs-surveys/acs/data/summary-file.html
