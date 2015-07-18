get.tracts <- function(merged.tables.mine) {
	return(merged.tables.mine[merged.tables.mine$SUMLEVEL=="140" , ])
  #	FUNCTION TO split tracts and block groups into 2 files based on SUMLEVEL code 140 or 150
  #rm(merged.tables.mine)
}

get.bg <- function(merged.tables.mine) {
	return(merged.tables.mine[merged.tables.mine$SUMLEVEL=="150" , ])
  #	FUNCTION TO split tracts and block groups into 2 files based on SUMLEVEL code 140 or 150
  #rm(merged.tables.mine)
}
