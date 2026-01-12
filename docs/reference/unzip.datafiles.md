# Unzip ACS datafile per state, downloading missing ones first

Unzip ACS datafile for each specified US State, extracting specified
table(s), downloading missing zip files first.

## Usage

``` r
unzip.datafiles(
  tables,
  mystates,
  folder = getwd(),
  end.year = acsdefaultendyearhere,
  testing = FALSE,
  attempts = 5,
  silent = FALSE
)
```

## Arguments

- tables:

  Character vector of table numbers needed such as 'B01001'

- mystates:

  Character vector of 2-character state abbreviations. Default is all
  states.

- folder:

  Default is current working directory.

- end.year:

  optional – specifies last year of 5-year summary file.

- testing:

  Default is FALSE. If TRUE, prints more info.

- attempts:

  Default is 5, specifies how many tries (maximum) for unzipping before
  trying to redownload and then give up.

- silent:

  Default is FALSE. Whether to send progress info to standard output.

## Value

Side effect is unzipping file on disk (unless testing=TRUE)

## See also

[`get_acs_old()`](reference/get_acs_old.md)
