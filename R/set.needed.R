#' @title Specify which ACS Variables are Needed
#' @description
#'   Utility used by get.acs to help user specify which variables are needed.
#'   User can specify this in a file in the working directory, modifying "variables needed template.csv"
#'   that this function can create based on tables parameter, to create user-defined "variables needed.csv"
#' @param tables Character vector, required. Specifies which ACS tables.
#' @param folder Optional path, default is getwd(), specifying where to save the csv files that define needed variables.
#' @param lookup.acs Data.frame, optional. Defines which variables are in which tables. Output of [get.lookup.acs()]
#' @param varsfile Optional name of file that can be used to specify which variables are needed from specified tables.
#'   If varsfile is specified, parameter vars is ignored, and the function just looks in folder for file called filename, e.g., "variables needed.csv"
#'   that should specify which variables to keep from each table.
#'   If not found in folder, then all variables from each table are used (same as if vars="all" and varsfile not specified).
#'   The format of that file should be the same as is found in the file "variables needed template.csv" created by this function.
#'   If the filename (e.g., "variables needed.csv" file) is not found, it looks for and uses the file called "variables needed template.csv"
#'   which is written by this function and specifies all of the variables from each table.
#'   The column called "keep" should have an upper or lowercase letter Y to indicate that row (variable) should be kept.
#'     Blanks or other values (even the word "yes") indicate the variable is not needed from that data table and it will be dropped.
#' @param vars Optional default is all, which means all fields from table unless varsfile specified.
#'   Specifies what variables to use from specified tables, and how to determine that.
#'   If varsfile is provided, vars is ignored (see parameter varsfile).
#'   If vars="ask", function will ask user about variables needed and allow specification in an interactive session.
#' @param noEditOnMac FALSE by default. If TRUE, do not pause to allow edit() when on Mac OSX, even if vars=TRUE. Allows you to avoid problem in RStudio if X11 not installed.
#' @param end.year Optional,  -- specifies last year of 5-year summary file that is being used.
#' @param silent Optional, defaults to TRUE. If FALSE, prints some indications of progress.
#' @param writefile Optional, defaults to TRUE. If TRUE, saves template of needed variables as "variables needed template.csv" file to folder.
#' @return Returns data.frame of info on which variables are needed from each table, much like annotated version of lookup.acs.
#' @seealso [get.acs()] which uses this
#' @export
set.needed <-
  function(tables,
           lookup.acs,
           vars = 'all',
           varsfile,
           folder = getwd(),
           noEditOnMac = FALSE,
           end.year = acsdefaultendyearhere_func(),
           silent = TRUE,
           writefile = TRUE) {
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    if (missing(lookup.acs)) {
      lookup.acs <- get.lookup.acs(end.year = end.year)
    }
    
    needed <- data.frame(
      seq = lookup.acs$Sequence.Number,
      table = lookup.acs$Table.ID,
      varnum = substr(
        paste("00", lookup.acs$Line.Number, sep = ""),
        nchar(lookup.acs$Line.Number),
        99
      ),
      stringsAsFactors = FALSE
    )
    
    needed$table.var <- paste(needed$table, needed$varnum, sep = ".")
    needed$varname <- lookup.acs$Table.Title
    needed$colnum <- lookup.acs$Line.Number
    
    # limit the "needed" table to the needed tables (not entire sequence files necessarily)
    tablematches <- needed$table %in% tables
    if (all(tablematches == FALSE)) {stop('None of the specified tables were found in specified lookup.acs')}
    needed <- needed[tablematches, ]
    # Fix "Total:" or other type of first row (e.g. Aggregate travel time to work (in minutes):)
    #  to also show the universe from one row above it in lookup table
    # needed$varname[needed$varname=="Total:"] <- gsub("Universe:  ", "", needed$varname[which(needed$varname=="Total:")-1])
    rows.to.fix <- (needed$colnum == 1 & !is.na(needed$colnum))
    needed$varname[rows.to.fix] <-
      paste(needed$varname[rows.to.fix], needed$varname[which(rows.to.fix) -
                                                          1])
    #  Don't need to include TABLE NAME.
    
    # NOW REMOVE SPECIAL NONVARIABLE ROWS
    needed <- needed[!is.na(needed$colnum),]
    
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
    #  B16002   0   0   0  14   0   0   # now 16004
    #  also note B16004 was in seqfile 44 but
    # C16002 replaced B16004 that was older ACS source for what had been called linguistic isolation, now called limited English speaking households.
    #  B25034   0   0   0   0   0  10
    #  C17002   0   0   0   0   8   0
    
    ####################################################### #
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
    ####################################################### #
    
    ############################################################################# #
    # Windows and possibly OSX can let user use edit() to
    # SPECIFY VARIABLES WE NEED VS. VARIABLES TO DROP FROM THOSE TABLES
    # by deleting the "Y" for rows they don't want to keep
    ############################################################################# #
    
    needed$keep <-
      "Y"	# default is Yes, keep every variable in the specified tables.
    
    # also let them specify user-defined friendly variable names in the varname column
    # clean up field by removing spaces and colons and escaped quotation marks etc.
    needed$varname2 <- gsub("[ :,()']", "", needed$varname)
    needed$varname2 <- gsub("\"", "", needed$varname2)
    
    
    ############################################################################# #
    #  save the template for user to start from (maybe don't need to if varsfile found nor if vars!="ask")
    # *** line 189 or so uses this file to read back in but could change that to just use needed from memory
    if (writefile) {
      write.csv(needed,
                file.path(folder, "variables needed template.csv"),
                row.names = FALSE)
      if (!silent) {
        cat(as.character(Sys.time()), ' ')
        cat(
          'Finished writing template file: variables needed template.csv\n'
        )
      }
    }
    ############################################################################# #
    
    if (vars == 'all') {
      # default, unless varsfile specified and found
      #needed <- needed
    }
    
    if (!missing(varsfile)) {
      if (file.exists(file.path(folder, varsfile))) {
        needed <- read.csv(file = file.path(folder, varsfile), as.is = TRUE)
        if (!silent) {
          cat(as.character(Sys.time()), ' ')
          cat('Finished reading', varsfile, '\n')
        }
        
        # SHOULD ADD ERROR CHECKING HERE ON FORMAT OF FILE USER PROVIDED ***
        
      } else {
        if (!file.exists(file.path(folder, "variables needed template.csv"))) {
          # needed <- needed
          warning(' Cannot find specified varsfile, so using all variables')
        } else {
          needed <-
            read.csv(file = file.path(folder, "variables needed template.csv"),
                     as.is = TRUE)
          warning(
            ' Cannot find specified varsfile, so using all variables by reading  variables needed template.csv\n'
          )
        }
      }
    }
    
    if (missing(varsfile) & vars != 'ask' & vars != 'all') {
      needed <- needed[needed$table.var %in% vars,]
      # ERROR CHECKING TO SEE IF AT LEAST ONE OF USERS vars WAS FOUND AMONG needed$table.var
      if (nrow(needed) == 0) {
        stop(
          'specified vars not found in these tables in that format -- must be formatted such as "B01001.001" '
        )
      }
    }
    
    os <- analyze.stuff::os()
    
    # windows user could do this interactively, using edit(),
    # but Mac OSX RStudio seems to require installation of X11 / The X Window System (xquartz) for the edit() functionality.
    # Mac OSX R.app however, seems to not need X11. But you have to use command-W when you are done editing (trying to close the window by clicking the red x seems to crash it.)
    # see http://xquartz.macosforge.org and https://support.apple.com/en-us/HT201341 regarding X11 / XQuartz.
    # and https://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html#Editor-_0028internal-and-external_0029
    
    if (os != "mac" | noEditOnMac == FALSE) {
      # Used to do this only in windows but it generally works in OSX as well, so just try
      inp <- 'n'
      if (vars == 'ask' & missing(varsfile)) {
        print(
          "You may now edit the input file specifying which variables are needed, or read the input file if already saved on disk."
        )
        inp <-
          readline(
            "Press n to edit now onscreen interactively --and to use all fields then just close edit window--
            or press y if ready to import an already-saved input file from disk called 'variables needed.csv' \n"
          )
        
        # NOTE: THIS WON'T STOP AND WAIT FOR INPUT IF CODE IS COPIED AND PASTED INTO R CONSOLE.
        # & the while() was an attempt to keep it here while rest of pasted text is read.
      }
      
      if (vars == 'ask' &
          missing(varsfile) & tolower(substr(inp, 1, 1)) == "n") {
        needed <- edit(needed)
        # USER WANTS TO EDIT THE TABLE THAT SPECIFIES WHICH VARIABLES TO KEEP.
        # SAVE THESE windows SELECTIONS IN CASE WANT TO REUSE THEM BY IMPORTING HERE LATER
        write.csv(needed,
                  file.path(folder, "variables needed.csv"),
                  row.names = FALSE)
        if (!silent) {
          cat(as.character(Sys.time()), ' ')
          cat('Finished writing updated file: variables needed.csv\n')
        }
      } else {
        # USER WANTS TO SPECIFY VARIABLES TO KEEP BY READING FILE CALLED 'variables needed.csv' # ***
        if (!silent) {
          cat(as.character(Sys.time()), ' ')
          cat(
            "Reading input file of variable selections, variables needed.csv
            (or template for all variables if variables needed.csv was not found)\n"
          )
        }
        if (file.exists(file.path(folder, "variables needed.csv"))) {
          needed <-
            read.csv(file = file.path(folder, "variables needed.csv"),
                     as.is = TRUE)
          if (!silent) {
            cat(as.character(Sys.time()), ' ')
            cat('Finished reading  variables needed.csv\n')
          }
        } else {
          if (!silent) {
            cat(as.character(Sys.time()), ' ')
            cat(
              'File specifying ACS variables in given tables was not found so using all variables \n'
            )
          }
          # needed <- needed
          #         if (file.exists(file.path(folder, 'variables needed template.csv'))) {
          #           needed <-  read.csv(file=file.path(folder, "variables needed template.csv"), as.is=TRUE)
          #           if (!silent) {
          #             cat('Finished reading  variables needed template.csv\n')
          #           }
          #         } else {
          #           # needed <- needed
          #         }
        }
        }
  }
    
    # on mac ask user to edit template and save as "variables needed.csv" which will be imported
    if (vars == 'ask' & missing(varsfile) & os == "mac" &
        noEditOnMac) {
      #try to pause here to allow user to edit the template and save it as "variables needed.csv"
      # SHOULD GIVE OPTION TO JUST GET ALL VARIABLES AS DEFAULT
      x <- 0
      if (vars) {
        # NOTE: THIS WON'T STOP AND WAIT FOR INPUT IF CODE IS COPIED AND PASTED INTO R CONSOLE.
        x <-
          readline(
            "Just import full tables? (y for full, n to specify variables and/or custom names for variables):\n"
          )
      } else {
        x <- 'y'
      }
      xx <- 0
      if (tolower(substr(x, 1, 1)) == "n") {
        # SPECIFYING VARIABLES IN A FILE
        xx <-
          readline(
            paste(
              "Prepare input file 'variables needed.csv' in ",
              folder,
              ", using 'variables needed template.csv' as a template. Press y when file is ready.\n"
            )
          )
        if (!silent) {
          cat(as.character(Sys.time()), ' ')
          cat(
            "  Reading input file of variable selections, such as variables needed.csv (or template for all variables if file not found)\n"
          )
        }
        #if (file.exists(file.path(folder, "variables needed.csv"))) {
        if (file.exists(file.path(folder, 'variables needed.csv'))) {
          needed <-
            read.csv(file = file.path(folder, 'variables needed.csv'),
                     as.is = TRUE)
          if (!silent) {
            cat(as.character(Sys.time()), ' ')
            cat('  Finished reading', 'variables needed.csv', '\n')
          }
        } else {
          needed <-
            read.csv(file = file.path(folder, "variables needed template.csv"),
                     as.is = TRUE)
          if (!silent) {
            cat(as.character(Sys.time()), ' ')
            cat('  Finished reading  variables needed template.csv\n')
          }
        }
        
      } else {
        needed <-
          read.csv(file = file.path(folder, "variables needed template.csv"),
                   as.is = TRUE)
        if (!silent) {
          cat(as.character(Sys.time()), ' ')
          cat(
            '  Using file called variables needed template.csv ... Finished reading  variables needed template.csv\n'
          )
        }
      }
      #      	if (tolower(substr(xx,1,1))=="y") {
      #    	  	# just use existing full version of needed, which is also saved as template, and don't need to save it as another csv. don't overwrite older subset selections.
      #     	    # needed <- needed;     write.csv(needed, "variables needed.csv", row.names=FALSE)
      #    	}
    }
    
    
    # retain only the rows with variables we want to keep.
    # remove row if keep col has NA which happens if user leaves it blank (e.g. deletes Y from template instead of replacing it with N)
    needed <- needed[!is.na(needed$keep),]
    needed <- needed[tolower(needed$keep) == "y",]
    return(needed)
  }
