out <- get.acs(tables='ejscreen', end.year = '2013', writefiles = TRUE, save.files = TRUE)
2015-07-17 22:40:07  Started scripts to download and parse ACS data
data.path is now set to /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata 
2015-07-17 22:40:07  Started getting URLs, table/variable name lookup table, etc. 
2015-07-17 22:40:07  Finished getting URLs, table/variable name lookup table, etc. 
2015-07-17 22:40:07  Started specifying which variables are needed from the specified ACS tables 
  Finished writing template file to working directory on disk: variables needed template.csv
  Reading input file of variable selections, variables needed.csv
          (or template for all variables if variables needed.csv was not found)
  Finished reading  variables needed template.csv
2015-07-17 22:40:07  Finished specifying which variables are needed from the specified ACS tables 
2015-07-17 22:40:07  Started to download geo files 
                      Trying to download g20135al.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Alabama/Tracts_Block_Groups_Only/g20135al.txt
                      Trying to download g20135ak.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Alaska/Tracts_Block_Groups_Only/g20135ak.txt
                      Trying to download g20135az.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Arizona/Tracts_Block_Groups_Only/g20135az.txt
                      Trying to download g20135ar.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Arkansas/Tracts_Block_Groups_Only/g20135ar.txt
Warning: Unable to download geo fileg20135ar.txt
                      Warning: File size zero for g20135ar.txt
                      Trying to download g20135ar.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Arkansas/Tracts_Block_Groups_Only/g20135ar.txt
                      Trying to download g20135ca.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/California/Tracts_Block_Groups_Only/g20135ca.txt
                      Trying to download g20135co.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Colorado/Tracts_Block_Groups_Only/g20135co.txt
Warning: Unable to download geo fileg20135co.txt
                      Warning: File size zero for g20135co.txt
                      Trying to download g20135co.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Colorado/Tracts_Block_Groups_Only/g20135co.txt
                      Trying to download g20135ct.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Connecticut/Tracts_Block_Groups_Only/g20135ct.txt
                      Trying to download g20135de.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Delaware/Tracts_Block_Groups_Only/g20135de.txt
Warning: Unable to download geo fileg20135de.txt
                      Warning: File size zero for g20135de.txt
                      Trying to download g20135de.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Delaware/Tracts_Block_Groups_Only/g20135de.txt
Warning: Unable to download geo fileg20135de.txt
                      Warning: File size zero for g20135de.txt
                      Trying to download g20135de.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Delaware/Tracts_Block_Groups_Only/g20135de.txt
                      Trying to download g20135dc.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/DistrictOfColumbia/Tracts_Block_Groups_Only/g20135dc.txt
                      Trying to download g20135fl.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Florida/Tracts_Block_Groups_Only/g20135fl.txt
Warning: Unable to download geo fileg20135fl.txt
                      Warning: File size zero for g20135fl.txt
                      Trying to download g20135fl.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Florida/Tracts_Block_Groups_Only/g20135fl.txt
                      Trying to download g20135ga.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Georgia/Tracts_Block_Groups_Only/g20135ga.txt
                      Trying to download g20135hi.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Hawaii/Tracts_Block_Groups_Only/g20135hi.txt
                      Trying to download g20135id.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Idaho/Tracts_Block_Groups_Only/g20135id.txt
                      Trying to download g20135il.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Illinois/Tracts_Block_Groups_Only/g20135il.txt
                      Trying to download g20135in.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Indiana/Tracts_Block_Groups_Only/g20135in.txt
                      Trying to download g20135ia.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Iowa/Tracts_Block_Groups_Only/g20135ia.txt
Warning: Unable to download geo fileg20135ia.txt
                      Warning: File size zero for g20135ia.txt
                      Trying to download g20135ia.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Iowa/Tracts_Block_Groups_Only/g20135ia.txt
                      Trying to download g20135ks.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Kansas/Tracts_Block_Groups_Only/g20135ks.txt
                      Trying to download g20135ky.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Kentucky/Tracts_Block_Groups_Only/g20135ky.txt
                      Trying to download g20135la.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Louisiana/Tracts_Block_Groups_Only/g20135la.txt
                      Trying to download g20135me.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Maine/Tracts_Block_Groups_Only/g20135me.txt
                      Trying to download g20135md.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Maryland/Tracts_Block_Groups_Only/g20135md.txt
                      Trying to download g20135ma.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Massachusetts/Tracts_Block_Groups_Only/g20135ma.txt
                      Trying to download g20135mi.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Michigan/Tracts_Block_Groups_Only/g20135mi.txt
                      Trying to download g20135mn.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Minnesota/Tracts_Block_Groups_Only/g20135mn.txt
                      Trying to download g20135ms.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Mississippi/Tracts_Block_Groups_Only/g20135ms.txt
                      Trying to download g20135mo.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Missouri/Tracts_Block_Groups_Only/g20135mo.txt
                      Trying to download g20135mt.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Montana/Tracts_Block_Groups_Only/g20135mt.txt
                      Trying to download g20135ne.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Nebraska/Tracts_Block_Groups_Only/g20135ne.txt
