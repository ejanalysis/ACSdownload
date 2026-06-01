# Look up the human-readable label for one or more ACS variable codes

Returns a data.table joining the input codes to the table title, label,
and population universe from `acs_table_shells`. Useful for turning the
cryptic column names that
[`get_acs_new()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_new.md)
returns (e.g. `"B01001_001"`) into something a reader can understand.

## Usage

``` r
acs_label(variable_id)
```

## Arguments

- variable_id:

  character vector of ACS variable codes (e.g. `"B01001_001"`). The
  trailing margin-of-error variant (`"B01001_M001"`) is automatically
  normalized to the estimate variable, so MOE columns get their
  estimate's label.

## Value

a data.table with one row per input, columns: `variable_id` (as
supplied), `table_id`, `label`, `table_title`, `universe`. Unmatched
codes get NA in the lookup columns.

## Details

The shipped lookup is built from the 2022 5-year vintage of the Census
table shells. Labels for tables that exist across multiple vintages are
stable; for unfamiliar tables, double-check the official documentation
at <https://data.census.gov/>.

## Examples

``` r
 acs_label(c("B01001_001", "B01001_M001", "C16001_002"))
#>    variable_id table_id              label
#>         <char>   <char>             <char>
#> 1:  B01001_001   B01001             Total:
#> 2: B01001_M001   B01001             Total:
#> 3:  C16001_002   C16001 Speak only English
#>                                                    table_title
#>                                                         <char>
#> 1:                                                  Sex by Age
#> 2:                                                  Sex by Age
#> 3: Language Spoken at Home for the Population 5 Years and Over
#>                       universe
#>                         <char>
#> 1:            Total population
#> 2:            Total population
#> 3: Population 5 years and over
```
