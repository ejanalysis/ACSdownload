# Package index

## Download ACS data

Bulk-fetch ACS table-based summary file data.

- [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
  : Get full USA ACS data by table and fips (table-based summary file
  format)

## Inspect and label variables

Make sense of the Census variable codes.

- [`acs_label()`](https://ejanalysis.github.io/ACSdownload/reference/acs_label.md)
  : Look up the human-readable label for one or more ACS variable codes
- [`acs_table_shells`](https://ejanalysis.github.io/ACSdownload/reference/acs_table_shells.md)
  : Lookup from ACS variable code to its human-readable label
- [`url_acs_table()`](https://ejanalysis.github.io/ACSdownload/reference/url_acs_table.md)
  : Build data.census.gov URLs for one or more ACS 5-year tables

## Geography helpers

Convert between SUMLEVEL codes and human-readable type names.

- [`sumlevel_from_fipstype()`](https://ejanalysis.github.io/ACSdownload/reference/sumlevel_from_fipstype.md)
  : Get the SUMLEVEL code (e.g. "040", "150") from a fipstype string
  (e.g. "state", "blockgroup")
- [`fipstype_from_sumlevel()`](https://ejanalysis.github.io/ACSdownload/reference/fipstype_from_sumlevel.md)
  : Convert SUMLEVEL codes (e.g. "040", "150") to fipstype strings (e.g.
  "state", "blockgroup")

## Vintage / release-date helpers

Decide which ACS vintage to target.

- [`acs_endyear_like_ejam()`](https://ejanalysis.github.io/ACSdownload/reference/acs_endyear_like_ejam.md)
  : Estimate the latest ACS 5-year end year Census Bureau has published

- [`acsdefaultendyearhere`](https://ejanalysis.github.io/ACSdownload/reference/acsdefaultendyearhere.md)
  : Default end year of 5-year ACS datasets this package targets

- [`acsfirstyearavailablehere`](https://ejanalysis.github.io/ACSdownload/reference/acsfirstyearavailablehere.md)
  :

  Earliest end year of 5-year ACS datasets
  [`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
  can target

## EJSCREEN integration

Table lists used by EJSCREEN/EJAM.

- [`ejscreen_acs_tables`](https://ejanalysis.github.io/ACSdownload/reference/ejscreen_acs_tables.md)
  : ACS tables used by EJSCREEN ACS-based indicators
