######################################
#	R CODE TO OBTAIN AND WORK WITH CENSUS BUREAU'S AMERICAN COMMUNITY SURVEY (ACS) 5-YEAR SUMMARY FILE DATA
#	2013-12-12
######################################

#################################
#	FUNCTION TO split tracts and block groups into 2 files based on SUMLEVEL code 140 or 150
#################################

get.tracts <- function(merged.tables.mine) {
	return(merged.tables.mine[merged.tables.mine$SUMLEVEL=="140" , ])
	#rm(merged.tables.mine)
}

get.bg <- function(merged.tables.mine) {
	return(merged.tables.mine[merged.tables.mine$SUMLEVEL=="150" , ])
	#rm(merged.tables.mine)
}
