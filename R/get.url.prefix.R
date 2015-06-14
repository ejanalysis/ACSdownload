get.url.prefix <- function(end.year="2012") {
  return(paste(
    "ftp://ftp.census.gov/acs",
    end.year,
    "_5yr/summaryfile/",
    as.character(as.numeric(end.year)-4), "-", end.year,
    "_ACSSF_By_State_By_Sequence_Table_Subset",
    sep=""
    ))
}
