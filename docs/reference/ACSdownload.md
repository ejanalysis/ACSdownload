# Download American Community Survey (ACS) 5-year Data Tables from Census Bureau nationwide in bulk

Download and parse raw data from the Census Bureau American Community
Survey (ACS) 5-year survey, to get demographic data in bulk (without
relying on the API). You can obtain data from the entire USA all at once
(or selected FIPS), for one or more tables. This package is focused on
blockgroup and tract levels of resolution.

## Details

ACSdownload is an R package that helps you download and parse large
amounts of raw data from the Census Bureau American Community Survey
5-year datasets, providing demographic data at the blockgroup and tract
levels of resolution. You can obtain data from the entire USA all at
once using this package, for one or more tables.

- The key function is
  [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
  for ACS 2018-2022, 2019-2023, or 2020-2024.

- For older ACS data, which was not organized by table, see
  [`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md).
  For 5-year data ending with year 2022, the DATA FORMAT HAS CHANGED FOR
  SUMMARY FILE ACS DATA. See
  <https://www.census.gov/programs-surveys/acs/data/summary-file/updates-to-acs-summary-file.Overview.html>

Other options for obtaining Census ACS data or related data:

- [http://www.census.gov/programs-surveys/acs/data.html](http://www.census.gov/programs-surveys/acs/data.md)

- The Census Bureau makes it easy to obtain data from one state at a
  time, but it is not as easy to get data for every blockgroup in the
  US. There are over 240,000 block groups and over 85,000 tracts in the
  U.S.

- The [tidycensus
  package](https://walker-data.com/tidycensus/index.html) is an
  alternative that makes it easy to download modest amounts of ACS or
  decennial census or other data, (once you get a Census Bureau API key
  to request the data), but downloading via API is slow/awkward if you
  want all blockgroups nationwide for multiple tables.

- see Census geodatabases at
  [http://www.census.gov/geo/maps-data/data/tiger-data.html](http://www.census.gov/geo/maps-data/data/tiger-data.md)

- see
  [http://www.census.gov/geo/maps-data/data/gazetteer.html](http://www.census.gov/geo/maps-data/data/gazetteer.md)

## References

<https://ejanalysis.org>  

## See also

Useful links:

- <https://ejanalysis.github.io/ACSdownload/>

- <https://github.com/ejanalysis/ACSdownload>

- <https://ejanalysis.org>

## Author

info@ejanalysis.com
