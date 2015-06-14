######################################
#	R CODE TO OBTAIN AND WORK WITH CENSUS BUREAU'S AMERICAN COMMUNITY SURVEY (ACS) 5-YEAR SUMMARY FILE DATA
#	2013-12-12
######################################

##################################################################
#  3. MERGE/JOIN GEO TO DATA FILES
##################################################################

join.geo.to.tablist <- function(mygeo, my.list.of.tables, save.csv=FALSE, sumlevel='both') {

#################################
#	FUNCTION TO join (merge) US data and US geo files on FIPS
#################################

# Do geo join for one seqfile at a time, or actually one table at a time.
# That is somewhat inefficient because geo merge has to be done repeatedly instead of once.
# But it may be useful to have one file per table.

	for(i in 1:length(my.list.of.tables)) {
	
                if (testing) {
                print('length of my.list.of.tables'); print(length(my.list.of.tables))		
                print('structure of it'); print(str(my.list.of.tables))
                print('structure of mygeo'); print(str(mygeo))
                }

		bigtable <- my.list.of.tables[[i]]	

		# remove the redundant columns
		bigtable <- bigtable[ , !(names(bigtable) %in% c("STUSAB", "SEQUENCE", "LOGRECNO") )]

		# NOTE - This is very slow as written, and takes too much RAM, so it can fail. Can take 5 minutes on a slow machine.
		# plyr::join is much faster than merge (& data.table merge is faster also) according to 
		# http://stackoverflow.com/questions/1299871/how-to-join-data-frames-in-r-inner-outer-left-right/1300618#1300618 

		my.list.of.tables[[i]] <- merge( mygeo, bigtable, by.x="KEY", by.y="KEY")
		
		# DROP ROWS WE DON'T NEED, IF ANY
		if (sumlevel=='tracts') {my.list.of.tables[[i]] <- subset(my.list.of.tables[[i]], my.list.of.tables[[i]]$SUMLEVEL=='140') }
		if (sumlevel=='bg')     {my.list.of.tables[[i]] <- subset(my.list.of.tables[[i]], my.list.of.tables[[i]]$SUMLEVEL=='150') }
		

		# MIGHT WANT TO DO ERROR CHECKING HERE FOR LENGTH & HOW MANY FAIL TO MATCH	

		rm(bigtable)
		if (save.csv) {
			this.tab <- names(my.list.of.tables)[i]
			write.csv(my.list.of.tables[[i]], file=paste("ACS", datafile.prefix, "-", this.tab, ".csv", sep=""), row.names=FALSE)
			# save(bigtable, file=paste("ACS", datafile.prefix, "-", this.tab, ".RData", sep=""))
		}
	}
	return(my.list.of.tables)
}

