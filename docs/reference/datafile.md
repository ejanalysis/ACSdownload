# Get name(s) of data file(s) for ACS 5-year summary file data

Returns name(s) of data file(s) based on state(s), a sequence file
number, and end year.

## Usage

``` r
datafile(state.abbrev, seqfilenum, end.year = acsdefaultendyearhere)
```

## Arguments

- state.abbrev:

  Required vector of one or more 2-character state abbreviations like
  "DC"

- seqfilenum:

  Required sequence file number(s) used by ACS 5-year summary file (can
  be a single value like "0022" or a vector)

- end.year:

  Optional end year for 5-year summary file, as character or number

## Value

Returns character element that is name of data file such as
e20105de0017000 or m20105de0017000

## See also

[`get_acs_old()`](reference/get_acs_old.md)
