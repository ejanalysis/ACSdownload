# Get name of Census file with Sequence and Table Numbers for ACS 5-year summary file data

Returns name of text file provided by US Census Bureau, such as
Sequence_Number_and_Table_Number_Lookup.txt, which provides the sequence
numbers (file numbers) and table numbers for data in the American
Community Survey (ACS) 5-year summary file.

## Usage

``` r
get.lookup.file.name(end.year = acsdefaultendyearhere)
```

## Arguments

- end.year:

  Not yet implemented, but will be optional end year for 5-year summary
  file, as character

## Value

Returns character element that is name of file such as
"Sequence_Number_and_Table_Number_Lookup.txt"

## See also

[`get_acs_old()`](reference/get_acs_old.md),
[`get.lookup.acs()`](reference/get.lookup.acs.md),
[`get.url.prefix.lookup.table()`](reference/get.url.prefix.lookup.table.md).
Also see `data(lookup.acs)`.
