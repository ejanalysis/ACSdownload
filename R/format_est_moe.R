#' @title Reorder cols of estimates and MOE table
#' @description
#'  Start with a table that has all the estimates columns together, followed by all the MOEs columns,
#'  and create a new column sort order so that estimates will be interspersed with (next to) their MOE values, as FactFinder format provides.
#' @param my.list.of.tables Required list of tables from earlier steps in [get_acs_old()]
#' @return List of tables like input but with columns sorted in a new order.
#' @seealso [get_acs_old()] and [analyze.stuff::intersperse()]
#' @export
format_est_moe <- function(my.list.of.tables) {
  for (i in 1:length(my.list.of.tables)) {
    df <- my.list.of.tables[[i]]
    keycols <- c("KEY", "SUMLEVEL", "GEOID", "FIPS", "STUSAB")
    data.colnames <- names(df)[!(names(df) %in% keycols)]
    
    # Start with table that has all estimates together, followed by all MOEs,
    # and create a new sort order so that estimates will be interspersed with (next to) their MOE values, as FactFinder format provides.
    
    est.moe.order <-
      c(0, length(data.colnames) / 2) + rep(1:(length(data.colnames) / 2), each =
                                              2)
    data.colnames.ordered <- data.colnames[est.moe.order]
    my.list.of.tables[[i]] <- df[, c(keycols, data.colnames.ordered)]
  }
  return(my.list.of.tables)
}
