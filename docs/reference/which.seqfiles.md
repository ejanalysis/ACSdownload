# Find Which Sequence Files Contain Given ACS Table(s)

The US Census Bureau provides 5-year summary file data from the American
Community Survey in sequence files on their FTP site. This function
reports which sequence files contain the specified tables. Used by
[`get_acs_old()`](reference/get_acs_old.md)

## Usage

``` r
which.seqfiles(tables, lookup.acs, end.year = acsdefaultendyearhere)
```

## Arguments

- tables:

  character vector, required. Defines which ACS table(s) to check, such
  as 'B01001'

- lookup.acs:

  data.frame, optional (if not provided then it is downloaded from
  Census). Specifies what variables are in which tables and which tables
  are in which sequence files on the FTP site.

- end.year:

  Character element, optional. Defines end year for 5-year dataset.
  Valid years are limited. Ignored if lookup.acs is specified, however.
  If they imply different years, the function stops with an error
  message.

## Value

Returns a vector of one or more numbers stored as characters, each
defining one sequence file, such as "0001".

## See also

[`get_acs_old()`](reference/get_acs_old.md) and from the acs package,
which does something related but is more flexible & robust. Also see
[`get_acs_old()`](reference/get_acs_old.md) which uses this.
