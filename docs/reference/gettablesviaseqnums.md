# Look up ACS table IDs of tables in given sequence number files

Helper function to look for which American Community Survey (ACS) tables
are in given sequence files as obtained from the US Census FTP site.

## Usage

``` r
gettablesviaseqnums(x, end.year = acsdefaultendyearhere)
```

## Arguments

- x:

  Required character vector of table IDs such as "B01001"

- end.year:

  Optional character variable providing the end year of the 5-year ACS
  survey, to ensure the proper sequence file to table ID matching is
  used.

## Value

Returns a character vector of table IDs such as "B01001"

## See also

[`read.concat.states()`](reference/read.concat.states.md) which uses
this, and [`get.lookup.acs()`](reference/get.lookup.acs.md) which is
used by this
