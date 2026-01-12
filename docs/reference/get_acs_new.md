# newer way to get full USA ACS data by table and fips get the ACS 5year data for selected tables and fips or fipstype

newer way to get full USA ACS data by table and fips get the ACS 5year
data for selected tables and fips or fipstype

## Usage

``` r
get_acs_new(
  tables = ejscreen_acs_tables,
  fips = "blockgroup",
  yr = acsdefaultendyearhere,
  fiveorone = "5",
  return_list_not_merged = TRUE
)
```

## Arguments

- tables:

  vector of ACS data table numbers like "B01001" etc. Note some tables
  used by EJSCREEN are only available at tract resolution, namely
  "C16001" for detailed specific languages as % of residents, and
  "B18101" for % with disability. All resolutions get returned if
  return_list_not_merged=TRUE, but not if FALSE, since those tables
  would prevent clearcut merging to a single table of places based on
  fips.

- fips:

  "blockgroups" for all US bg, or a vector of fips codes. can also be
  "county", "state", "tract", or vector of one of those fips code types.
  May support these but untested: "REGION", "American Indian Area/Alaska
  Native Area/Hawaiian Home Land", "MSA", "CSA", "Urban Area",
  "Congressional District", "ZCTA". If a fips type (e.g., "tract"),
  defines the SUMLEVEL variable in the ACS data (e.g., "140").

- yr:

  end year of 5 year ACS summary file data, such as 2023 for the
  2019-2023 survey released by Census Bureau Dec. 2024.

- fiveorone:

  optional 1 or 5, where 5 is the 5-year sample - only 5-yr tested here

- return_list_not_merged:

  set to FALSE means return a single merged table from all the requested
  ACS tables, and otherwise a list of data.tables. See "tables"
  parameter for more.

## Value

list of tables or merged single table, with estimates and margins of
error and fips and SUMLEVEL

## Examples

``` r
 x = get_acs_new(yr=2022, tables = ejscreen_acs_tables[1],
   fips="county")
 x[[1]]

 # acs22 = get_acs_new(yr=2022, tables = ejscreen_acs_tables )
 # acs23 = get_acs_new(yr = 2023, return_list_not_merged = FALSE)

 if (FALSE) { # \dontrun{
   ##### EXAMPLE OF GETTING ACS DATA
   ##### FOR ALL US BLOCKGROUPS AND CALCULATING INDICATORS

   ### See more complete code for this in the EJAM package!
   ## -- below is just a very simplified look:

   library(EJAM)
   library(data.table)

   # x <- get_acs_new() # has problem where not all tables have same number of rows
   # even for the blockgroup ones, and last 2 tables are tract resolution
   ## so this is easier for getting the bg part:

   bg     <- get_acs_new(tables = ejscreen_acs_tables[1:13], return_list_not_merged = FALSE)

   acsdata <- list()
   acsdata <- EJAM::calc_ejam(
     bg,
     formulas = EJAM::formulas_ejscreen_acs$formula,
         keep.old = c("fips", "pop")
   )
   data.table::setnames(acsdata, "fips", "bgfips")

   #  dput(setdiff(names(acsdata) , names(blockgroupstats)) )

   keep <- intersect(names(acsdata), names(EJAM::blockgroupstats))
   acsdata <- acsdata[ , .SD, .SDcols = keep]

   t(acsdata[1:2,])

   # save(acsdata, file = "~/Downloads/acs2023 bg via just ACSdownload pkg example.rda")
 } # }
```
