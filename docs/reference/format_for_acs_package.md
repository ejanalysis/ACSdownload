# Reformat ACS Data Obtained by [`get.acs()`](reference/get.acs.md) for Import to the acs Package

Work in progress \*\*\*\*\*  
  
Currently only works for 5-year summary file data from ACS. Use same
format as American Fact Finder uses for downloaded csv of tract data,
for example. Format is ESTIMATE, MOE, ESTIMATE, MOE... and KEY cols are
GEOID, FIPS, AND NAME, but also SUMLEVEL (specifies if tract or
blockgroup, for example), and not STUSAB (2-letter State abbreviation).

## Usage

``` r
format_for_acs_package(
  x,
  tableid = "",
  folder = getwd(),
  end.year = acsdefaultendyearhere_func(),
  savefile = TRUE
)
```

## Arguments

- x:

  Required list of tables from earlier steps in
  [`get.acs()`](reference/get.acs.md)

- tableid:

  Used to name any saved file. Should be a string such as 'B01001'.
  Default is ”

- folder:

  Default is getwd() and specifies where to save csv if savefile=TRUE

- end.year:

  Optional, text to use in filename if savefile=TRUE. The acs package
  needs this in the filename to infer the year, or that can be specified
  as the `endyear` parameter in
  [`acs::read.acs()`](https://rdrr.io/pkg/acs/man/read.acs.html)

- savefile:

  Default is TRUE which means save a csv file to folder

## Value

Data.frame for use in
[acs](https://rdrr.io/pkg/acs/man/acs-package.html) package.

## Details

Downloading C17002 from American Fact Finder results in a zip file with
csv as follows:  
ACS_13_5YR_B01001_with_ann.csv or ACS_12_5YR_C17002_with_ann.csv is
format of the data file with estimates and MOE values  
First row is header with field names. Other rows are tract data.  
Note that the fields are:  
GEOID, FIPS, NAME, e1, m1, e2, m2, etc.  
Columns 1,2,3 are geo information. Columns 4+ are data
(estimate,moe,estimate,moe, etc.)  
First 2 rows example:  
GEO.id,GEO.id2,GEO.display-label,HD01_VD01,HD02_VD01,HD01_VD02,HD02_VD02,HD01_VD03,HD02_VD03,HD01_VD04,HD02_VD04,HD01_VD05,HD02_VD05,HD01_VD06,HD02_VD06,HD01_VD07,HD02_VD07,HD01_VD08,HD02_VD08  
0800000US110015000050000000501,110015000050000000501,"Census Tract 5.01,
Washington city, Washington city, District of Columbia, District of
Columbia",3113,296,232,164,50,47,77,84,82,90,199,122,19,29,2454,312  

ACS_12_5YR_C17002_metadata.csv has the long and short variable names.  
There is no header row. A header of field names would be these 2:
"short.name", "long.name"  
Each row here corresponds to one column of the data/moe fields (after
the geo fields) in the main data file.  
First few rows example:  
GEO.id,Id This is like GEOID field in acs via ftp GEO.id2,Id2 This seems
to be like FIPS string portion of GEOID  
GEO.display-label,Geography This is a full place name (NAME)  
HD01_VD01,Estimate; Total:  
HD02_VD01,Margin of Error; Total:  
HD01_VD02,Estimate; Total: - Under .50  
HD02_VD02,Margin of Error; Total: - Under .50  
  

e.g.,  
GEO.id GEO.id2 GEO.display.label HD01_VD01  
1 Id Id2 Geography Estimate; Total:  
2 1400000US24031700101 24031700101 Census Tract 7001.01, Montgomery
County, Maryland 4477  
3 1400000US24031700103 24031700103 Census Tract 7001.03, Montgomery
County, Maryland 5776  

JUST TRACTS were available from Fact Finder up to 2008-2012 ACS, so that
is what acs package would typically import until recently.  
Actually starting with 2009-2013 ACS, block groups are available via
AFF, but only by specifying one (or each) county in a State.  
\###############################################################################  

## See also

[`get.acs()`](reference/get.acs.md) to obtain acs data for use in this
function, and then
[`acs::read.acs()`](https://rdrr.io/pkg/acs/man/read.acs.html) to read
csv created by this function
