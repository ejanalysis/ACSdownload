# Download (if necessary) and merge GEO files for ACS

Returns a data.frame of all states merged geo info and saves geo.RData
to working directory.

## Usage

``` r
get.read.geo(
  mystates,
  new.geo = FALSE,
  folder = getwd(),
  end.year = acsdefaultendyearhere,
  testing = FALSE,
  silent = FALSE
)
```

## Arguments

- mystates:

  Character vector of 2-character state abbreviations, required.

- new.geo:

  Logical value, optional, FALSE by default. If FALSE, if geo exists in
  memory don't download and parse again.

- folder:

  Defaults to current working directory.

- end.year:

  optional character year to specify last year of 5-year summary file.

- testing:

  Default to FALSE. If TRUE, provides info on progress of download.

- silent:

  Default is FALSE.

## Value

Returns a data.frame of all states geo info.

ACS 2008-2012, tract and block group counts:

table(geo\$SUMLEVEL)

    140    150

74001 220333

## Details

Uses download.geo() then read.geo(), and then does some cleanup.

Note that if this finds the geographic file in folder already, it will
not download it again even if that file was corrupt. Read and compile
geo data for entire USA with PR DC,

This takes some time for the entire USA:

2 to 10 minutes, depending.

Remaining fields in geo:

"STUSAB" "SUMLEVEL" "GEOID" "FIPS" "KEY"

NOTE: do not really need GEOID or KEY.

GEOID is redundant, but might be useful for joining to shapefiles/
boundaries

Also, could specify here if "NAME" field from geo files should be
dropped - it might be useful but takes lots of RAM and encoding of S
panish characters in Puerto Rico caused a problem in Mac OSX.

NOTE FROM CENSUS:

The ACS Summary File GEOID contains the necessary information to connect
to the TIGER/Line Shapefiles, but it needs to be modified in order to
exactly match up. Notice that the ACS GEOID, 05000US10001, contains the
TIGER/Line GEOID string, 10001. In order to create an exact match of
both GEOIDs, it is necessary to remove all of the characters before and
including the letter S in the ACS Summary File. By removing these
characters, the new GEOID in the ACS Summary File exactly matches the
field GEOID in the TIGER/Line Shapefiles.

## See also

[`get_acs_old()`](reference/get_acs_old.md) which uses this, and
[`download.geo()`](reference/download.geo.md)
