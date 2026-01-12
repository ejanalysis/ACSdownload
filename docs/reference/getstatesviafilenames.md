# Infer US States based on ACS 5-yr filenames in folder

Helper function to look for unzipped csv files of estimates for American
Community Survey (ACS) 5-year summary file data obtained from US Census
FTP site, based on pattern matching, and infer State abbreviations based
on those filenames.

## Usage

``` r
getstatesviafilenames(folder = getwd())
```

## Arguments

- folder:

  Default is current working directory.

## Value

Returns a vector of unique upper case US State abbreviations

## See also

[`read.concat.states()`](reference/read.concat.states.md) which uses
this
