# Download American Community Survey 5-yr data files

Attempts to download data files (estimates and margins of error) for
specified states and tables, from the US Census Bureau's FTP site for
American Community Survey (ACS) 5-year summary file data.

## Usage

``` r
download.datafiles(
  tables,
  end.year = acsdefaultendyearhere,
  mystates = 52,
  folder = getwd(),
  testing = FALSE,
  attempts = 5,
  silent = FALSE
)
```

## Arguments

- tables:

  Required character vector of table numbers, such as c("B01001",
  "B03002")

- end.year:

  Character element, optional, like "2012". Defines last of five years
  of summary file dataset.

- mystates:

  Character vector, now optional - Default is 50 states + DC + PR here,
  but otherwise relies on
  [`clean.mystates()`](reference/clean.mystates.md)

- folder:

  Default is getwd()

- testing:

  Default to FALSE. If TRUE, provides info on progress of download.

- attempts:

  Default is 5, specifies how many tries (maximum) for unzipping before
  trying to redownload and then give up.

- silent:

  Optional, default is FALSE. Whether progress info should be sent to
  standard output (like the screen).

## Value

Effect is to download and save locally a number of data files.

## Details

In 2022, the formats of files changed, and now there is one file per ACS
Table. The old format used sequence file information, with each State in
a separate folder.
