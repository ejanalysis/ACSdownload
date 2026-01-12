# Read NHGIS.org ACS Data Files and Codebooks

Helper function used by [`nhgis()`](reference/nhgis.md) to read
downloaded and unzipped csv and txt files obtained from NHGIS.org, with
US Census Bureau data from the American Community Survey (ACS).

## Usage

``` r
nhgisread(
  datafile,
  codebookfile = gsub("\\.csv", "_codebook.txt", datafile),
  folder = getwd()
)
```

## Arguments

- datafile:

  Names of files

- codebookfile:

  Optional name(s) of codebook files. Default is to infer from datafile

- folder:

  Optional path where files are found. Default is getwd()

## Value

Returns a named list: data, contextfields, fields, tables, geolevel,
years, dataset

## See also

[`nhgis()`](reference/nhgis.md) which uses this,
[`nhgisreadcodebook()`](reference/nhgisreadcodebook.md) for reading
codebook files, [`get_acs_old()`](reference/get_acs_old.md),
[`get.datafile.prefix()`](reference/get.datafile.prefix.md),
[`datafile()`](reference/datafile.md),
[`geofile()`](reference/geofile.md),
[`get.zipfile.prefix()`](reference/get.zipfile.prefix.md)
