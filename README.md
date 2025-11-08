# ACSdownload R Package 

The ACSdownload package for R has functions helping to download and parse raw data files from the United States Census Bureau dataset called the American Community Survey (ACS) 5-year summary file. In particular, this package allows you to obtain all of the block group and tract-level data for any or all US States/DC/PR, rather than one State or one County at a time, for specified variables in specified tables. In contrast, other tools such as the acs package tend to provide more limited subsets such as one US County or State at a time, when working with block group or tract resolution tables, and/or require you obtain a key from Census.

Key functions include `get_acs_old()` to download and parse specified data, and various helper functions.

## Installation

This package is not on CRAN -- install it from Github:

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github('ejanalysis/ACSdownload')
```

## Documentation

See the [package documentation / function reference](https://ejanalysis.github.io/ACSdownload/reference/index.html).


## Github R package repository

[ACSdownload on github.com](https://github.com/ejanalysis/ACSdownload?tab=readme-ov-file#readme)
