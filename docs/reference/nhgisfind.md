# Find NHGIS ACS Files on Disk

Look in specified path to find any downloaded and unzipped csv and txt
files from NHGIS.ORG, with American Community Survey (ACS) data from the
US Census Bureau.

## Usage

``` r
nhgisfind(folder = getwd(), silent = FALSE)
```

## Arguments

- folder:

  Optional path to look in. Default is getwd().

- silent:

  Optional, default is FALSE. Prints filenames if TRUE.

## Value

A named list with datafiles= a vector of one or more filenames
(estimates and also MOE files) and codebooks= a vector of one or more
filenames. The function also prints the information unless silent=TRUE.

## Details

This is designed to get a list of filenames that match the format of csv
and txt files obtained from NHGIS.org and already unzipped in a local
folder. Obtaining NHGIS.org data requires an account at
<https://data2.nhgis.org/main>, <https://www.nhgis.org> Data can be
downloaded by selecting, for example,  
block groups, all in US, acs2007-2011, and specifying the desired ACS
Table(s). Research using NHGIS data should cite it as:  
Minnesota Population Center. National Historical Geographic Information
System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.

## See also

[`nhgis()`](https://ejanalysis.github.io/ACSdownload/reference/nhgis.md),
[`nhgisread()`](https://ejanalysis.github.io/ACSdownload/reference/nhgisread.md)