Warning: Unable to download geo fileg20135ne.txt
                      Warning: File size zero for g20135ne.txt
                      Trying to download g20135ne.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Nebraska/Tracts_Block_Groups_Only/g20135ne.txt
                      Trying to download g20135nv.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Nevada/Tracts_Block_Groups_Only/g20135nv.txt
                      Trying to download g20135nh.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NewHampshire/Tracts_Block_Groups_Only/g20135nh.txt
                      Trying to download g20135nj.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NewJersey/Tracts_Block_Groups_Only/g20135nj.txt
Warning: Unable to download geo fileg20135nj.txt
                      Warning: File size zero for g20135nj.txt
                      Trying to download g20135nj.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NewJersey/Tracts_Block_Groups_Only/g20135nj.txt
Warning: Unable to download geo fileg20135nj.txt
                      Warning: File size zero for g20135nj.txt
                      Trying to download g20135nj.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NewJersey/Tracts_Block_Groups_Only/g20135nj.txt
                      Trying to download g20135nm.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NewMexico/Tracts_Block_Groups_Only/g20135nm.txt
                      Trying to download g20135ny.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NewYork/Tracts_Block_Groups_Only/g20135ny.txt
                      Trying to download g20135nc.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NorthCarolina/Tracts_Block_Groups_Only/g20135nc.txt
                      Trying to download g20135nd.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NorthDakota/Tracts_Block_Groups_Only/g20135nd.txt
Warning: Unable to download geo fileg20135nd.txt
                      Warning: File size zero for g20135nd.txt
                      Trying to download g20135nd.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/NorthDakota/Tracts_Block_Groups_Only/g20135nd.txt
                      Trying to download g20135oh.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Ohio/Tracts_Block_Groups_Only/g20135oh.txt
                      Trying to download g20135ok.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Oklahoma/Tracts_Block_Groups_Only/g20135ok.txt
                      Trying to download g20135or.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Oregon/Tracts_Block_Groups_Only/g20135or.txt
                      Trying to download g20135pa.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Pennsylvania/Tracts_Block_Groups_Only/g20135pa.txt
                      Trying to download g20135ri.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/RhodeIsland/Tracts_Block_Groups_Only/g20135ri.txt
                      Trying to download g20135sc.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/SouthCarolina/Tracts_Block_Groups_Only/g20135sc.txt
Warning: Unable to download geo fileg20135sc.txt
                      Warning: File size zero for g20135sc.txt
                      Trying to download g20135sc.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/SouthCarolina/Tracts_Block_Groups_Only/g20135sc.txt
                      Trying to download g20135sd.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/SouthDakota/Tracts_Block_Groups_Only/g20135sd.txt
                      Trying to download g20135tn.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Tennessee/Tracts_Block_Groups_Only/g20135tn.txt
                      Trying to download g20135tx.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Texas/Tracts_Block_Groups_Only/g20135tx.txt
Warning: Unable to download geo fileg20135tx.txt
                      Warning: File size zero for g20135tx.txt
                      Trying to download g20135tx.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Texas/Tracts_Block_Groups_Only/g20135tx.txt
                      Trying to download g20135ut.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Utah/Tracts_Block_Groups_Only/g20135ut.txt
Warning: Unable to download geo fileg20135ut.txt
                      Warning: File size zero for g20135ut.txt
                      Trying to download g20135ut.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Utah/Tracts_Block_Groups_Only/g20135ut.txt
                      Trying to download g20135vt.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Vermont/Tracts_Block_Groups_Only/g20135vt.txt
                      Trying to download g20135va.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Virginia/Tracts_Block_Groups_Only/g20135va.txt
                      Trying to download g20135wa.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Washington/Tracts_Block_Groups_Only/g20135wa.txt
