# Utility to Clean SUMLEVEL for get_acs_old

Utility function used by
[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md).

## Usage

``` r
clean.sumlevel(sumlevel = "bg")
```

## Arguments

- sumlevel:

  Character vector (1+ elements), optional, 'bg' by default. See details
  above.

## Value

Returns 'both', 'tract', or 'bg' (or stops with error if cannot
interpret sumlevel input)

## Details

Interprets as 'bg' any of these: 150, '150', 'blockgroup', 'block
group', or 'bg' (or variants, ignoring case)  
Interprets as 'tract' any of these: 140, '140', or 'tract' (or variants,
ignoring case)  
Interprets as 'both' any of these: 'both' or a vector that has both of
the above terms (or variants, ignoring case).

## See also

[`get_acs_old()`](https://ejanalysis.github.io/ACSdownload/reference/get_acs_old.md)
which uses this
