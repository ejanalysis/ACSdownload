# Reorder cols of estimates and MOE table

Start with a table that has all the estimates columns together, followed
by all the MOEs columns, and create a new column sort order so that
estimates will be interspersed with (next to) their MOE values, as
FactFinder format provides.

## Usage

``` r
format_est_moe(my.list.of.tables)
```

## Arguments

- my.list.of.tables:

  Required list of tables from earlier steps in
  [`get_acs_old()`](reference/get_acs_old.md)

## Value

List of tables like input but with columns sorted in a new order.

## See also

[`get_acs_old()`](reference/get_acs_old.md) and
[`analyze.stuff::intersperse()`](https://rdrr.io/pkg/analyze.stuff/man/intersperse.html)
