# Read NHGIS.org ACS Data Files and Codebooks

Helper function used by
[`nhgis()`](https://ejanalysis.github.io/ACSdownload/reference/nhgis.md)
to read downloaded and unzipped csv and txt files obtained from
NHGIS.org, with US Census Bureau data from the American Community Survey
(ACS).

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

[`nhgis()`](https://ejanalysis.github.io/ACSdownload/reference/nhgis.md)
which uses this,
[`nhgisreadcodebook()`](https://ejanalysis.github.io/ACSdownload/reference/nhgisreadcodebook.md)
for reading codebook files,
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
[`get.datafile.prefix()`](https://ejanalysis.github.io/ACSdownload/reference/get.datafile.prefix.md),
[`datafile()`](https://ejanalysis.github.io/ACSdownload/reference/datafile.md),
[`geofile()`](https://ejanalysis.github.io/ACSdownload/reference/geofile.md),
[`get.zipfile.prefix()`](https://ejanalysis.github.io/ACSdownload/reference/get.zipfile.prefix.md)
