######################################
#	R CODE TO OBTAIN AND WORK WITH CENSUS BUREAU'S AMERICAN COMMUNITY SURVEY (ACS) 5-YEAR SUMMARY FILE DATA
#	2013-12-12
######################################


##################################################################
#	FUNCTION TO 
#	create names of individual data files extracted from the zip files 
#	(based on 2-letter state abbreviations, years needed, and seq file #s )
#	but note some sequence files might have >1 table in the sequence file, so must loop through tables not seqfiles to get start points right.
#
#	read and concatenate state data files into one data frame or file
##################################################################

################################################################################################
#	FUNCTION TO READ UNZIPPED CSV FILES OF ESTIMATES AND MOE, AND COMBINE THEM ACROSS STATES
#	ONE CENSUS TABLE AT A TIME
################################################################################################

read.concat.states <- function(tables.mine, states.abbreviated.mine=stateabbs, save.files=TRUE, sumlevel='both') {

# REQUIRES THESE TO BE IN MEMORY:
# needed (the table of which variables/tables/seqfiles are needed)- tables.mine specifies tables but needed specifies variables in those
# lookup.acs (the table of all ACS variables/tables/seqfiles and which columns of seqfile and table have each)
# stateabbs  (so the default will work, a vector of 2letter state abbreviations for the US)
# which.seqfiles()  function finds seqfiles that contain a give table
# lead.zeroes()  function adds leading zeroes to a sequence file number etc.
# datafile()  function to get name of datafile containing a given state-sequencefile combination

  if (testing) { cat(as.character(Sys.time()), "Started concatenating states.\n")}

  # e.g. tables.mine <- c("C17002", "B01001")
  seqfilelistnums.mine <- which.seqfiles(tables.mine)
  #e.g. # seqfilelistnums.mine <- "0044"; states.abbreviated.mine <- "dc"
  #e.g. # seqfilelistnums.mine <- c("0044"); states.abbreviated.mine <- c("de", "dc")
  seqfilelistnums.mine <- lead.zeroes(seqfilelistnums.mine, 4)
  
  alltables <- list()
  gc()

  # These are the basic 6 columns that start every data file:
  keycols <- c("FILEID", "FILETYPE", "STUSAB", "CHARITER", "SEQUENCE", "LOGRECNO")
  count.keycols <- length(keycols)
  # ACSSF,2012m5,wy,000,0104,0000900, ...
  needed.keycols <- c("STUSAB", "LOGRECNO")
  # dropcols <- c("FILEID", "FILETYPE", "CHARITER")
  #colnums.needed.keycols <- which(keycols %in% needed.keycols)
  count.needed.keycols <- length(needed.keycols)
  colnums.drop.keycols <- which(!(keycols %in% needed.keycols))

  # to find data file length, need state abbrev's list
  states.abbreviated.mine.no.us <- states.abbreviated.mine[states.abbreviated.mine!="us"]
  states.num.places <- as.data.frame(table(geo$STUSAB[geo$STUSAB %in% toupper(states.abbreviated.mine.no.us)]))
  names(states.num.places) <- c("STUSAB", "count")

  #	LOOP THROUGH THE SEQUENCE FILES ************************

  for (this.seq in seqfilelistnums.mine) {

	cat("\nNow working on sequence file ", this.seq, " ----\n")
	# e.g. # this.seq <- "0044" 

	efiles.not.us <- datafile(states.abbreviated.mine.no.us, this.seq)
	mfiles.not.us <- gsub("^e", "m", efiles.not.us)
	if (testing) { print(""); cat("\nProcessing sequence file: "); cat(this.seq); cat("\n"); cat("Looking for this type of file: \n"); print(head(cbind(efiles.not.us, mfiles.not.us))) }

	#	datafile name examples:
	#	e20105de0017000.txt
	#	m20105de0017000.txt
	#####################################

	# assume every state has same number of columns to the given csv sequence file of estimates or moe
	cols.in.csv <- length(read.csv(efiles.not.us[1], nrows=1, header=FALSE))

	#  LOOP THROUGH THE (specified) tables IN THIS SEQ FILE (TO GET COLUMNS RIGHT) ######################
	# ( just the specified ones in the variable  "tables.mine" passed to this function ) *****
	# BUT NOTE THAT tables AND needed MIGHT DISAGREE! so use lookup not needed to see if in this.seq
	mytables.in.this.seq <- unique(lookup.acs$Table.ID[as.numeric(lookup.acs$Sequence.Number)==as.numeric(this.seq)])
	mytables.in.this.seq <- mytables.in.this.seq[mytables.in.this.seq %in% tables.mine]	
		
	for (this.tab in mytables.in.this.seq) {

		cat("---- Now working on table ", this.tab, " ----\n")
		# e.g.  this.tab <- "B16001"

    # Will drop the un-needed columns of data from the data files
		# So must find out which columns in the SEQUENCE FILE are needed for a given table
		# 1st obtain the column numbers of the desired variables in units of 1=the first col in the table, not in the seq file

		datacolnums 	<- needed$colnum[needed$table==this.tab]
		needed.varnames	<- needed$table.var[needed$table==this.tab]  # e.g.,  B17020A.001
		count.datacols <- length(datacolnums)

		# Now convert to units of which column in the sequence file, not within the individual table
		# start at starting point of this table within the sequence file (but retain the key columns like LOGRECNO)
		# NOTE: THIS REQUIRES lookup.acs be in memory !!! ***

		#allcolnums <- 1:cols.in.csv
		start.col <- lookup.acs$Start.Position[lookup.acs$Table.ID==this.tab][1]
		# colnums= which ones we want to obtain now from this sequence file for this table
		colnums <- c( (1:count.keycols), (start.col -1 + datacolnums) )
		# Default is to drop the column via NULL as class, then specify which to keep as number or string, etc.
		my.colClasses <- rep("NULL", cols.in.csv)
		my.colClasses[colnums] <- "numeric" 
		my.colClasses[1:count.keycols] <- "character"
		my.colClasses[colnums.drop.keycols] <- "NULL" 
		
		# *************** Assume numeric for all except key columns like STUSAB, LOGRECNO, etc. **********
		# *************** but MOE files have "." sometimes!! ***********
		# And in many or all cases data are integer, which would be more efficient to store, but how to check that?

		bigtable.e <- data.frame()
		bigtable.m <- data.frame()

		#####################################
		# READ AND CONCATENATE ALL STATES (FOR DATA)
		#####################################
		# (& later merge with nationwide concatenated geo file)


		# LOOP THROUGH STATES (FOR THIS TABLE) (IN THIS SEQUENCE FILE) ######################
		cat(as.character(Sys.time()), "Estimates files -- Appending States:  \n")
		state.num <-0
	
		for (this.file in efiles.not.us) {
			
			# e.g.#  this.file <- "e20125dc0044000.txt"
			# THIS WILL READ THE CSV FILE FOR THIS STATE-SEQFILE COMBO ONCE FOR EACH NEEDED TABLE IT CONTAINS
			# WHICH MAY BE SLOW/INEFFICIENT BUT KEEPS THE CODE A BIT SIMPLER
			# the read.csv is not a bottleneck anyway.

			state.num <- state.num + 1
			this.ST <- toupper(states.abbreviated.mine.no.us[state.num])
			
			rows.here <- states.num.places$count[states.num.places$STUSAB==this.ST]

			######################
			this.data <- read.csv(this.file, stringsAsFactors=FALSE, header=FALSE, 
				comment.char = "",
				nrows=rows.here,
				colClasses=my.colClasses, 
				na.strings=".")
			######################
			
			# this is likely a problem when "." appears instead of a number in the MOE files.
			# since if col class is numeric then na.strings="." may not work.

			# Filter to keep only desired columns by using colClasses set to NULL for those to be dropped

			# Append this state table to the running compilation concatenating all states specified, for this table in the sequence file
			# Note rbind is slow for data frames
		#	if (testing) {
			cat(toupper(this.ST), "")
		#	}
			bigtable.e <- rbind( bigtable.e, this.data)	
			rm(this.data)
		}
		# end of compiling all states for this one table in this one sequence file / data estimates
		cat('\n')

		# LOOP THROUGH STATES (FOR THIS TABLE) (IN THIS SEQUENCE FILE) ######################
		cat(as.character(Sys.time()), "Margin of Error files -- Appending States:  \n")
		state.num <-0

		for (this.file in mfiles.not.us) {

			state.num <- state.num + 1
			this.ST <- toupper(states.abbreviated.mine.no.us[state.num])
			
			rows.here <- states.num.places$count[states.num.places$STUSAB==this.ST]

			######################
			this.data <- read.csv(this.file, stringsAsFactors=FALSE, header=FALSE, 
				comment.char = "",
				nrows=rows.here,
				colClasses=my.colClasses,
				na.strings=".")
			######################

			# this is likely a problem when "." appears instead of a number in the MOE files.
			# since if col class is numeric then na.strings="." may not work.

			# Filter to keep only desired columns by using colClasses set to NULL for those to be dropped
			#this.data <- this.data[ , colnums]

			# Append this state table to the running compilation concatenating all states specified, for this sequence file
			# Note rbind is slow for data frames

			cat(toupper(this.ST), "")
			bigtable.m <- rbind( bigtable.m, this.data)	
			rm(this.data)
		}
		# end of compiling all states for this one table in this one sequence file / MOE files
		cat('\n')


		names(bigtable.e) <- c( needed.keycols, needed.varnames)

		names(bigtable.m) <- c( needed.keycols, needed.varnames)
		 # append .m to each field name to signify MOE margin of error not estimates data
		 # BUT NOT TO THE NON-DATA FIELDS LIKE LOGRECNO !
		 datacolnums.here <- (count.needed.keycols + 1):length(names(bigtable.m))
    if (testing) {print(str(bigtable.m)); cat(' is str of bigtable.m and ',needed.varnames, ' is needed.varnames and datacolnums.here is ', datacolnums.here,'\n'); cat(names(bigtable.m),' is names of bigtable.m \n')}
		 names(bigtable.m)[datacolnums.here] <- paste(names(bigtable.m)[datacolnums.here], ".m",sep="")

		# UNIQUE ID FOR MERGE/JOIN OF GEO TO DATA/MOE WILL BE FORMED FROM COMBINATION OF 
		#  LOGRECNO & STATE FIPS
		# in geo file KEY is created using lower case version of STUSAB.
		# SAME FOR MERGE/JOIN OF DATA TO MOE TABLE.
		# geo has FIPS 
		# Data table lacks FIPS
		
		bigtable.e$KEY <- paste(tolower(bigtable.e$STUSAB), bigtable.e$LOGRECNO, sep="")
		bigtable.m$KEY <- paste(tolower(bigtable.m$STUSAB), bigtable.m$LOGRECNO, sep="")

		# MERGE DATA AND MOE TABLES NOW
		# but drop extra copy of 3 key cols (STUSAB, SEQUENCE, LOGRECNO) from MOE file
		# (Those are not actually essential overall  & could be cut from estimates file also)
		bigtable.m <- bigtable.m[ , c("KEY", names(bigtable.m)[datacolnums.here])]

		if (testing) {cat("\n  Now merging estimates and MOE information...")}

		# NOTE plyr::join is much faster than merge (& data.table merge is faster also) according to 
		# http://stackoverflow.com/questions/1299871/how-to-join-data-frames-in-r-inner-outer-left-right/1300618#1300618 

		if ( all(bigtable.e$KEY==bigtable.m$KEY) ) {bigtable <- data.frame( KEY=bigtable.e$KEY, 
		  bigtable.e[ , names(bigtable.e)!="KEY"], 
		  bigtable.m[ , names(bigtable.m)!="KEY"], stringsAsFactors=FALSE)} else {
			cat("  Warning: Estimates and MOE table rows don't match or are sorted differently!\n")
			bigtable <- merge(bigtable.e, bigtable.m, by="KEY") 
		}
		rm(bigtable.e, bigtable.m)	
		if (testing) {cat(as.character(Sys.time()), "Done merging.\n")}

		if (save.files) { 
			# save each table as a data file
			fname <- paste("ACS-", datafile.prefix, "-", this.tab, ".RData", sep="")
			save(bigtable, file=fname)
			cat(paste("  Saved as file (tracts / block groups but no geo info): ", fname, "\n"))

			#fname <- paste("ACS-", datafile.prefix, "-", this.tab, ".csv", sep="")
			#write.csv(bigtable, file=fname, row.names=FALSE)
			#cat(paste("  Saved as file (tracts / block groups but no geo info): ", fname,"\n"))
		}

	####################	
	# 	MEMORY LIMITATIONS ON WINDOWS MAKE IT HARD TO COMBINE ALL STATES ALL TABLES MOE/ESTIMATES IN ONE LARGE LIST IN MEMORY:
	#  170 MB used for alltables if all states but only 2 short tables read.
	alltables[[this.tab]] <- bigtable
	#alltables <- bigtable
	####################	

		rm(bigtable)
		# ready to work on next table ... save this bigtable as one of several
		gc()
		
		if (testing) {
		#	NOTE THESE DON'T HAVE GEO INFO YET !
		# write.csv WOULD BE A SLOW STEP AND ISN'T ESSENTIAL.
		# could save using save()  as binary instead of csv...
		#	save(bigtable.e, file=paste("ACSe", datafile.prefix, "-", this.tab, ".RData", sep=""))
		#save(bigtable.m, file=paste("ACSm", datafile.prefix, "-", this.tab, ".RData", sep=""))
		#  write.csv(bigtable.e, file=paste("eUS",this.tab,".csv",sep=""), row.names=FALSE)
		#  write.csv(bigtable.m, file=paste("mUS",this.tab,".csv",sep=""), row.names=FALSE)
		}	#end of testing

	} # end of loop over tables	in this seqfile	
	cat("--------------------------\n")

  } # end of loop over sequence files
  cat("----------------------------------------------------\n")

  # function returns a list of tables, one or more per sequence file (for all states specified merged)
  # NOTE THAT ONE SEQUENCE FILE MAY HAVE MORE THAN ONE CENSUS DATA TABLE IN IT
  if (testing) { cat(as.character(Sys.time()),"Finished concatenating states.\n")}
  
  return(alltables)
} #end of function

##################################################################
##################################################################
#	NOTES ON FUNCTION TO READ DATA AND MOE FILES FOR ALL STATES, FOR THE SPECIFIED TABLES
##################################################################

##########
#	PERFORMANCE / SPEED NOTES:
# On Mac, 8 min. for 8 tables, after colClasses, nrows, etc. fixed. (Prior to using colClasses, nrows, on Mac: 12 min./7 tables)
#	 8-10 minutes on MacBook Pro 16 GB RAM, SSD, 2.7 GHz Intel Core i7
#    Seems to take as long for just 8 tables with only tracts in the data files (tables B17020... for example)
#	read.csv is not the bottleneck. 
#	rbind steps must be slowest.
#   merge e and m files takes just a few seconds.
#
# But 12 minutes on PC for 7 tables, all states even after colClasses specified.
# Also on PC:
#   end seq 0044  - then tried to do merge and crashed - memory ran out. [still after fixed nrows??]
#   Error: cannot allocate vector of size 2.2 Mb
#   In addition: There were 50 or more warnings (use warnings() to see the first 50)
##########