Warning: Unable to download geo fileg20135wa.txt
                      Warning: File size zero for g20135wa.txt
                      Trying to download g20135wa.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Washington/Tracts_Block_Groups_Only/g20135wa.txt
                      Trying to download g20135wv.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/WestVirginia/Tracts_Block_Groups_Only/g20135wv.txt
                      Trying to download g20135wi.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Wisconsin/Tracts_Block_Groups_Only/g20135wi.txt
                      Trying to download g20135wy.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/Wyoming/Tracts_Block_Groups_Only/g20135wy.txt
                      Trying to download g20135pr.txt from ftp://ftp.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/PuertoRico/Tracts_Block_Groups_Only/g20135pr.txt

                       WARNING: Some geo data files that should have been downloaded are missing:
Missing:  g20135us.txt
2015-07-17 23:02:30  Finished downloading geo files 
2015-07-17 23:02:30  Started parsing geo files 
alakazarcacoctdedcflgahiidiliniakskylamemdmamimnmsmomtnenvnhnjnmnyncndohokorpariscsdtntxutvtvawawvwiwypr
2015-07-17 23:05:14  Finished parsing geo files 
2015-07-17 23:05:14  Started cleaning up geo files 
2015-07-17 23:05:16  Finished cleaning up geo files 
2015-07-17 23:05:16  Started saving geo files on disk 
2015-07-17 23:05:17  Finished saving geo.RData file on disk 
2015-07-17 23:05:17  Started downloading data files... 
  Tables:  B01001 B03002 B15002 B16002 C17002 B25034 
  End year:  2013 
  States:  al ak az ar ca co ct de dc fl ga hi id il in ia ks ky la me md ma mi mn ms mo mt ne nv nh nj nm ny nc nd oh ok or pa ri sc sd tn tx ut vt va wa wv wi wy pr us 
