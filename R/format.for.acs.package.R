#' @title Reformat ACS Data Obtained by \code{\link{get.acs}} for Import to the acs Package
#' @description  Work in progress ***** \cr\cr
#'  Currently only works for 5-year summary file data from ACS. 
#'  Use same format as American Fact Finder uses for downloaded csv of tract data, for example. 
#'  Format is ESTIMATE, MOE, ESTIMATE, MOE... and KEY cols are GEOID, FIPS, AND NAME,
#'	but also SUMLEVEL (specifies if tract or blockgroup, for example), and not STUSAB (2-letter State abbreviation).
#' @details
#' Downloading C17002 from American Fact Finder results in a zip file with csv as follows:\cr
#' ACS_13_5YR_B01001_with_ann.csv or ACS_12_5YR_C17002_with_ann.csv  is format of the data file with estimates and MOE values\cr
#' First row is header with field names. Other rows are tract data. \cr
#' Note that the fields are:\cr
#' GEOID, FIPS, NAME, e1, m1, e2, m2, etc.\cr
#' Columns 1,2,3 are geo information. Columns 4+ are data (estimate,moe,estimate,moe, etc.)\cr
#' First 2 rows example:\cr
#'  GEO.id,GEO.id2,GEO.display-label,HD01_VD01,HD02_VD01,HD01_VD02,HD02_VD02,HD01_VD03,HD02_VD03,HD01_VD04,HD02_VD04,HD01_VD05,HD02_VD05,HD01_VD06,HD02_VD06,HD01_VD07,HD02_VD07,HD01_VD08,HD02_VD08\cr
#'  0800000US110015000050000000501,110015000050000000501,"Census Tract 5.01, Washington city, Washington city, District of Columbia, District of Columbia",3113,296,232,164,50,47,77,84,82,90,199,122,19,29,2454,312\cr
#'
#' ACS_12_5YR_C17002_metadata.csv  has the long and short variable names. \cr
#' There is no header row. A header of field names would be these 2: "short.name", "long.name"\cr
#' Each row here corresponds to one column of the data/moe fields (after the geo fields) in the main data file.\cr
#' First few rows example:\cr
#'  GEO.id,Id      This is like GEOID field in acs via ftp
#'  GEO.id2,Id2    This seems to be like FIPS string portion of GEOID \cr  
#'  GEO.display-label,Geography  This is a full place name (NAME) \cr
#'  HD01_VD01,Estimate; Total:\cr
#'  HD02_VD01,Margin of Error; Total:\cr
#'  HD01_VD02,Estimate; Total: - Under .50\cr
#'  HD02_VD02,Margin of Error; Total: - Under .50\cr \cr
#'  
#'  e.g., \cr
#'                  GEO.id     GEO.id2                                 GEO.display.label        HD01_VD01 \cr
#'  1                   Id         Id2                                         Geography Estimate; Total: \cr
#'  2 1400000US24031700101 24031700101 Census Tract 7001.01, Montgomery County, Maryland             4477 \cr
#'  3 1400000US24031700103 24031700103 Census Tract 7001.03, Montgomery County, Maryland             5776 \cr
#'   
#' JUST TRACTS were available from Fact Finder up to 2008-2012 ACS, so that is what acs package would typically import until recently.\cr
#' Actually starting with 2009-2013 ACS, block groups are available via AFF, but only by specifying one (or each) county in a State.\cr
#'  ###############################################################################\cr
#'
#' @param x Required list of tables from earlier steps in \code{\link{get.acs}}
#' @param end.year Optional, text to use in filename if savefile=TRUE, default is '2012'. The acs package 
#' needs this in the filename to infer the year, or that can be specified as the \code{endyear} parameter in \code{\link[acs{read.acs}}
#' @param tableid Used to name any saved file. Should be a string such as 'B01001'. Default is ''
#' @param savefile Default is TRUE which means save a csv file to folder
#' @param folder Default is getwd() and specifies where to save csv if savefile=TRUE
#' @return Data.frame for use in \link[acs]{acs} package.
#' @seealso \code{\link{get.acs}} to obtain acs data for use in this function, and then \code{\link[acs]{read.acs}} to read csv created by this function
#' @export
format.for.acs.package <- function(x, tableid='', folder=getwd(), end.year="2012", savefile=TRUE) {

  # Function in acs package that reads results:
  #   read.acs(filename, endyear = "auto", span = "auto", col.names= "auto",
  #            acs.units = "auto", geocols = "auto", skip = "auto")
  

	keycols <- c("GEOID", "FIPS", "NAME")
	keycols1 <- c('GEO.id', 'GEO.id2', 'GEO.display.label')
	keycols2 <- c('Id', 'Id2', 'Geography')
	
	# NAME field was not downloaded and retained due to encoding problems on OS X,
	# but is belongs in the AFF format table to be imported by acs package
	#if ('NAME' %in% colnames(x)) {x$NAME <- "NA"}
	
	datacolnames <- names(x)[!(names(x) %in% keycols)]
	# not tested yet to see what happens / should happen if more than one ACS table is here
	tableid <- unique(gsub('\\..*', '', datacolnames))

	####### shift to headers AFF uses
	
	x <- x[ , c(keycols, datacolnames)]
	names(x) <- c(keycols1, *************************)
	
	# placeholder for longnames row
	longnames <- datacolnames   # **** get longnames from where? 
	# They are not quite acs.lookup(endyear=2013, span = 5, table.number = 'B01001') 
	#variable.code table.number table.name           variable.name
	#1     B01001_001       B01001 Sex by Age                 Total: 
	#2     B01001_002       B01001 Sex by Age                  Male: 
	#3     B01001_003       B01001 Sex by Age    Male: Under 5 years 
	
	
	row2 <- c(keycols2, longnames)
	
	x <- rbind(row2, x)

	# 	cat(filename, '\n')
	# 	cat( names(x) , '\n');
	# 	cat("-------------------\n")
	
	if (savefile) {
	  if (missing(end.year)) {warning('end.year not specified so filename created assuming ', end.year)}
	  filename <- paste("ACS_", substr(end.year, 3, 4), "_5YR_", tableid, "_with_ann.csv", sep="") # ACS_13_5YR_B01001_with_ann.csv
	  write.csv(x, row.names = FALSE, file=file.path(folder, filename)  )
	}
	
	return(x)
}
