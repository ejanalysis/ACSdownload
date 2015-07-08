############################################################
#LIST OF WAYS TO GET ACS, CENSUS, OR A COUNTY REPORT USING R
############################################################
#
##############################################
#WAYS TO GET ACS DATA (SUMMARY FILE TABLES) FOR ANALYSIS IN R
##############################################
#
#***via Census FTP site
#  # * Provides immediate -- and fully automated -- access to block group and tract data for entire US, for multiple tables.
#  # x- Not for US/State/County data, just tract and block group. Significant extra work to code for US/State/County totals (different URLs and formats).
#  # x- Lacks friendly interface to help browse and select tables and variables.
#  # x- Code may be less robust to various tables, years, etc. Not for Census 2010 as written now (just ACS).
#  # Then could convert to acs package format if desired.
#  # Also could use Excel tools on Census FTP site to obtain small subsets of block group or tract data.
#  CODE: ACSdownload package
#
#**via NHGIS.ORG
#  # * Can obtain US, State, and County totals, not just tract/block group.
#  # * Easy selection of tables by browsing interface.
#  # * Also provides Census 2010 and other datasets.
#  # x- Requires manual login to account on NHGIS.org and download of dataset once ready (can be minutes to >1 hour). Not automated.
#  # x- Lag of approx. 6 weeks after Census releases ACS data: "We aim to add data from each new ACS release within six weeks of the Census Bureau release date."
#  # The 2008-2012 ACS came out from Census 12/12-12/17/2013, and was on the NHGIS.org site by February 17, 2014. Lag was just 2 months.
#  # Then could convert to acs package format if desired.
#  CODE: ...R analysis\ACS - download and parse\CODE FOR ACS VIA NHGIS\IMPORT ACS FROM NHGIS FILE.R
#
#*via Census API and acs package
#  # Requires obtaining an individual API Key from Census.
#  # Entire USA may not be practical -- Loop takes ~5 minutes to get all BG in Maryland, 1 table, for example, so maybe 3 hours per table for USA?
#  CODE:  ...R analysis\ACS - download and parse\CODE FOR acs package and API\CODE TO GET ACS IN ALL BG IN ALL COUNTIES VIA API.R
#
#via Census API but WITHOUT acs package:
#  # Hard to parse results without the acs package, so probably not worthwhile. Could check on speed, but likely still slow.
#  # Requires obtaining an individual API Key from Census.
#  CODE: ...R analysis\ACS - download and parse\CODE FOR acs package and API\CODE TO GET ACS DATA VIA API WITHOUT acs package.R
#
#gdb from contractor
#  
#  # Non-public. Significant lag time from ACS release, and not clear which tables will be provided annually.
#  For details, see see ...R analysis\ACS - download and parse\EDG VS GEOPLAT FOR ACS DATA 2012.txt
#
#ESRI DVDs, Geolytics, or other vendors
#  # Commercial, not free to the public. Requires GIS software (e.g., ArcGIS).
#
#via Census prejoined tables at block group resolution
#  # THESE ARE ONE STATE AT A TIME - EACH STATE GDB MUST BE DOWNLOADED MANUALLY (can't be automated easily).
#  # Only a few selected tables are provided: KEY TABLES AVAILABLE:
#    #B01001  Sex By Age  
#    #B03002  Hispanic Or Latino Origin By Race  
#    #B15002  Sex By Educational Attainment For The Population 25 Years And Over  
#    #B16002 IS NOT HERE   #[has B16004  Age By Language Spoken At Home By Ability To Speak English For The Population 5 Years And Over  ]
#    #B17002 IS NOT HERE   #[has B17021  Poverty Status Of Individuals In The Past 12 Months By Living Arrangement  ]
#    #B25034  Year Structure Built  
#  # Lag-time: As of 1/2/2014, the 2012 5yr file is not yet here in gdb format.
#  #  These geodatabases join the block group geography from the TIGER/Line Shapefiles 
#  #to the 2007-2011 American Community Survey 5-year estimates for 70 tables. 
#  # A limited set of TIGER/Line Shapefiles are available pre-joined with demographic data in geodatabase and shapefile format. 
#  # We are working on an on-line tool that will allow you to access selected data from the 2010 Census and American Community Survey (ACS) 
#  # for custom geographic areas (conforming to blocks for the 2010 Census and block groups or census tract boundaries for the ACS). 
#  # We do not have plans to continue to create shapefiles and/or geodatabases pre-joined with demographic data as a regular product 
#  # because of the large volume of data available and the many varying needs of customers.
#  http://www.census.gov/geo/maps-data/data/tiger-data.html
#
#via DATA FERRETT - CANNOT GET ALL BLOCK GROUPS AT ONCE, BUT CAN GET ALL US TRACTS AT ONCE.
#  # Data Ferrett won't support download of all block groups in the USA at once, even for a single table:
#  # "We're sorry, the system only supports downloading 74100 geographies from this dataset. 
#  # You have selected 220333 geographies. 
#  # You will need to go back and reduce the number of geographies."
#
#via acs package by reading downloads of AFF data (which can be tract level, but not all tracts nationwide at once):
#  #  ** cannot be used to obtain even all tracts in the US at once, but probably could get all tracts in one Region.
#  # (no code written, but might use FTP code to save BG and other data in acs package's format, and not need limited AFF site anyway)
#  # See example in "Spatial Demography 2013 1(1): 132-139." Shows how to use acs package to read aff downloaded csv file & graph counties.
#
#via AMERICAN FACT FINDER (AFF) - CANNOT GET ALL TRACTS AT ONCE, AND CANNOT GET BLOCK GROUPS.
#  #  ** cannot be used to obtain even all tracts in the US at once, but probably could get all tracts in one Region.
#  #  American FactFinder: What are the limits for downloading tables?
#  #  Download from Search Results (without viewing table):
#  #  Up to 10 tables at one time
#  #  Up to 50,000 geographies for a table
#  #  Up to 500,000 rows of data
#  #  Note:
#  #  The sum of all cities or towns in the USA is less than 50,000 geographies.
#  #  For downloads larger than 50,000 geographies or 500,000 rows, please use the ftp site.
#  #  To download a table for only one geography or population group at a time, such as the Data Profiles, you can calculate the total number of rows in that table by multiplying the number of geographies or population groups by the number of rows in the table.  
#  #  For example, a table that has ten rows and ten geographies is equivalent to 100 total rows.
#  https://ask.census.gov/faq.php?id=5000&faqId=1653
#
############################################
##	OTHER
############################################
#
#A useful summary page: 
#  Tallies, lists of geo names, etc.
#  http://www.census.gov/geo/maps-data/
#
#TO GET URL OF COUNTY OR STATE OR USA SUMMARY TABLE OF STATS, FOR GIVEN FIPS:
#  CODE:  ...R analysis\ACS and CENSUS API LINKING\url.qf.R
#
#TO GET URL OF SINGLE TABLE FROM AMERICAN FACT FINDER
#  # see URL schemes examples:
#  ...R analysis\ACS - download and parse\CODE FOR URL OF 1 AFF TABLE
#
#TO GET A SINGLE STATISTIC FROM THE CENSUS API
#  # see URL schemes examples:
#  ...R analysis\ACS - download and parse\CODE FOR acs package and API
