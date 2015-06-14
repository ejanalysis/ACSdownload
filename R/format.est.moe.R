######################################
#	R CODE TO OBTAIN AND WORK WITH CENSUS BUREAU'S AMERICAN COMMUNITY SURVEY (ACS) 5-YEAR SUMMARY FILE DATA
#	2013-12-12
######################################

#################################
#	FUNCTION TO REORDER COLUMNS AS KEYCOLS, THEN EST, MOE, EST, MOE, ETC.
#################################

format.est.moe <- function(my.list.of.tables) {

	for (i in 1:length(my.list.of.tables)) {
		df <- my.list.of.tables[[i]]
		keycols <- c("KEY", "SUMLEVEL", "GEOID", "FIPS", "STUSAB")
		data.colnames <- names(df)[!(names(df) %in% keycols)]
	
		# Start with table that has all estimates together, followed by all MOEs, 
		# and create a new sort order so that estimates will be interspersed with (next to) their MOE values, as FactFinder format provides.
	
		est.moe.order <- c(0, length(data.colnames) / 2) + rep(1:(length(data.colnames) / 2), each=2)
		data.colnames.ordered <- data.colnames[ est.moe.order]
		my.list.of.tables[[i]] <- df[ , c(keycols, data.colnames.ordered)]
	}
	return(my.list.of.tables)
}
