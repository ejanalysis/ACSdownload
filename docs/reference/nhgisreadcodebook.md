# Read NHGIS.org ACS Codebook File

Helper function used by
[`nhgis()`](https://ejanalysis.github.io/ACSdownload/reference/nhgis.md)
to read downloaded and unzipped codebook files obtained from NHGIS.org,
for US Census Bureau data from the American Community Survey (ACS).

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

[`nhgis()`](https://ejanalysis.github.io/ACSdownload/reference/nhgis.md)
which uses this,
[`nhgisread()`](https://ejanalysis.github.io/ACSdownload/reference/nhgisread.md)
for reading datafiles,
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
[`get.datafile.prefix()`](https://ejanalysis.github.io/ACSdownload/reference/get.datafile.prefix.md),
[`datafile()`](https://ejanalysis.github.io/ACSdownload/reference/datafile.md),
[`geofile()`](https://ejanalysis.github.io/ACSdownload/reference/geofile.md),
[`get.zipfile.prefix()`](https://ejanalysis.github.io/ACSdownload/reference/get.zipfile.prefix.md)
