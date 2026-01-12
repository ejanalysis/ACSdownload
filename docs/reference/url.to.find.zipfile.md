# Get URL(s) for FTP site folder(s) with ACS 5-year summary file data

Returns URLs of folders on Census Bureau FTP site with zip files based
on end year.

## Usage

``` r
url.to.find.zipfile(mystates, end.year = acsdefaultendyearhere, url.prefix)
```

## Arguments

- mystates:

  Character vector of one or more states/DC/PR, as 2-character state
  abbreviations. Default is all states/DC/PR.

- end.year:

  Optional end year for 5-year summary file, as character, but ignored
  if url.prefix is specified

- url.prefix:

  Optional character element that defaults to what is returned by
  `[get.url.prefix](end.year)`

## Value

Returns character vector that is URL(s) such as
"ftp://ftp.census.gov/acs2012_5yr/summaryfile"

## Details

See help for [`download.lookup.acs()`](reference/download.lookup.acs.md)
for more details on the URLs used for the data.

The zip files look like this for example: "20135dc0001000.zip"  
  
The 2009-2013 summary file by state-seqfile combo is in folders that
look like this:  
  
(ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only)

## also see "https://www2.census.gov/programs-surveys/acs/summary_file/2022/table-based-SF/data/5YRData/"

The 2008-2012 summary file by state-seqfile combo is in folders that
look like this:  
  
(http://www2.census.gov/acs2012_5yr/summaryfile/2008-2012_ACSSF_By_State_By_Sequence_Table_Subset/Alabama/Tracts_Block_Groups_Only)  

The 2007-2011 summary file by state-seqfile combo is in folders that
look like this:  
  
(ftp://ftp.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/)  
URL must be the ftp site, not the http version.

http version was here
(http://www2.census.gov/acs2011_5yr/summaryfile/2007-2011_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/)  

## See also

[`get_acs_old()`](reference/get_acs_old.md), `url.to.find.zipfile()`,
[`download.geo()`](reference/download.geo.md)
