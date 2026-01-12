# Get name(s) of GEO txt file(s) with geo information for ACS

Get name of text file used by US Census Bureau with geographic
information for American Community Survey. That geo file can be used to
join data file(s) to FIPS/GEOID/NAME/SUMLEVEL/CKEY.

## Usage

``` r
geofile(mystates, end.year = acsdefaultendyearhere)
```

## Arguments

- mystates:

  vector of character 2-letter State abbreviations specifying which are
  needed

- end.year:

  end.year of 5-year summary file such as '2021'

## Value

Character vector of file names, example: "g20215md.txt" Note this is
only needed once per state, not once per seqfile. (It might even be
available as a single US file?)

## See also

[`get_acs_old()`](reference/get_acs_old.md) and
[`download.geo()`](reference/download.geo.md) which uses this
