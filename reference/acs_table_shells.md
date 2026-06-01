# Lookup from ACS variable code to its human-readable label

Tidy version of the Census Bureau's ACS 5-Year Table Shells file. Use
this to turn cryptic column codes like `"B01001_001"` into a
human-readable label (`"Total:"`), the parent table title
(`"Sex by Age"`), and the population universe (`"Total population"`).

## Usage

``` r
acs_table_shells
```

## Format

An object of class `data.table` (inherits from `data.frame`) with 28331
rows and 8 columns.

## Details

Census refreshes the underlying file each vintage, but the labels for
tables that persist across vintages are stable. The version shipped here
was generated from the 2022 5-year release; refresh by replacing
`inst/ACS20225YR_Table_Shells.txt` and re-running
`data-raw/datacreate_acs_table_shells.R`.

Columns:

- `variable_id` – e.g. "B01001_001"

- `table_id` – e.g. "B01001"

- `label` – e.g. "Total:", "Under 5 years"

- `table_title` – e.g. "Sex by Age"

- `universe` – e.g. "Total population"

- `indent` – depth of the row within the table

- `line` – Census line number

- `type` – "int", "float", etc.
