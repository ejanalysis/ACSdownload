# Read NHGIS.org ACS Codebook File

Helper function used by [`nhgis()`](reference/nhgis.md) to read
downloaded and unzipped codebook files obtained from NHGIS.org, for US
Census Bureau data from the American Community Survey (ACS).

## Usage

``` r
nhgisreadcodebook(codebookfile, folder = getwd())
```

## Arguments

- codebookfile:

  Name(s) of codebook file(s).

- folder:

  Optional path where files are found. Default is getwd()

## Value

Returns a named list: data, contextfields, fields, tables, geolevel,
years, dataset

## See also

[`nhgis()`](reference/nhgis.md) which uses this,
[`nhgisread()`](reference/nhgisread.md) for reading datafiles,
[`get_acs_old()`](reference/get_acs_old.md),
[`get.datafile.prefix()`](reference/get.datafile.prefix.md),
[`datafile()`](reference/datafile.md),
[`geofile()`](reference/geofile.md),
[`get.zipfile.prefix()`](reference/get.zipfile.prefix.md)
