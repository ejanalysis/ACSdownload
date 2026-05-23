# Get field names etc for ACS tables - somewhat obsolete/not updated

Get info on tables from US Census Bureau for American Community Survey
5-year summary file.

## Usage

``` r
get.table.info(
  tables,
  end.year = acsdefaultendyearhere,
  table.info.only = TRUE,
  moe = FALSE
)
```

## Arguments

- tables:

  Required vector of tables such as "B01001"

- end.year:

  Last year of 5-year summary file such as '2012'

- table.info.only:

  TRUE by default. See
  [`get.field.info()`](https://ejanalysis.github.io/ACSdownload/reference/get.field.info.md)

- moe:

  FALSE by default. If TRUE, returns MOE versions of field names and
  descriptions.

## Value

data.frame of information about each table and each variable in table:  
Table.ID, Line.Number, Table.Title, table.var, varname2  
  
\# Value returned is data.frame of info about each table and also each
variable in the table:  

        Table.ID Line.Number                                                 Table.Title  table.var                                           varname2\cr

7 B01001 NA SEX BY AGE SEXBYAGE  
8 B01001 NA Universe: Total population UniverseTotalpopulation  
9 B01001 1 Total: B01001.001 Total  
10 B01001 2 Male: B01001.002 Male  

## Details

Wrapper for
[`get.table.info2()`](https://ejanalysis.github.io/ACSdownload/reference/get.table.info2.md)
which is a wrapper for
[`get.field.info()`](https://ejanalysis.github.io/ACSdownload/reference/get.field.info.md)

## See also

[tidycensus package](https://walker-data.com/tidycensus/index.html)
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
`get.table.info()`, and
[`get.field.info()`](https://ejanalysis.github.io/ACSdownload/reference/get.field.info.md)
