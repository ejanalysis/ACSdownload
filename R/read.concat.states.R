#' @title Read and concatenate State files of ACS data
#' @description Read the unzipped csv files of estimates and MOE (margin of error) for American Community Survey (ACS)
#'   5-year summary file data obtained from US Census FTP site.
#'   These State-specific csv files are combined into a single national result for each Census data table.
#' @details This can use read.csv (takes about 1 minute total for one table, all states, est and moe).
#'   It can use data.table::fread (default method), which is faster.
#' @param folder Default is current working directory. Specifies where the csv files are to be found.
#' @param tables Optional character vector of table numbers needed such as 'B01001', but default is all tables from each sequence file found.
#' @param needed Optional data.frame specifying which variables to keep from each table. Default is to keep all. See \code{\link{set.needed}} and \code{\link{get.acs}}
#' @param mystates Optional character vector of 2-character state abbreviations. Default is all states for which matching filenames are found in folder.
#' @param end.year Optional, specifies end year of 5-year summary file.
#' @param save.files Default is TRUE, in which case it saves each resulting table/ data file on disk.
#' @param testing Default is FALSE. If TRUE, prints filenames but does not unzip them, and prints more messages.
#' @param silent Default is FALSE. Whether to send progress info to standard output.
#' @param sumlevel Default is "both". Specifies if "tracts" or "blockgroups" or "both" should be returned.
#' @param output.path Default is whatever the parameter \code{folder} is set to. Results as .RData files are saved here if save.files=TRUE.
#' @param geo Optional table of geographic identifiers that elsewhere would be merged with data here.
#'   If provided, it is used here to look up data file length, based on state abbrev's list. See \code{\link{get.read.geo}}
#'   If geo is not provided, the function still reads each file whatever its length.
#' @param dt Optional logical, TRUE by default, specifies whether data.table::fread should be used instead of read.csv
#' @return Returns a list of data.frames, where each element of the list is one ACS table, such as table B01001.
#' @seealso \code{\link{get.acs}}
#' @export
read.concat.states <-
  function(tables,
           mystates,
           geo,
           needed,
           folder = getwd(),
           output.path,
           end.year = acsdefaultendyearhere_func(),
           save.files = TRUE,
           sumlevel = 'both',
           testing = FALSE,
           dt = TRUE,
           silent = FALSE) {
    if (missing(output.path)) {
      output.path <- folder
    }
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    #if (!exists('lookup.acs')) {
      lookup.acs <- get.lookup.acs(end.year = end.year)
    #}
    # lookup.acs (the table of all ACS variables/tables/seqfiles and which columns of seqfile and table have each)
    # stateabbs  (so the default will work, a vector of 2-letter state abbreviations for the US)
    
    # *** ACTUALLY, WE COULD JUST IGNORE OR INFER TABLE NUMBERS AND JUST READ ALL FILES FOUND AND HOPE THEY ARE FOR TABLES THAT MATCH WHAT IS IN needed
    # There is a problem when needed has only the tables
    # e.g. tables <- c("C17002", "B01001")
    if (missing(tables)) {
      # infer seqfiles
      seqfilelistnums.mine <- getseqnumsviafilenames(folder = folder)
      # figure out which tables are in those sequence files
      # *** but only do if missing tables since that might be more than what was specified in tables if passed here ***
      tables <-
        unique(lookup.acs$Table.ID[lookup.acs$Sequence.Number %in% seqfilelistnums.mine])
    } else {
      seqfilelistnums.mine <- which.seqfiles(tables, end.year = end.year)
      #e.g. # seqfilelistnums.mine <- "0044"; mystates <- "dc"
      #e.g. # seqfilelistnums.mine <- c("0044"); mystates <- c("de", "dc")
      seqfilelistnums.mine <-
        analyze.stuff::lead.zeroes(seqfilelistnums.mine, 4)
    }
    
    if (missing(needed)) {
      needed <-
        suppressMessages(
          set.needed(
            tables,
            lookup.acs = lookup.acs,
            vars = 'all',
            folder = folder,
            end.year = end.year,
            silent = TRUE
          )
        )
    }
    
    if (missing(mystates)) {
      mystates <- getstatesviafilenames(folder = folder)
    }
    
    mystates.no.us <- mystates[mystates != "us"]
    
    if (!dt) {
      if (missing(geo)) {
        # If geo is not provided, the function won't try to use geo to get length of datafile (nrow).
        # Just assume max possible value for count, roughly count of max blockgroups/state + max tracts/state, not  #count= 250000 + 75000,
        # which doesn't really matter much for speed of import, and obsolete/ irrelevant if using fread() instead of read.csv()
        states.num.places <-
          data.frame(
            STUSAB = mystates.no.us,
            count = 2400 + 8100,
            stringsAsFactors = FALSE
          )
      } else {
        # to find data file length (nrow), use state abbrev's list
        states.num.places <-
          as.data.frame(table(geo$STUSAB[geo$STUSAB %in% toupper(mystates.no.us)]))
        names(states.num.places) <- c("STUSAB", "count")
      }
    }
    
    if (testing) {
      cat(as.character(Sys.time()),
          "Started concatenating states.\n")
    }
    
    alltables <- list()
    gc()
    
    # These are the basic 6 columns that start every data file:
    
    keycols <-
      c("FILEID",
        "FILETYPE",
        "STUSAB",
        "CHARITER",
        "SEQUENCE",
        "LOGRECNO")
    
    count.keycols <- length(keycols)
    # ACSSF,2012m5,wy,000,0104,0000900, ...
    
    needed.keycols <- c("STUSAB", "LOGRECNO")
    
    # dropcols <- c("FILEID", "FILETYPE", "CHARITER")
    #colnums.needed.keycols <- which(keycols %in% needed.keycols)
    count.needed.keycols <- length(needed.keycols)
    colnums.drop.keycols <- which(!(keycols %in% needed.keycols))
    
    #	LOOP THROUGH THE SEQUENCE FILES ************************
    
    for (this.seq in seqfilelistnums.mine) {
      if (!silent) {
        cat(as.character(Sys.time()), ' ')
        cat("Now working on sequence file ", this.seq, " ----\n")
      }
      # e.g. # this.seq <- "0044"
      
      # note datafile() is now vectorized over states and sequence file numbers
      efiles.not.us <-
        datafile(mystates.no.us, this.seq, end.year = end.year)
      mfiles.not.us <- gsub("^e", "m", efiles.not.us)
      if (testing) {
        print("")
        cat("\nProcessing sequence file: ")
        cat(this.seq)
        cat("\n")
        cat("Looking for this type of file: \n")
        print(head(cbind(efiles.not.us, mfiles.not.us)))
      }
      
      #	datafile name examples:
      #	e20105de0017000.txt
      #	m20105de0017000.txt
      #################################### #
      
      if (!dt) {
        # assume every state has same number of columns to the given csv sequence file of estimates or moe
        cols.in.csv <-
          length(read.csv(
            file.path(folder, efiles.not.us[1]),
            nrows = 1,
            header = FALSE
          ))
      } else {
        cols.in.csv <-
          NCOL(junk <- data.table::fread(
            input = file.path(folder, efiles.not.us[1]),
            nrows = 1
          ))
      }
      
      ##################  LOOP THROUGH THE (specified) tables IN THIS SEQ FILE (TO GET COLUMNS RIGHT) ##################### #
      # ( just the specified ones in the variable  "tables" passed to this function ) *****
      # BUT NOTE THAT tables AND needed MIGHT DISAGREE! so use lookup not needed to see if in this.seq
      # Also,
      
      mytables.in.this.seq <-
        gettablesviaseqnums(this.seq, end.year = end.year)
      if (!missing(tables)) {
        mytables.in.this.seq <-
          mytables.in.this.seq[mytables.in.this.seq %in% tables]
      }
      
      for (this.tab in mytables.in.this.seq) {
        if (!silent) {
          cat("---- Now working on table ", this.tab, " ----\n")
        }
        # e.g.  this.tab <- "B16001"
        
        # Will drop the un-needed columns of data from the data files
        # So must find out which columns in the SEQUENCE FILE are needed for a given table
        # 1st obtain the column numbers of the desired variables in units of 1=the first col in the table, not in the seq file
        
        datacolnums 	<- needed$colnum[needed$table == this.tab]
        needed.varnames	<-
          needed$table.var[needed$table == this.tab]  # e.g.,  B17020A.001
        # NOTE: that might be an empty set, if no vars are needed from this table.
        #count.datacols <- length(datacolnums)
        
        # Now convert to units of which column in the sequence file, not within the individual table
        # start at starting point of this table within the sequence file (but retain the key columns like LOGRECNO)
        
        #allcolnums <- 1:cols.in.csv
        start.col <-
          lookup.acs$Start.Position[lookup.acs$Table.ID == this.tab][1]
        # colnums= which ones we want to obtain now from this sequence file for this table
        colnums <-
          c((1:count.keycols), (start.col - 1 + datacolnums))
        # Default is to drop the column via NULL as class, then specify which to keep as number or string, etc.
        my.colClasses <- rep("NULL", cols.in.csv)
        my.colClasses[colnums] <- "numeric"
        my.colClasses[1:count.keycols] <- "character"
        my.colClasses[colnums.drop.keycols] <- "NULL"
        
        # *************** Assume numeric for all except key columns like STUSAB, LOGRECNO, etc. **********
        # *************** but MOE files have "." sometimes!! ***********
        # And in many or all cases data are integer, which would be more efficient to store, but how to check that?
        
        if (!dt) {
          bigtable.e <- data.frame()
          bigtable.m <- data.frame()
        }
        
        #################################### #
        # READ AND CONCATENATE ALL STATES (FOR DATA)
        #################################### #
        # (& later elsewhere will merge with nationwide concatenated geo file)
        
        
        
        
        #) ###################### LOOP THROUGH STATES (FOR THIS TABLE) (IN THIS SEQUENCE FILE) ##################### #
        # FOR ESTIMATES FILES NOT MOE
        
        if (!silent) {
          cat(as.character(Sys.time()),
              "Estimates files       -- Appending States  \n")
        }
        state.num <- 0
        
        if (dt) {
          fileNames <- efiles.not.us
          #print(cbind(fileNames))
          bigtable.e <- data.table::rbindlist(lapply(file.path(folder, fileNames),
                                                     function(x) {
                                                       data.table::fread(
                                                         x,
                                                         stringsAsFactors = FALSE,
                                                         header = FALSE,
                                                         colClasses = my.colClasses,
                                                         na.strings = "."
                                                       )
                                                     })) #
          # x=data.table::fread(fileNames[1], stringsAsFactors=FALSE, header=FALSE, colClasses=my.colClasses, na.strings=".")
          # print(head(x))
          # stop('stopped')
        } else {
          for (this.file in efiles.not.us) {
            # e.g.#  this.file <- "e20125dc0044000.txt"
            # THIS WILL READ THE CSV FILE FOR THIS STATE-SEQFILE COMBO ONCE FOR EACH NEEDED TABLE IT CONTAINS
            # WHICH MAY BE SLOW/INEFFICIENT BUT KEEPS THE CODE A BIT SIMPLER
            # the read.csv is not a bottleneck anyway.
            # could use data.table::fread() if needed faster import
            
            state.num <- state.num + 1
            this.ST <- toupper(mystates.no.us[state.num])
            
            #           if (dt) {
            #             this.data <- data.table::fread(input=file.path(folder, this.file), stringsAsFactors=FALSE, header=FALSE,
            #                                            colClasses=my.colClasses,
            #                                            na.strings=".")
            #           } else {
            ##################### #
            rows.here <-
              states.num.places$count[states.num.places$STUSAB == this.ST]
            this.data <-
              read.csv(
                file.path(folder, this.file),
                stringsAsFactors = FALSE,
                header = FALSE,
                comment.char = "",
                nrows = rows.here,
                colClasses = my.colClasses,
                na.strings = "."
              )
            ##################### #
            # }
            
            # this is likely a problem when "." appears instead of a number in the MOE files.
            # since if col class is numeric then na.strings="." may not work.
            
            # Filter to keep only desired columns by using colClasses set to NULL for those to be dropped
            
            # Append this state table to the running compilation concatenating all states specified, for this table in the sequence file
            # Note rbind is slow for data frames
            #	if (testing) {
            if (!silent) {
              cat(toupper(this.ST), "")
            }
            #	}
            bigtable.e <- rbind(bigtable.e, this.data)
            rm(this.data)
          }
          # end of compiling all states for this one table in this one sequence file / data estimates
          if (!silent) {
            cat('\n')
          }
        }
        
        #) ###################### LOOP THROUGH STATES (FOR THIS TABLE) (IN THIS SEQUENCE FILE) ##################### #
        # FOR MARGIN OF ERROR FILES
        
        if (!silent) {
          cat(as.character(Sys.time()),
              "Margin of Error files -- Appending States  \n")
        }
        state.num <- 0
        
        if (dt) {
          fileNames <- mfiles.not.us
          bigtable.m <- data.table::rbindlist(lapply(file.path(folder, fileNames),
                                                     function(x) {
                                                       data.table::fread(
                                                         x,
                                                         stringsAsFactors = FALSE,
                                                         header = FALSE,
                                                         colClasses = my.colClasses,
                                                         na.strings = "."
                                                       )
                                                     }))
          
        } else {
          for (this.file in mfiles.not.us) {
            state.num <- state.num + 1
            this.ST <- toupper(mystates.no.us[state.num])
            
            #         if (dt) {
            #           this.data <- data.table::fread(input=file.path(folder, this.file), stringsAsFactors=FALSE, header=FALSE,
            #                                          colClasses=my.colClasses,
            #                                          na.strings=".")
            #         } else {
            ##################### #
            rows.here <-
              states.num.places$count[states.num.places$STUSAB == this.ST]
            this.data <-
              read.csv(
                file.path(folder, this.file),
                stringsAsFactors = FALSE,
                header = FALSE,
                comment.char = "",
                nrows = rows.here,
                colClasses = my.colClasses,
                na.strings = "."
              )
            ##################### #
            # }
            
            # this is likely a problem when "." appears instead of a number in the MOE files.
            # since if col class is numeric then na.strings="." may not work.??
            
            # Filter to keep only desired columns by using colClasses set to NULL for those to be dropped
            #this.data <- this.data[ , colnums]
            
            # Append this state table to the running compilation concatenating all states specified, for this sequence file
            # Note rbind is slow for data frames, but rbind works in data.table as well and is faster.
            # and you can read all and rbind them all at once without a loop, like this:
            # bigtable.m <- rbindlist(lapply(fileNames, fread))
            
            if (!silent) {
              cat(toupper(this.ST), "")
            }
            bigtable.m <- rbind(bigtable.m, this.data)
            rm(this.data)
          }
          # end of compiling all states for this one table in this one sequence file / MOE files
          if (!silent) {
            cat('\n')
          }
          
        }
        
        ####################### #
        
        if (dt) {
          data.table::setnames(bigtable.e,
                               names(bigtable.e),
                               c(needed.keycols, needed.varnames))
          data.table::setnames(bigtable.m,
                               names(bigtable.m),
                               c(needed.keycols, needed.varnames))
        } else {
          names(bigtable.e) <- c(needed.keycols, needed.varnames)
          names(bigtable.m) <- c(needed.keycols, needed.varnames)
        }
        
        # append .m to each field name to signify MOE margin of error not estimates data
        # BUT NOT TO THE NON-DATA FIELDS LIKE LOGRECNO !
        datacolnums.here <-
          (count.needed.keycols + 1):length(names(bigtable.m))
        if (testing) {
          print(str(bigtable.m))
          cat(
            ' is str of bigtable.m and ',
            needed.varnames,
            ' is needed.varnames and datacolnums.here is ',
            datacolnums.here,
            '\n'
          )
          cat(names(bigtable.m), ' is names of bigtable.m \n')
        }
        if (dt) {
          data.table::setnames(bigtable.m, names(bigtable.m), c(names(bigtable.m)[1:count.needed.keycols], paste(names(bigtable.m)[datacolnums.here], ".m", sep =
                                                                                                                   "")))
        } else {
          names(bigtable.m)[datacolnums.here] <-
            paste(names(bigtable.m)[datacolnums.here], ".m", sep = "")
        }
        
        # UNIQUE ID FOR MERGE/JOIN OF GEO TO DATA/MOE WILL BE FORMED FROM COMBINATION OF
        #  LOGRECNO & STATE FIPS
        # in geo file KEY is created using lower case version of STUSAB.
        # SAME FOR MERGE/JOIN OF DATA TO MOE TABLE.
        # geo has FIPS
        # Data table lacks FIPS
        
        bigtable.e$KEY <-
          paste(tolower(bigtable.e$STUSAB), bigtable.e$LOGRECNO, sep = "")
        bigtable.m$KEY <-
          paste(tolower(bigtable.m$STUSAB), bigtable.m$LOGRECNO, sep = "")
        if (dt) {
          data.table::setkey(bigtable.m, KEY)
          data.table::setkey(bigtable.m, KEY)
        }
        
        # MERGE DATA AND MOE TABLES NOW
        # but drop extra copy of 3 key cols (STUSAB, SEQUENCE, LOGRECNO) from MOE file
        # (Those are not actually essential overall  & could be cut from estimates file also)
        bigtable.m <-
          bigtable.m[, (c("KEY", names(bigtable.m)[datacolnums.here]))]
        
        if (!silent) {
          cat(as.character(Sys.time()),
              "Started merging estimates and MOE information \n")
        }
        
        # NOTE plyr::join is much faster than merge (& data.table merge is faster also) according to
        # http://stackoverflow.com/questions/1299871/how-to-join-data-frames-in-r-inner-outer-left-right/1300618#1300618
        #
        #       if ( all(bigtable.e$KEY==bigtable.m$KEY) ) {
        #         bigtable <- data.frame( KEY=bigtable.e$KEY,
        #                                 bigtable.e[ , names(bigtable.e)!="KEY"],
        #                                 bigtable.m[ , names(bigtable.m)!="KEY"], stringsAsFactors=FALSE)
        #       } else {
        bigtable <- merge(bigtable.e, bigtable.m, by = "KEY")
        if (!all(NROW(bigtable) == NROW(bigtable.m) &
                 NROW(bigtable) == NROW(bigtable.e))) {
          stop("Estimates and MOE table rows don't match!\n")
        }
        # }
        
        rm(bigtable.e, bigtable.m)
        if (dt) {
          bigtable <- data.frame(bigtable, stringsAsFactors = FALSE)
        }
        
        if (!silent) {
          cat(as.character(Sys.time()), "Finished merging")
        }
        ############# #
        
        if (save.files) {
          # save each table as a data file
          datafile.prefix <- get.datafile.prefix(end.year = end.year)
          fname <-
            paste("ACS-", datafile.prefix, "-", this.tab, ".RData", sep = "")
          save(bigtable, file = file.path(output.path, fname))
          if (!silent) {
            cat(
              as.character(Sys.time()),
              paste(
                "Saved as file (tracts / block groups but no geo info): ",
                fname,
                "\n"
              )
            )
          }
          
          #fname <- paste("ACS-", datafile.prefix, "-", this.tab, ".csv", sep="")
          #write.csv(bigtable, file=fname, row.names=FALSE)
          # if (!silent) {cat(paste("  Saved as file (tracts / block groups but no geo info): ", fname,"\n")) }
        }
        
        ################### #
        # 	MEMORY LIMITATIONS ON WINDOWS MAKE IT HARD TO COMBINE ALL STATES ALL TABLES MOE/ESTIMATES IN ONE LARGE LIST IN MEMORY:
        #  170 MB used for alltables if all states but only 2 short tables read.
        alltables[[this.tab]] <- bigtable
        #alltables <- bigtable
        ################### #
        
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
      
      if (length(mytables.in.this.seq) > 1 &
          this.tab != mytables.in.this.seq[length(mytables.in.this.seq)]) {
        # if there are 2+ seqfiles, then after each but the last one, print a divider line:
        if (!silent) {
          cat("--------------------------\n")
        }
      }
      
    } # end of loop over sequence files
    if (!silent) {
      cat(" \n")
    }
    
    # function returns a list of tables, one or more per sequence file (for all states specified merged)
    # NOTE THAT ONE SEQUENCE FILE MAY HAVE MORE THAN ONE CENSUS DATA TABLE IN IT
    if (testing) {
      cat(as.character(Sys.time()),
          "Finished concatenating states.\n")
    }
    
    return(alltables)
  } #end of function

################################################################# #
################################################################# #
#	NOTES ON FUNCTION TO READ DATA AND MOE FILES FOR ALL STATES, FOR THE SPECIFIED TABLES
################################################################# #

######### #
#	PERFORMANCE / SPEED NOTES: **** notes are from before data.table package was used.
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
######### #
