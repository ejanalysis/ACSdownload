
validate.end.year = function(end.year) {

  if (length(end.year) != 1) {stop('end.year must be a single value')}
  thisyear <- data.table::year(Sys.Date())
  if (!(end.year %in% as.character(acsfirstyearavailablehere:(thisyear - 1)))) {
    stop('end.year must be a plausible year')
  }
}