Checking  20135al0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125al0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135al0002000.zip
Downloaded. 
Checking  20135al0005000.zip ... Downloaded. 
Checking  20135al0043000.zip ... Downloaded. 
Checking  20135al0044000.zip ... Downloaded. 
Checking  20135al0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125al0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135al0049000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125al0049000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135al0049000.zip
Attempt # 4  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125al0049000.zip on attempt  3  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135al0049000.zip
Downloaded. 
Checking  20135al0104000.zip ... Downloaded. 
Checking  20135ak0002000.zip ... Downloaded. 
Checking  20135ak0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ak0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ak0005000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ak0005000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ak0005000.zip
Downloaded. 
Checking  20135ak0043000.zip ... Downloaded. 
Checking  20135ak0044000.zip ... Downloaded. 
Checking  20135ak0049000.zip ... Downloaded. 
Checking  20135ak0104000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ak0104000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ak0104000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ak0104000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ak0104000.zip
Downloaded. 
Checking  20135az0002000.zip ... Downloaded. 
Checking  20135az0005000.zip ... Downloaded. 
Checking  20135az0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125az0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135az0043000.zip
Downloaded. 
Checking  20135az0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125az0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135az0044000.zip
Downloaded. 
Checking  20135az0049000.zip ... Downloaded. 
Checking  20135az0104000.zip ... Downloaded. 
Checking  20135ar0002000.zip ... Downloaded. 
Checking  20135ar0005000.zip ... Downloaded. 
Checking  20135ar0043000.zip ... Downloaded. 
Checking  20135ar0044000.zip ... Downloaded. 
Checking  20135ar0049000.zip ... Downloaded. 
Checking  20135ar0104000.zip ... Downloaded. 
Checking  20135ca0002000.zip ... Downloaded. 
Checking  20135ca0005000.zip ... Downloaded. 
Checking  20135ca0043000.zip ... Downloaded. 
Checking  20135ca0044000.zip ... Downloaded. 
Checking  20135ca0049000.zip ... Downloaded. 
Checking  20135ca0104000.zip ... Downloaded. 
Checking  20135co0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125co0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135co0002000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125co0002000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135co0002000.zip
Downloaded. 
Checking  20135co0005000.zip ... Downloaded. 
Checking  20135co0043000.zip ... Downloaded. 
Checking  20135co0044000.zip ... Downloaded. 
Checking  20135co0049000.zip ... Downloaded. 
Checking  20135co0104000.zip ... Downloaded. 
Checking  20135ct0002000.zip ... Downloaded. 
Checking  20135ct0005000.zip ... Downloaded. 
Checking  20135ct0043000.zip ... Downloaded. 
Checking  20135ct0044000.zip ... Downloaded. 
Checking  20135ct0049000.zip ... Downloaded. 
Checking  20135ct0104000.zip ... Downloaded. 
Checking  20135de0002000.zip ... Downloaded. 
Checking  20135de0005000.zip ... Downloaded. 
Checking  20135de0043000.zip ... Downloaded. 
Checking  20135de0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125de0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135de0044000.zip
Downloaded. 
Checking  20135de0049000.zip ... Downloaded. 
Checking  20135de0104000.zip ... Downloaded. 
Checking  20135dc0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125dc0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135dc0002000.zip
Downloaded. 
Checking  20135dc0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125dc0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135dc0005000.zip
Downloaded. 
Checking  20135dc0043000.zip ... Downloaded. 
Checking  20135dc0044000.zip ... Downloaded. 
Checking  20135dc0049000.zip ... Downloaded. 
Checking  20135dc0104000.zip ... Downloaded. 
Checking  20135fl0002000.zip ... Downloaded. 
Checking  20135fl0005000.zip ... Downloaded. 
Checking  20135fl0043000.zip ... Downloaded. 
Checking  20135fl0044000.zip ... Downloaded. 
Checking  20135fl0049000.zip ... Downloaded. 
Checking  20135fl0104000.zip ... Downloaded. 
Checking  20135ga0002000.zip ... Downloaded. 
Checking  20135ga0005000.zip ... Downloaded. 
Checking  20135ga0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ga0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ga0043000.zip
Downloaded. 
Checking  20135ga0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ga0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ga0044000.zip
Downloaded. 
Checking  20135ga0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ga0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ga0049000.zip
Downloaded. 
Checking  20135ga0104000.zip ... Downloaded. 
Checking  20135hi0002000.zip ... Downloaded. 
Checking  20135hi0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125hi0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135hi0005000.zip
Downloaded. 
Checking  20135hi0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125hi0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135hi0043000.zip
Downloaded. 
Checking  20135hi0044000.zip ... Downloaded. 
Checking  20135hi0049000.zip ... Downloaded. 
Checking  20135hi0104000.zip ... Downloaded. 
Checking  20135id0002000.zip ... Downloaded. 
Checking  20135id0005000.zip ... Downloaded. 
Checking  20135id0043000.zip ... Downloaded. 
Checking  20135id0044000.zip ... Downloaded. 
Checking  20135id0049000.zip ... Downloaded. 
Checking  20135id0104000.zip ... Downloaded. 
Checking  20135il0002000.zip ... Downloaded. 
Checking  20135il0005000.zip ... Downloaded. 
Checking  20135il0043000.zip ... Downloaded. 
Checking  20135il0044000.zip ... Downloaded. 
Checking  20135il0049000.zip ... Downloaded. 
Checking  20135il0104000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125il0104000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135il0104000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125il0104000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135il0104000.zip
Downloaded. 
Checking  20135in0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125in0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135in0002000.zip
Downloaded. 
Checking  20135in0005000.zip ... Downloaded. 
Checking  20135in0043000.zip ... Downloaded. 
Checking  20135in0044000.zip ... Downloaded. 
Checking  20135in0049000.zip ... Downloaded. 
Checking  20135in0104000.zip ... Downloaded. 
Checking  20135ia0002000.zip ... Downloaded. 
Checking  20135ia0005000.zip ... Downloaded. 
Checking  20135ia0043000.zip ... Downloaded. 
Checking  20135ia0044000.zip ... Downloaded. 
Checking  20135ia0049000.zip ... Downloaded. 
Checking  20135ia0104000.zip ... Downloaded. 
Checking  20135ks0002000.zip ... Downloaded. 
Checking  20135ks0005000.zip ... Downloaded. 
Checking  20135ks0043000.zip ... Downloaded. 
Checking  20135ks0044000.zip ... Downloaded. 
Checking  20135ks0049000.zip ... Downloaded. 
Checking  20135ks0104000.zip ... Downloaded. 
Checking  20135ky0002000.zip ... Downloaded. 
Checking  20135ky0005000.zip ... Downloaded. 
Checking  20135ky0043000.zip ... Downloaded. 
Checking  20135ky0044000.zip ... Downloaded. 
Checking  20135ky0049000.zip ... Downloaded. 
Checking  20135ky0104000.zip ... Downloaded. 
Checking  20135la0002000.zip ... Downloaded. 
Checking  20135la0005000.zip ... Downloaded. 
Checking  20135la0043000.zip ... Downloaded. 
Checking  20135la0044000.zip ... Downloaded. 
Checking  20135la0049000.zip ... Downloaded. 
Checking  20135la0104000.zip ... Downloaded. 
Checking  20135me0002000.zip ... Downloaded. 
Checking  20135me0005000.zip ... Downloaded. 
Checking  20135me0043000.zip ... Downloaded. 
Checking  20135me0044000.zip ... Downloaded. 
Checking  20135me0049000.zip ... Downloaded. 
Checking  20135me0104000.zip ... Downloaded. 
Checking  20135md0002000.zip ... Downloaded. 
Checking  20135md0005000.zip ... Downloaded. 
Checking  20135md0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125md0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135md0043000.zip
Downloaded. 
Checking  20135md0044000.zip ... Downloaded. 
Checking  20135md0049000.zip ... Downloaded. 
Checking  20135md0104000.zip ... Downloaded. 
Checking  20135ma0002000.zip ... Downloaded. 
Checking  20135ma0005000.zip ... Downloaded. 
Checking  20135ma0043000.zip ... Downloaded. 
Checking  20135ma0044000.zip ... Downloaded. 
Checking  20135ma0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ma0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ma0049000.zip
Downloaded. 
Checking  20135ma0104000.zip ... Downloaded. 
Checking  20135mi0002000.zip ... Downloaded. 
Checking  20135mi0005000.zip ... Downloaded. 
Checking  20135mi0043000.zip ... Downloaded. 
Checking  20135mi0044000.zip ... Downloaded. 
Checking  20135mi0049000.zip ... Downloaded. 
Checking  20135mi0104000.zip ... Downloaded. 
Checking  20135mn0002000.zip ... Downloaded. 
Checking  20135mn0005000.zip ... Downloaded. 
Checking  20135mn0043000.zip ... Downloaded. 
Checking  20135mn0044000.zip ... Downloaded. 
Checking  20135mn0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125mn0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135mn0049000.zip
Downloaded. 
Checking  20135mn0104000.zip ... Downloaded. 
Checking  20135ms0002000.zip ... Downloaded. 
Checking  20135ms0005000.zip ... Downloaded. 
Checking  20135ms0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ms0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ms0043000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ms0043000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ms0043000.zip
Downloaded. 
Checking  20135ms0044000.zip ... Downloaded. 
Checking  20135ms0049000.zip ... Downloaded. 
Checking  20135ms0104000.zip ... Downloaded. 
Checking  20135mo0002000.zip ... Downloaded. 
Checking  20135mo0005000.zip ... Downloaded. 
Checking  20135mo0043000.zip ... Downloaded. 
Checking  20135mo0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125mo0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135mo0044000.zip
Downloaded. 
Checking  20135mo0049000.zip ... Downloaded. 
Checking  20135mo0104000.zip ... Downloaded. 
Checking  20135mt0002000.zip ... Downloaded. 
Checking  20135mt0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125mt0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135mt0005000.zip
Downloaded. 
Checking  20135mt0043000.zip ... Downloaded. 
Checking  20135mt0044000.zip ... Downloaded. 
Checking  20135mt0049000.zip ... Downloaded. 
Checking  20135mt0104000.zip ... Downloaded. 
Checking  20135ne0002000.zip ... Downloaded. 
Checking  20135ne0005000.zip ... Downloaded. 
Checking  20135ne0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ne0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ne0043000.zip
Downloaded. 
Checking  20135ne0044000.zip ... Downloaded. 
Checking  20135ne0049000.zip ... Downloaded. 
Checking  20135ne0104000.zip ... Downloaded. 
Checking  20135nv0002000.zip ... Downloaded. 
Checking  20135nv0005000.zip ... Downloaded. 
Checking  20135nv0043000.zip ... Downloaded. 
Checking  20135nv0044000.zip ... Downloaded. 
Checking  20135nv0049000.zip ... Downloaded. 
Checking  20135nv0104000.zip ... Downloaded. 
Checking  20135nh0002000.zip ... Downloaded. 
Checking  20135nh0005000.zip ... Downloaded. 
Checking  20135nh0043000.zip ... Downloaded. 
Checking  20135nh0044000.zip ... Downloaded. 
Checking  20135nh0049000.zip ... Downloaded. 
Checking  20135nh0104000.zip ... Downloaded. 
Checking  20135nj0002000.zip ... Downloaded. 
Checking  20135nj0005000.zip ... Downloaded. 
Checking  20135nj0043000.zip ... Downloaded. 
Checking  20135nj0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nj0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nj0044000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nj0044000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nj0044000.zip
Downloaded. 
Checking  20135nj0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nj0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nj0049000.zip
Downloaded. 
Checking  20135nj0104000.zip ... Downloaded. 
Checking  20135nm0002000.zip ... Downloaded. 
Checking  20135nm0005000.zip ... Downloaded. 
Checking  20135nm0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nm0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nm0043000.zip
Downloaded. 
Checking  20135nm0044000.zip ... Downloaded. 
Checking  20135nm0049000.zip ... Downloaded. 
Checking  20135nm0104000.zip ... Downloaded. 
Checking  20135ny0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ny0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ny0002000.zip
Downloaded. 
Checking  20135ny0005000.zip ... Downloaded. 
Checking  20135ny0043000.zip ... Downloaded. 
Checking  20135ny0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ny0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ny0044000.zip
Downloaded. 
Checking  20135ny0049000.zip ... Downloaded. 
Checking  20135ny0104000.zip ... Downloaded. 
Checking  20135nc0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nc0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nc0002000.zip
Downloaded. 
Checking  20135nc0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nc0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nc0005000.zip
Downloaded. 
Checking  20135nc0043000.zip ... Downloaded. 
Checking  20135nc0044000.zip ... Downloaded. 
Checking  20135nc0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nc0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nc0049000.zip
Downloaded. 
Checking  20135nc0104000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nc0104000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nc0104000.zip
Downloaded. 
Checking  20135nd0002000.zip ... Downloaded. 
Checking  20135nd0005000.zip ... Downloaded. 
Checking  20135nd0043000.zip ... Downloaded. 
Checking  20135nd0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125nd0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135nd0044000.zip
Downloaded. 
Checking  20135nd0049000.zip ... Downloaded. 
Checking  20135nd0104000.zip ... Downloaded. 
Checking  20135oh0002000.zip ... Downloaded. 
Checking  20135oh0005000.zip ... Downloaded. 
Checking  20135oh0043000.zip ... Downloaded. 
Checking  20135oh0044000.zip ... Downloaded. 
Checking  20135oh0049000.zip ... Downloaded. 
Checking  20135oh0104000.zip ... Downloaded. 
Checking  20135ok0002000.zip ... Downloaded. 
Checking  20135ok0005000.zip ... Downloaded. 
Checking  20135ok0043000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ok0043000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ok0043000.zip
Downloaded. 
Checking  20135ok0044000.zip ... Downloaded. 
Checking  20135ok0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ok0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ok0049000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ok0049000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ok0049000.zip
Downloaded. 
Checking  20135ok0104000.zip ... Downloaded. 
Checking  20135or0002000.zip ... Downloaded. 
Checking  20135or0005000.zip ... Downloaded. 
Checking  20135or0043000.zip ... Downloaded. 
Checking  20135or0044000.zip ... Downloaded. 
Checking  20135or0049000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125or0049000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135or0049000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125or0049000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135or0049000.zip
Downloaded. 
Checking  20135or0104000.zip ... Downloaded. 
Checking  20135pa0002000.zip ... Downloaded. 
Checking  20135pa0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125pa0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135pa0005000.zip
Downloaded. 
Checking  20135pa0043000.zip ... Downloaded. 
Checking  20135pa0044000.zip ... Downloaded. 
Checking  20135pa0049000.zip ... Downloaded. 
Checking  20135pa0104000.zip ... Downloaded. 
Checking  20135ri0002000.zip ... Downloaded. 
Checking  20135ri0005000.zip ... Downloaded. 
Checking  20135ri0043000.zip ... Downloaded. 
Checking  20135ri0044000.zip ... Downloaded. 
Checking  20135ri0049000.zip ... Downloaded. 
Checking  20135ri0104000.zip ... Downloaded. 
Checking  20135sc0002000.zip ... Downloaded. 
Checking  20135sc0005000.zip ... Downloaded. 
Checking  20135sc0043000.zip ... Downloaded. 
Checking  20135sc0044000.zip ... Downloaded. 
Checking  20135sc0049000.zip ... Downloaded. 
Checking  20135sc0104000.zip ... Downloaded. 
Checking  20135sd0002000.zip ... Downloaded. 
Checking  20135sd0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125sd0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135sd0005000.zip
Downloaded. 
Checking  20135sd0043000.zip ... Downloaded. 
Checking  20135sd0044000.zip ... Downloaded. 
Checking  20135sd0049000.zip ... Downloaded. 
Checking  20135sd0104000.zip ... Downloaded. 
Checking  20135tn0002000.zip ... Downloaded. 
Checking  20135tn0005000.zip ... Downloaded. 
Checking  20135tn0043000.zip ... Downloaded. 
Checking  20135tn0044000.zip ... Downloaded. 
Checking  20135tn0049000.zip ... Downloaded. 
Checking  20135tn0104000.zip ... Downloaded. 
Checking  20135tx0002000.zip ... Downloaded. 
Checking  20135tx0005000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125tx0005000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135tx0005000.zip
Downloaded. 
Checking  20135tx0043000.zip ... Downloaded. 
Checking  20135tx0044000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125tx0044000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135tx0044000.zip
Downloaded. 
Checking  20135tx0049000.zip ... Downloaded. 
Checking  20135tx0104000.zip ... Downloaded. 
Checking  20135ut0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125ut0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135ut0002000.zip
Downloaded. 
Checking  20135ut0005000.zip ... Downloaded. 
Checking  20135ut0043000.zip ... Downloaded. 
Checking  20135ut0044000.zip ... Downloaded. 
Checking  20135ut0049000.zip ... Downloaded. 
Checking  20135ut0104000.zip ... Downloaded. 
Checking  20135vt0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125vt0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135vt0002000.zip
Attempt # 3  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125vt0002000.zip on attempt  2  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135vt0002000.zip
Attempt # 4  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125vt0002000.zip on attempt  3  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135vt0002000.zip
Attempt # 5  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125vt0002000.zip on attempt  4  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135vt0002000.zip
Attempt # 6  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125vt0002000.zip on attempt  5  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135vt0002000.zip

