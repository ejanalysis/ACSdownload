# Download American Community Survey (ACS) 5-year Data Tables from Census Bureau nationwide in bulk

Download and parse raw data from the Census Bureau American Community
Survey (ACS) 5-year survey to get demographic data in bulk (without
relying on the API). You can obtain data from the entire USA all at once
(or selected FIPS), for one or more tables. This package is focused on
blockgroup and tract levels of resolution.

## Details

ACSdownload helps you download and parse large amounts of raw data from
the Census Bureau American Community Survey 5-year datasets, providing
demographic data at the blockgroup and tract levels of resolution. You
can obtain data from the entire USA all at once using this package, for
one or more tables.

- The key function is
  [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
  for ACS end years 2022 and later (the table-based summary file
  format).

- For ACS end years 2021 and earlier (the older sequence-file format),
  this package no longer ships support; use a CRAN package such as
  `tidycensus` or the prior 2.x series of `ACSdownload`.

Other options for obtaining Census ACS data or related data:

- <https://www.census.gov/programs-surveys/acs/data.html>

- The Census Bureau makes it easy to obtain data from one state at a
  time, but it is not as easy to get data for every blockgroup in the
  US. There are over 240,000 block groups and over 85,000 tracts in the
  U.S.

- The [tidycensus
  package](https://walker-data.com/tidycensus/index.html) is an
  alternative that makes it easy to download modest amounts of ACS or
  decennial-census or other data (once you get a Census Bureau API key
  to request the data), but downloading via API is slow/awkward if you
  want all blockgroups nationwide for multiple tables.

- see Census geodatabases at
  <https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-geodatabase-file.html>

- see
  <https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html>

## References

<https://ejanalysis.com/>

## See also

Useful links:

- <https://ejanalysis.github.io/ACSdownload/>

- <https://github.com/ejanalysis/ACSdownload>

- <https://ejanalysis.com/>

- Report bugs at <https://github.com/ejanalysis/ACSdownload/issues>

## Author

ejam@ejanalysis.com
