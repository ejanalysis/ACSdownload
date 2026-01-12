# Pick a year-specific table from among lookup.acs20xx objects

Pick a year-specific lookup table of information on American Community
Survey (ACS) tables, from the Census Bureau, namely which sequence files
on the FTP site contain which tables and which variables.

## Usage

``` r
get.lookup.acs(end.year = acsdefaultendyearhere)
```

## Arguments

- end.year:

  Character, optional, like "2021", which specifies the 2016-2021
  dataset. Defines which 5-year summary file to use, based on end-year.
  Note: Function stops with error if given end.year is not yet added to
  this package or is too old.

## Value

returns a data.frame

## See also

- [`get.table.info()`](reference/get.table.info.md) and
  [`get.field.info()`](reference/get.field.info.md).

- Also see
  [`tidycensus::load_variables()`](https://walker-data.com/tidycensus/reference/load_variables.html)
  from the [tidycensus package](https://walker-data.com/tidycensus/) for
  an alternative way to get ACS data and variable info.

- Also see [`download.lookup.acs()`](reference/download.lookup.acs.md)
  to download the file from the Census FTP site.

- Also see [lookup.acs](reference/lookup.acs.md)
  [lookup.acs2021](reference/lookup.acs2021.md) and similar data for
  other years.

- Also see [`get_acs_new()`](reference/get_acs_new.md),
  [`get.lookup.file.name()`](reference/get.lookup.file.name.md),
  [`get.url.prefix.lookup.table()`](reference/get.url.prefix.lookup.table.md)

## Examples

``` r
 names(lookup.acs2021)
 names(lookup.acs)
```