*** Failed to obtain file after repeated attempts. May need to download manually. ***
========================================
Checking  20135vt0005000.zip ... Downloaded. 
Checking  20135vt0043000.zip ... Downloaded. 
Checking  20135vt0044000.zip ... Downloaded. 
Checking  20135vt0049000.zip ... Downloaded. 
Checking  20135vt0104000.zip ... Downloaded. 
Checking  20135va0002000.zip ... Downloaded. 
Checking  20135va0005000.zip ... Downloaded. 
Checking  20135va0043000.zip ... Downloaded. 
Checking  20135va0044000.zip ... Downloaded. 
Checking  20135va0049000.zip ... Downloaded. 
Checking  20135va0104000.zip ... Downloaded. 
Checking  20135wa0002000.zip ... Downloaded. 
Checking  20135wa0005000.zip ... Downloaded. 
Checking  20135wa0043000.zip ... Downloaded. 
Checking  20135wa0044000.zip ... Downloaded. 
Checking  20135wa0049000.zip ... Downloaded. 
Checking  20135wa0104000.zip ... Downloaded. 
Checking  20135wv0002000.zip ... Downloaded. 
Checking  20135wv0005000.zip ... Downloaded. 
Checking  20135wv0043000.zip ... Downloaded. 
Checking  20135wv0044000.zip ... Downloaded. 
Checking  20135wv0049000.zip ... Downloaded. 
Checking  20135wv0104000.zip ... Downloaded. 
Checking  20135wi0002000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125wi0002000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135wi0002000.zip
Downloaded. 
Checking  20135wi0005000.zip ... Downloaded. 
Checking  20135wi0043000.zip ... Downloaded. 
Checking  20135wi0044000.zip ... Downloaded. 
Checking  20135wi0049000.zip ... Downloaded. 
Checking  20135wi0104000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125wi0104000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135wi0104000.zip
Downloaded. 
Checking  20135wy0002000.zip ... Downloaded. 
Checking  20135wy0005000.zip ... Downloaded. 
Checking  20135wy0043000.zip ... Downloaded. 
Checking  20135wy0044000.zip ... Downloaded. 
Checking  20135wy0049000.zip ... Downloaded. 
Checking  20135wy0104000.zip ... Attempt # 2  because unable to download data file /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20125wy0104000.zip on attempt  1  ... 
Warning: File size zero for /Users/markcorrales/Documents/R PACKAGES/ACSdownload/acsdata/20135wy0104000.zip
Downloaded. 
Checking  20135pr0002000.zip ... Downloaded. 
Checking  20135pr0005000.zip ... Downloaded. 
Checking  20135pr0043000.zip ... Downloaded. 
Checking  20135pr0044000.zip ... Downloaded. 
Checking  20135pr0049000.zip ... Downloaded. 
Checking  20135pr0104000.zip ... Downloaded. 

 2015-07-17 23:14:37  Finished downloading data files... 
