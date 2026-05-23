# Download File with Information about ACS 5-Year Summary File Tables

Download and read lookup table of information on American Community
Survey (ACS) tables, from the Census Bureau, namely which sequence files
on the FTP site contain which tables and which variables. NOTE: This is
largely obsolete now that data(lookup.acs2013) and similar files for
other years are in this package.

## Usage

``` r
download.lookup.acs(
  end.year = acsdefaultendyearhere,
  folder = NULL,
  silent = FALSE
)
```

## Arguments

- end.year:

  Character, optional, like '2020', which specifies the 2016-2020
  dataset. Defines which 5-year summary file to use, based on end-year.
  Can be acsfirstyearavailablehere or later. Data for end.year='2019'
  were released in December 2020, for example. The 2017-2021 American
  Community Survey 5-year estimates are scheduled to be released on
  Thursday, December 8, 2022.

- folder:

  Optional path to where to download file to, defaults to temp folder.

- silent:

  Optional, default is FALSE. Whether to send progress info to standard
  output (like the screen)

## Value

By default, returns a data.frame with these fields:

- \$ Table.ID : chr "B00001" "B00001" "B00001" "B00002" ...

- \$ Sequence.Number : chr "0001" "0001" "0001" "0001" ...

- \$ Line.Number : num NA NA 1 NA NA 1 NA NA 1 2 ...

- \$ Start.Position : num 7 NA NA 8 NA NA 7 NA NA NA ...

- \$ Total.Cells.in.Table : chr "1 CELL" "" "" "1 CELL" ...

- \$ Total.Cells.in.Sequence: num NA NA NA 2 NA NA NA NA NA NA ...

- \$ Table.Title : chr "UNWEIGHTED SAMPLE COUNT OF THE POPULATION"
  "Universe: Total population" "Total" "UNWEIGHTED SAMPLE HOUSING UNITS"
  ...

- \$ Subject.Area : chr "Unweighted Count" "" "" "Unweighted Count" ...

For ACS 2008-2012:

    length(my.lookup[,1])
    #   24741
    names(my.lookup)
    #  "File.ID"                 "Table.ID"                "Sequence.Number"         "Line.Number"             "Start.Position" \cr
    #  "Total.Cells.in.Table"    "Total.Cells.in.Sequence" "Table.Title"             "Subject.Area"

Also see
[`get.lookup.acs()`](https://ejanalysis.github.io/ACSdownload/reference/get.lookup.acs.md)
which does the same without downloading file – uses the copy in data()
Also see `data(lookup.acs2013)` and similar data for other years. Also
see
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md),
[`get.lookup.file.name()`](https://ejanalysis.github.io/ACSdownload/reference/get.lookup.file.name.md),
[`get.url.prefix.lookup.table()`](https://ejanalysis.github.io/ACSdownload/reference/get.url.prefix.lookup.table.md)

## Details

For information on new Summary File format visit:

https://www.census.gov/programs-surveys/acs/data/summary-file.html

    Lookup table of sequence files and variables was here:  \cr

  
<https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt>  
  
  
The 2014-2018 folders are here:  
<https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/geography/>  
<https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/user_tools/>  
  
Data tables by state by seqfile were here:  
  
<https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Alabama/Tracts_Block_Groups_Only/>  
such as  
<https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Alabama/Tracts_Block_Groups_Only/20175al0001000.zip>  
  
Geographies in Excel spreadsheets were here:  
  
<https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/geography/5yr_year_geo/>  
such as  
<https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/geography/5yr_year_geo/ak.xlsx>  

## Examples

``` r
 if (FALSE) { # \dontrun{
 lookup.acs <- download.lookup.acs(2022)
 } # }
```
