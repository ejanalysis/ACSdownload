# Get name(s) of zip file(s) for ACS 5-year summary file data

Returns name(s) of zip file(s) based on state(s), a sequence file
number, a prefix, and end year.

## Usage

``` r
zipfile(mystates, seqfilenum, zipfile.prefix, end.year = acsdefaultendyearhere)
```

## Arguments

- mystates:

  Required vector of 2-character state abbreviation(s)

- seqfilenum:

  Required single sequence file number used by ACS 5-year summary file

- zipfile.prefix:

  Optional character element, defaults to value looked up based on
  end.year.

- end.year:

  Optional end year for 5-year summary file, as character, like '2018'

## Value

Returns character element that is name of zip file such as
"20115dc0113000.zip"

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)
