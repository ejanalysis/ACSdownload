#' @title Reformat ACS Data from \code{\link{get.acs}} for the acs Package
#' @description  Work in progress ***** \cr\cr
#'  FUNCTION TO CREATE FILE FOR IMPORT TO acs PACKAGE 
#'  USING SAME FORMAT FOR CSV AS THE AMERICAN FACT FINDER PROVIDES FOR TRACTS DOWNLOADS
#'  format is ESTIMATE, MOE, ESTIMATE, MOE... and KEY COLS ARE GEOID, FIPS, AND NAME, 
#'	but also keeps  SUMLEVEL 
#'	and drops STUSAB
#' @details 
#' Downloading C17002 from American Fact Finder results in a zip file with csv as follows:\cr
#' ACS_12_5YR_C17002_with_ann.csv  is the data file with estimates and MOE values\cr
#' First row is header with field names. Other rows are tract data. \cr
#' Note that the fields are:\cr
#' GEOID, FIPS, NAME, e1, m1, e2, m2, etc.\cr
#' Columns 1,2,3 are geo information. Columns 4+ are data (estimate,moe,estimate,moe, etc.)\cr
#' First 2 rows example:\cr
#'  GEO.id,GEO.id2,GEO.display-label,HD01_VD01,HD02_VD01,HD01_VD02,HD02_VD02,HD01_VD03,HD02_VD03,HD01_VD04,HD02_VD04,HD01_VD05,HD02_VD05,HD01_VD06,HD02_VD06,HD01_VD07,HD02_VD07,HD01_VD08,HD02_VD08\cr
#'  0800000US110015000050000000501,110015000050000000501,"Census Tract 5.01, Washington city, Washington city, District of Columbia, District of Columbia",3113,296,232,164,50,47,77,84,82,90,199,122,19,29,2454,312\cr
#'  \cr
#' ACS_12_5YR_C17002_metadata.csv  has the long and short variable names. \cr
#' There is no header row. A header of field names would be these 2: "short.name", "long.name"\cr
#' Each row here corresponds to one column of the data/moe fields (after the geo fields) in the main data file.\cr
#' First few rows example:\cr
#'  GEO.id,Id\cr
#'  GEO.id2,Id2\cr
#'  GEO.display-label,Geography\cr
#'  HD01_VD01,Estimate; Total:\cr
#'  HD02_VD01,Margin of Error; Total:\cr
#'  HD01_VD02,Estimate; Total: - Under .50\cr
#'  HD02_VD02,Margin of Error; Total: - Under .50\cr
#'  \cr
#' JUST TRACTS were available from Fact Finder up to 2008-2012 ACS, so that is what acs package would typically import until recently.\cr
#' Actually starting with 2009-2013 ACS, block groups will be available via AFF, but only by specifying one (or each) county in a State.\cr
#'  ###############################################################################\cr
#'  \cr
#' @param this.tab Required list of tables from earlier steps in \code{\link{get.acs}}
#' @param end.year Optional, character, default is '2012' 
#' @return Data.frame for use in \pkg{acs} package.
#' @seealso \code{\link{get.acs}} 
#' @export
format.for.acs.package <- function(this.tab, end.year="2012") {

	filename <- paste("ACS_", substr(end.year, 3, 4), "_5YR_", this.tab, "_with_ann.csv", sep="") 
	df <- this.tab

	keycols <- c("KEY", "SUMLEVEL", "GEOID", "FIPS", "STUSAB")
	data.colnames <- names(df)[!(names(df) %in% keycols)]
	df$NAME <- "NA" #' this was not downloaded and retained due to encoding problems on OS X
	
	# If started with table that has all estimates together, followed by all MOEs, 
	# need to create a new sort order so that estimates will be interspersed with (next to) their MOE values, as FactFinder format provides.
	# But may already have that format now??, and could use intersperse() if dont'
	#   est.moe.order <- c(0, length(data.colnames) / 2) + rep(1:(length(data.colnames) / 2), each=2)
	#   data.colnames.ordered <- data.colnames[ est.moe.order ]
	#   df <- df[ , c("GEOID", "FIPS", "NAME", "SUMLEVEL", data.colnames.ordered)]
	# 
	df <- df[ , c("GEOID", "FIPS", "NAME", "SUMLEVEL", data.colnames)]
  # 
	
	cat(filename, '\n')
	cat( names(df) , '\n'); 
	cat("-------------------\n")
	
	# save csv here????
	
	
	return(df)
}
