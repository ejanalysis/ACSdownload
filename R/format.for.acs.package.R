######################################
#	R CODE TO OBTAIN AND WORK WITH CENSUS BUREAU'S AMERICAN COMMUNITY SURVEY (ACS) 5-YEAR SUMMARY FILE DATA
#	2013-12-12
######################################

###################################
#	FUNCTION TO CREATE FILE FOR IMPORT TO acs PACKAGE
#	BY USING SAME FORMAT FOR CSV AS THE AMERICAN FACT FINDER PROVIDES FOR TRACTS DOWNLOADS
###################################

################################################################################
# Downloading C17002 from American Fact Finder results in a zip file with csv as follows:
# ACS_12_5YR_C17002_with_ann.csv  is the data file with estimates and MOE values
# First row is header with field names. Other rows are tract data. 
# Note that the fields are:
# GEOID, FIPS, NAME, e1, m1, e2, m2, etc.
# Columns 1,2,3 are geo information. Columns 4+ are data (estimate,moe,estimate,moe, etc.)
# First 2 rows example:
#GEO.id,GEO.id2,GEO.display-label,HD01_VD01,HD02_VD01,HD01_VD02,HD02_VD02,HD01_VD03,HD02_VD03,HD01_VD04,HD02_VD04,HD01_VD05,HD02_VD05,HD01_VD06,HD02_VD06,HD01_VD07,HD02_VD07,HD01_VD08,HD02_VD08
#0800000US110015000050000000501,110015000050000000501,"Census Tract 5.01, Washington city, Washington city, District of Columbia, District of Columbia",3113,296,232,164,50,47,77,84,82,90,199,122,19,29,2454,312
#
# ACS_12_5YR_C17002_metadata.csv  has the long and short variable names. 
# There is no header row. A header of field names would be these 2: "short.name", "long.name"
# Each row here corresponds to one column of the data/moe fields (after the geo fields) in the main data file.
# First few rows example:
#GEO.id,Id
#GEO.id2,Id2
#GEO.display-label,Geography
#HD01_VD01,Estimate; Total:
#HD02_VD01,Margin of Error; Total:
#HD01_VD02,Estimate; Total: - Under .50
#HD02_VD02,Margin of Error; Total: - Under .50
#
# JUST TRACTS are available from Fact Finder so that is what acs package would typically import
################################################################################

# this calls the function below
# 
# for (this.tab in names(alltab)) {
#   acs.this.tab <- format.for.acs.package(alltab[[this.tab]])
#   # head(format.for.acs.package(alltab[[2]]))
#   if (writefiles) {
#     filename <- paste("ACS_", substr(end.year, 3, 4), "_5YR_", this.tab, "_with_ann.csv", sep="") 
#     write.csv(acs.this.tab[ acs.this.tab$SUMLEVEL=="140"], row.names=FALSE, file=filename)
#   }
#   if (writefiles) {
#     cat(as.character(Sys.time()), ' '); cat('Saved tracts files formatted for use in the acs package ')
#   }
# }


#########
#	DEFINE FUNCTION TO FORMAT FOR ACS PACKAGE
#	ESTIMATE, MOE, ESTIMATE, MOE
#	AND KEY COLS ARE GEOID, FIPS, AND NAME, 
#	but also keeps  SUMLEVEL 
#	drops STUSAB
#
#	AND will ONLY SAVES TRACTS , DROP BLOCK GROUPS later when saving file for acs
##########

format.for.acs.package <- function(this.tab, endyear="2012") {

	filename <- paste("ACS_", substr(endyear, 3, 4), "_5YR_", this.tab, "_with_ann.csv", sep="") 
	df <- this.tab

	keycols <- c("KEY", "SUMLEVEL", "GEOID", "FIPS", "STUSAB")
	data.colnames <- names(df)[!(names(df) %in% keycols)]

	# Start with table that has all estimates together, followed by all MOEs, 
	# and create a new sort order so that estimates will be interspersed with (next to) their MOE values, as FactFinder format provides.

	est.moe.order <- c(0,length(data.colnames)/2) + rep(1:(length(data.colnames)/2),each=2)
	data.colnames.ordered <- data.colnames[ est.moe.order]
	df$NAME <- "NA" # this was not downloaded and retained due to encoding problems on OS X
	df <- df[ , c("GEOID", "FIPS", "NAME", "SUMLEVEL", data.colnames.ordered)]

	print(filename)
	print( names(df) ); print("-------------------")
	return(df)
	#rm(df, data.colnames, data.colnames.ordered, est.moe.order, filename)
}

#########################

