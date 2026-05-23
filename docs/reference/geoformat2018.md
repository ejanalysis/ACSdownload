# geographic information for ACS dataset

This data set has the format used by geographic identifier files in the
American Community Survey (ACS) 5-year summary file. The data and
documentation for the 5 years ending in year X is typically available by
December of the year X+1, so 2014-2018 would be available by Dec 2019.

## Format

A data.frame
`'data.frame': In 2016 and 2017, for example, it had 53 obs. of 5 variables: $ varname : chr "FILEID" "STUSAB" "SUMLEVEL" "COMPONENT" ... $ description: chr "Always equal to ACS Summary File identification" "State Postal Abbreviation" "Summary Level" "Geographic Component" ... $ size : int 6 2 3 2 7 1 1 1 2 2 ... $ start : int 1 7 9 12 14 21 22 23 24 26 ... $ type : chr "Record" "Record" "Record" "Record" ...`

## Source

Table found in given year dataset, info at
<https://www.census.gov/programs-surveys/acs/technical-documentation.html>

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)
