#' @title Get short and long field names etc for ACS tables
#' @description
#'  Get info on tables from US Census Bureau for American Community Survey 5-year summary file.
#' @details Uses [get.lookup.acs()] but for latest version could just use `data(lookup.acs)`
#' @param tables Required vector of tables such as "B01001"
#' @param end.year Last year of 5-year summary file such as '2018' 
#' @param table.info.only FALSE by default. If TRUE, only return info about the table(s), not variables in table(s).
#' @param moe FALSE by default. Margin of error variables also included if TRUE,
#'   but their names are identical to those of estimates fields other than being MOE instead of estimate.
#' @param basic FALSE by default. If TRUE, a very limited subset of the info is returned
#'   (just variable number and name). This parameter is ignored if table.info.only=TRUE
#' @param silent Optional logical, FALSE by default. Whether to send progress info to standard output (like the screen)
#' @return data.frame of information about each table and each variable in table: \cr
#'   Value returned is data.frame of info about each table and also each variable in the table\cr
#'   e.g., longname2 which is version where no spaces or colons or escaped quotation marks etc. \cr
#' @seealso [get.acs()], [get.table.info()], and [get.field.info()]
#' @examples
#' \dontrun{
#'   finfo <- get.field.info(c('B17020A', 'B17020H'))
#'   cbind(
#'     names(tracts), substr(finfo$longname.unique[match(names(tracts), finfo$shortname)], 1, 100)
#'   )
#'   foundnames <- names(tracts)[names(tracts) %in% finfo$shortname]
#'   cbind(
#'     foundnames, substr(finfo$longname.unique[match(foundnames, finfo$shortname)], 1, 100)
#'   )
#' }
#' @export
get.field.info <-
  function(tables,
           end.year = acsdefaultendyearhere_func(),
           table.info.only = FALSE,
           moe = FALSE,
           basic = FALSE,
           silent = FALSE) {
    # Error checking
    if (length(end.year) != 1) {stop('end.year must be a single value')}
    thisyear <- data.table::year(Sys.Date())
    if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {stop('end.year must be a plausible year')}
    
    if (missing(tables)) {
      stop('Must specify tables as a vector of character string table IDs, such as B01001')
    }
    tables <- toupper(tables) # assume all are upper case in ACS
    
    # Get the text file with information on ACS tables and variables, downloading it if lookup.acs is not already a global variable in memory.
    x <- get.lookup.acs(end.year = end.year)
    x <-
      x[, c('Table.ID', 'Line.Number', 'Table.Title', 'Subject.Area')]
    
    # If tables is not specified, it could be extracted from an existing dataset (e.g. tracts) like this:
    # nam <- names(tracts); tables <- unique(substr(nam, 1, 7)); tables <- tables[tables %in% x$Table.ID]; rm(nam)
    
    # Error checking
    if (!all(tables %in% unique(x$Table.ID))) {
      if (!silent) {
        cat('Not found in list of ACS tables: ')
      }
      if (!silent) {
        cat(tables[!(tables %in% unique(x$Table.ID))])
        cat('\n')
      }
      #stop('To see a list of ACS table IDs, try  get.lookup.acs function')
      stop(
        'unique(get.lookup.acs()$Table.ID)  will show a list of ACS table IDs that can be used in get.field.info() or get.table.info...'
      )
    }
    
    ######### #
    # MAKE table.info (as long as the list of tables (one row per table))
    ######### #
    table.ID <- tables
    table.title <- x$Table.Title[match(tables, x$Table.ID)]
    table.universe  <- x$Table.Title[1 + match(tables, x$Table.ID)]
    table.subject <- x$Subject.Area[match(tables, x$Table.ID)]
    # collect this in data.frame:
    table.info <-
      data.frame(
        ID = table.ID,
        title = table.title,
        universe = table.universe,
        subject = table.subject,
        stringsAsFactors = FALSE
      )
    
    if (table.info.only) {
      if (moe) {
        table.info <- table.info
        table.info$ID <- paste(table.info$ID, "m", sep = '.')
        table.info$title <-
          paste("MOE for", table.info$title, sep = ' ')
      }
    } else {
      ######### #
      # field.info will be one row per variable, & will exclude universe and table title rows
      ######### #
      field.info <- x[x$Table.ID %in% table.ID,]
      field.info$tab.var <-
        paste(
          field.info$Table.ID,
          analyze.stuff::lead.zeroes(field.info$Line.Number, 3),
          sep = '.'
        )
      # note that it also needs each variable with .m appended for MOE info. #### TO BE ADDED
      field.info <- subset(field.info, !is.na(field.info$Line.Number))
      names(field.info) <-
        c('table.ID',
          'line.number',
          'longname',
          'subject',
          'shortname')
      field.info$subject <-
        table.subject[match(field.info$table.ID, table.ID)]
      field.info$universe <-
        table.universe[match(field.info$table.ID, table.ID)]
      field.info$table.title <-
        table.title[match(field.info$table.ID, table.ID)]
      
      field.info <-
        data.frame(
          table.ID = field.info$table.ID,
          line = field.info$line.number,
          shortname = field.info$shortname,
          longname = field.info$longname,
          table.title = field.info$table.title,
          universe = field.info$universe,
          subject = field.info$subject,
          stringsAsFactors = FALSE
        )
      
      # create longname2 which is version where no spaces or colons or escaped quotation marks etc.
      field.info$longname2 <-
        gsub("[ :,()']", "", field.info$longname)
      field.info$longname2 <- gsub("\"", "", field.info$longname2)
      # create longname.unique which is version where table name is appended since there can be multiple tables with the same field names, and may want a single variable that has it all
      field.info$longname.unique <-
        paste(field.info$longname, field.info$table.title, sep = '|')
      
      if (moe) {
        field.info.m <- field.info
        field.info.m$shortname <-
          paste(field.info.m$shortname, "m", sep = '.')
        field.info.m$longname <-
          paste("MOE for", field.info.m$longname, sep = ' ')
        field.info.m$longname2 <-
          paste("MOE for", field.info.m$longname2, sep = ' ')
        field.info.m$longname.unique <-
          paste("MOE for", field.info.m$longname.unique, sep = ' ')
      }
      
    }
    
    rm(x, table.ID, table.title, table.universe, table.subject)
    
    # Could get just the names that correspond to variables we have or want, contained in myfields, for example
    
    if (table.info.only) {
      if (basic) {
        warning('ignoring parameter "basic" because table.info.only=TRUE')
      }
      return(table.info)
    } else {
      if (moe) {
        if (basic) {
          field.info.m <- field.info.m[, c('shortname', 'longname')]
        }
        return(field.info.m)
      } else {
        if (basic) {
          field.info <- field.info[, c('shortname', 'longname')]
        }
        return(field.info)
      }
    }
  }