2015-07-17 23:14:37  Started unzipping data files... 
Retrying download of zip file since bad/missing contents after unzip attempts.
Checking  20135vt0002000.zip ... Warning: File size zero (deleting file now) for 20135vt0002000.zip
Downloaded. 
Checking  20135vt0005000.zip ... Checking  20135vt0043000.zip ... Checking  20135vt0044000.zip ... Checking  20135vt0049000.zip ... Checking  20135vt0104000.zip ... 2015-07-17 23:15:19  Finished unzipping data files... 
2015-07-17 23:15:19  Started reading/assembling all data files... 

Now working on sequence file  0002  ----
---- Now working on table  B01001  ----
2015-07-17 23:15:19 Estimates files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
2015-07-17 23:16:16 Margin of Error files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
  Saved as file (tracts / block groups but no geo info):  ACS-20135-B01001.RData 
--------------------------

Now working on sequence file  0005  ----
---- Now working on table  B03002  ----
2015-07-17 23:17:21 Estimates files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
2015-07-17 23:17:39 Margin of Error files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
  Saved as file (tracts / block groups but no geo info):  ACS-20135-B03002.RData 
--------------------------

Now working on sequence file  0043  ----
---- Now working on table  B15002  ----
2015-07-17 23:18:05 Estimates files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
2015-07-17 23:18:42 Margin of Error files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
  Saved as file (tracts / block groups but no geo info):  ACS-20135-B15002.RData 
