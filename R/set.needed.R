#' @title Specify which ACS Variables are Needed
#' @description 
#'   Utility used by get.acs to help user specify which variables are needed.
#'   User can specify this in a file in the working directory, modifying "variables needed template.csv" 
#'   that this function can create based on tables parameter, to create user-defined "variables needed.csv" 
#' @param tables Character vector, required. Specifies which ACS tables.
#' @param folder Optional path, default is getwd(), specifying where to save the csv files that define needed variables.
#' @param lookup.acs Data.frame, optional. Defines which variables are in which tables. Output of \code{\link{get.lookup.acs}}
#' @param askneeded Optional logical, default is TRUE, specifies whether to pause and 
#'   ask user about variables needed in interactive session. 
#'   If FALSE, just looks for file called "variables needed.csv" that should specify which variables to keep from each table. 
#'   The format of that file should be the same as is found in the file "variables needed template.csv" created by this function. 
#'   If the "variables needed.csv" file is not found, it looks for and uses the file called "variables needed template.csv" 
#'   which is written by this function and specifies all of the variables from each table.
#' @return Returns data.frame of info on which variables are needed from each table, much like annotated version of lookup.acs.
#' @seealso \code{\link{get.acs}} which uses this
#' @export
set.needed <- function(tables, lookup.acs, askneeded=FALSE, folder=getwd()) {
  
  if (missing(lookup.acs)) {
    lookup.acs <- get.lookup.acs()
  }
  
  needed <- data.frame(
    seq=lookup.acs$Sequence.Number, 
    table=lookup.acs$Table.ID, 
    varnum=substr(paste("00", lookup.acs$Line.Number, sep=""), nchar(lookup.acs$Line.Number), 99), stringsAsFactors=FALSE)
  
  needed$table.var <- paste(needed$table, needed$varnum, sep=".")
  needed$varname <- lookup.acs$Table.Title
  needed$colnum <- lookup.acs$Line.Number
  
  # limit the "needed" table to the needed tables (not entire sequence files necessarily)
  needed <- needed[ needed$table %in% tables, ]
  
  # Fix "Total:" or other type of first row (e.g. Aggregate travel time to work (in minutes):)
  #  to also show the universe from one row above it in lookup table
  # needed$varname[needed$varname=="Total:"] <- gsub("Universe:  ", "", needed$varname[which(needed$varname=="Total:")-1])
  rows.to.fix <- (needed$colnum==1 & !is.na(needed$colnum))
  needed$varname[rows.to.fix] <- paste(needed$varname[rows.to.fix], needed$varname[which(rows.to.fix)-1] )
  #  Don't need to include TABLE NAME. 
  
  # NOW REMOVE SPECIAL NONVARIABLE ROWS 
  needed <- needed[ !is.na(needed$colnum), ]
  
  # head(needed)
  # but seq now has leading zeroes
  #  seq  table varnum  table.var          varname colnum
  #3   2 B01001    001 B01001.001 Total population      1
  #4   2 B01001    002 B01001.002            Male:      2
  #5   2 B01001    003 B01001.003    Under 5 years      3
  #6   2 B01001    004 B01001.004     5 to 9 years      4
  
  #	NOTE A SINGLE SEQUENCE FILE MAY HOLD >1 TABLE:
  #
  #table(needed$table, needed$seq)
  #        
  #           2   5  43  44  49 104
  #  B01001  49   0   0   0   0   0
  #  B03002   0  21   0   0   0   0
  #  B15002   0   0  35   0   0   0
  #  B16001   0   0   0 119   0   0
  #  B16002   0   0   0  14   0   0
  #  also note B16004 is in seqfile 44
  #  B25034   0   0   0   0   0  10
  #  C17002   0   0   0   0   8   0
  
  ########################################################
  # NOTE: The long names are available like this:   needed$varname[needed$table %in% tables]
  #
  # or more cols:  needed[needed$table %in% tables, c("table.var", "varname")]
  #     table.var                                                              varname
  #1   B01001.001                                                     Total population
  #3   B01001.003                                                        Under 5 years
  #20  B01001.020                                                      65 and 66 years
  # etc.
  # or clean long name:  needed[needed$table %in% tables, c("table.var", "varname2")]
  #     table.var                                               varname2
  #1   B01001.001                                        Totalpopulation
  #3   B01001.003                                            Under5years
  #20  B01001.020                                           65and66years
  #
  # or like this:   lookup.acs$Table.Title[lookup.acs$Table.ID %in% tables]
  # or more cols and rows:  lookup.acs[lookup.acs$Table.ID %in% tables, c("Table.ID", "Line.Number", "Table.Title")]
  ########################################################
  
  ##############################################################################
  # Windows can let user use edit() to 
  # SPECIFY VARIABLES WE NEED VS. VARIABLES TO DROP FROM THOSE TABLES
  # by deleting the "Y" for rows they don't want to keep
  ##############################################################################
  
  needed$keep <- "Y"	# default is Yes, keep every variable in the specified tables.
  
  # also let them specify user-defined friendly variable names in the varname column
  # clean up field by removing spaces and colons and escaped quotation marks etc.
  needed$varname2 <- gsub("[ :,()']", "", needed$varname)
  needed$varname2 <- gsub("\"", "", needed$varname2)
  
  #  save the template for user to start from
  write.csv(needed, file.path(folder, "variables needed template.csv"), row.names=FALSE)
  cat('  Finished writing template file to working directory on disk: variables needed template.csv\n')
  ##############################################################################
  os <- analyze.stuff::get.os()
  
  # windows user could do this interactively, but Mac OSX requires installation of xwindows for the edit() functionality.
  if (os=="win") {  
    inp <- 'n'
    if (askneeded) {
      print("You may now edit the input file specifying which variables are needed, or read the input file if already saved on disk.")
      inp <- readline("Press n to edit now onscreen interactively --and to use all fields then just close edit window-- 
                    or press y if ready to import an already-saved input file from disk called 'variables needed.csv'")
      
      # NOTE: THIS WON'T STOP AND WAIT FOR INPUT IF CODE IS COPIED AND PASTED INTO R CONSOLE.	
      # & the while() was an attempt to keep it here while rest of pasted text is read.
    }
    
    if (askneeded & tolower(substr(inp,1,1))=="n") {
      needed <- edit(needed) 
      # SAVE THESE windows SELECTIONS IN CASE WANT TO REUSE THEM BY IMPORTING HERE LATER
      write.csv(needed, file.path(folder, "variables needed.csv"), row.names=FALSE)
      cat('  Finished writing updated file: variables needed.csv\n')
    } else {
      cat("  Reading input file of variable selections, variables needed.csv 
          (or template for all variables if variables needed.csv was not found)\n")    
      if (file.exists("variables needed.csv")) {
        needed <- read.csv(file=file.path(folder, "variables needed.csv"), as.is=TRUE)
        cat('  Finished reading  variables needed.csv\n')
      } else { 
        needed <-  read.csv(file=file.path(folder, "variables needed template.csv"), as.is=TRUE) 
        cat('  Finished reading  variables needed template.csv\n')
      }
    }
  }
  
  # on mac ask user to edit template and save as "variables needed.csv" which will be imported 
  if (os=="mac") { 
    #try to pause here to allow user to edit the template and save it as "variables needed.csv"
    # SHOULD GIVE OPTION TO JUST GET ALL VARIABLES AS DEFAULT
    x <- 0
    if (askneeded) {
      # NOTE: THIS WON'T STOP AND WAIT FOR INPUT IF CODE IS COPIED AND PASTED INTO R CONSOLE.	      
      x <- readline("Just import full tables? (y for full, n to specify variables and/or custom names for variables):")
    } else {
      x <- 'y'
    }
    xx <- 0
    if (tolower(substr(x,1,1))=="n") {
      xx <- readline("Prepare input file 'variables needed.csv' in working directory, using 'variables needed template.csv' as a template. Press y when file is ready.")
      cat("  Reading input file of variable selections, variables needed.csv (or template for all variables if variables needed.csv was not found)\n")
      if (file.exists("variables needed.csv")) {
        needed <- read.csv(file=file.path(folder, "variables needed.csv"), as.is=TRUE)
        cat('  Finished reading  variables needed.csv\n')
      } else { 
        needed <-  read.csv(file=file.path(folder, "variables needed template.csv"), as.is=TRUE) 
        cat('  Finished reading  variables needed template.csv\n')
      }
    } else {
      needed <-  read.csv(file=file.path(folder, "variables needed template.csv"), as.is=TRUE) 
      cat('  Using file called variables needed template.csv ... Finished reading  variables needed template.csv\n')          
    }
    
    
    #      	if (tolower(substr(xx,1,1))=="y") {
    #    	  	# just use existing full version of needed, which is also saved as template, and don't need to save it as another csv. don't overwrite older subset selections.
    #     	    # needed <- needed;     write.csv(needed, "variables needed.csv", row.names=FALSE)
    #    	}
  }
  
  # retain only the rows with variables we want to keep.
  needed <- needed[needed$keep=="Y", ]
  return(needed)
}
