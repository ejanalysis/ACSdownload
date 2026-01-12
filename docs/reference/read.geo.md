# Read and concatenate state geo files from Census ACS

Reads and merges geo files that have been obtained from the US Census
Bureau FTP site for American Community Survey (ACS) data. It uses
read.fwf() at least for older years.

## Usage

``` r
read.geo(
  mystates,
  folder = getwd(),
  end.year = acsdefaultendyearhere,
  silent = FALSE
)
```

## Arguments

- mystates:

  Character vector of one or more states/DC/PR, as 2-character state
  abbreviations. Default is all states/DC/PR.

- folder:

  Optional path to where files are stored, defaults to getwd()

- end.year:

  End year of 5-year data, like "2018"

- silent:

  Default is FALSE. Whether to send progress info to standard output.

## Value

Returns a large data.frame of selected geographic information on all
block groups and tracts in the specified states/DC/PR, with just these
fields:  
"STUSAB", "SUMLEVEL", "LOGRECNO", "STATE", "COUNTY", "TRACT", "BLKGRP",
"GEOID"

## Details

Note that if this finds the geographic file in folder already, it will
not download it again even if that file was corrupt. Extracts just block
group (SUMLEVEL=150) and tract (SUMLEVEL=140) geo information (not
county info., since data files used in this package lack county info.)
The NAME field works on pc but mac can hit an error if trying to read
the NAME field. Due to encoding? specifying encoding didn't help.  
(name is very long and not essential)  
Error in substring(x, first, last) :  
invalid multibyte string at 'onc\<69\>to Chapter; Navajo Nation
Reservation and Off-Reservation Trust Land, AZ–NM–UT  
Format of files is here:
<ftp://ftp.census.gov/acs2012_5yr/summaryfile/ACS_2008-2012_SF_Tech_Doc.pdf>

## See also

[`get_acs_old()`](reference/get_acs_old.md),
[`download.geo()`](reference/download.geo.md)

## Examples

``` r
 if (FALSE) { # \dontrun{
  geo <- read.geo( c("dc", "de") )
 } # }
```
