# ACSdownload Package 

## The [ACSdownload package](http://ejanalysis.github.io/ACSdownload/) for R has functions helping to download and parse raw data files from the United States Census Bureau dataset called the American Community Survey (ACS) 5-year summary file. In particular, this package allows you to obtain all of the block group and tract-level data for any or all US States/DC/PR, rather than one State or one County at a time, for specified variables in specified tables. In contrast, other tools such as the acs package or the American Fact Finder, tend to provide more limited subsets such as one US County at a time, when working with block group or tract resolution tables, and/or require you obtain a key from Census.

Key functions include get.acs() to download and parse specified data, and various helper functions.

## Installation

This package is not on CRAN yet, but you can install it from Github:

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github('ejanalysis/ACSdownload')
```

## Related Packages

This package is one of a series of [R packages related to environmental justice (EJ) analysis](http://ejanalysis.github.io/), as part of [ejanalysis.com](http://www.ejanalysis.com).  

This and related packages, once each is made available as a public repository on GitHub, until available on cran, can be installed using the devtools package: 

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github("ejanalysis/analyze.stuff")  
devtools::install_github("ejanalysis/countyhealthrankings")  
devtools::install_github("ejanalysis/ACSdownload")  
devtools::install_github(c("ejanalysis/proxistat", "ejanalysis/ejanalysis"))
devtools::install_github("ejanalysis/ejscreen")
```