--------------------------

Now working on sequence file  0044  ----
---- Now working on table  B16002  ----
2015-07-17 23:19:31 Estimates files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
2015-07-17 23:19:51 Margin of Error files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
  Saved as file (tracts / block groups but no geo info):  ACS-20135-B16002.RData 
--------------------------

Now working on sequence file  0049  ----
---- Now working on table  C17002  ----
2015-07-17 23:20:15 Estimates files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
2015-07-17 23:20:33 Margin of Error files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
  Saved as file (tracts / block groups but no geo info):  ACS-20135-C17002.RData 
--------------------------

Now working on sequence file  0104  ----
---- Now working on table  B25034  ----
2015-07-17 23:20:56 Estimates files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
2015-07-17 23:21:23 Margin of Error files -- Appending States:  
AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY PR 
  Saved as file (tracts / block groups but no geo info):  ACS-20135-B25034.RData 
--------------------------
----------------------------------------------------
2015-07-17 23:21:55  Finished reading data 
2015-07-17 23:21:55  Started joining geo to data tables 
2015-07-17 23:23:23  Finished joining geo to data tables 
2015-07-17 23:23:23  Checked block groups and tracts, retained both
2015-07-17 23:23:23  Re-ordered estimates and margin of error columns 
2015-07-17 23:23:31  Merged all tables into one big table 
2015-07-17 23:24:03  Saved merged tables 
2015-07-17 23:24:06  Split data into block groups dataset and tracts dataset 
TRACTS count: 74001 74001
BLOCK GROUPS count: 220333 220333
2015-07-17 23:24:38  Saved block group file and tracts file as .RData 
2015-07-17 23:24:38  Saved longnames, etc fieldnames as csv file. 
2015-07-17 23:24:38 

TOTAL ELAPSED WAS 45 MINUTES
2015-07-17 22:40:07  Started scripts to download and parse ACS data

################ DONE ############## 

There were 50 or more warnings (use warnings() to see the first 50)
> warnings()
Warning messages:
1: In unzip(zipfile = file.path(folder, zipfile(state.abbrev,  ... :
  error 1 in extracting from zip file
2: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
3: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
4: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
5: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
6: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
7: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
8: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
9: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
10: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
11: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
12: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
13: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
14: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
15: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
16: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
17: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
18: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
19: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
20: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
21: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
22: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
23: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
24: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
25: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
26: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
27: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
28: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
29: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
30: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
31: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
32: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
33: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
34: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
35: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
36: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
37: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
38: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
39: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
40: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
41: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
42: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
43: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
44: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
45: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
46: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
47: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
48: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
49: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139
50: In read.table(file = file, header = header, sep = sep,  ... :
  cols = 121 != length(data) = 139