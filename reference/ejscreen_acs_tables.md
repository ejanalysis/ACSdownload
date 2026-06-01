# ACS tables used by EJSCREEN ACS-based indicators

Character vector of ACS 5-year table codes that EJSCREEN ingests to
compute its demographic indicators. Mirrors
[`EJAM::tables_ejscreen_acs`](https://public-environmental-data-partners.github.io/EJAM/reference/tables_ejscreen_acs.html)
(the authoritative source) on the ACS2024 branch; update this object
only by editing `data-raw/datacreate_ejscreen_acs_tables.R` and
re-running it.

## Usage

``` r
ejscreen_acs_tables
```

## Format

An object of class `character` of length 16.

## Details

Two of the tables (`C16001` and `B18101`) are published at tract
resolution only. `get_acs_new(fips = "blockgroup")` will return zero-row
tables for those, and they are dropped from any merged result.

## See also

[`EJAM::tables_ejscreen_acs`](https://public-environmental-data-partners.github.io/EJAM/reference/tables_ejscreen_acs.html)
