#' @title Get field names etc for ACS tables
#' @description
#'  Get info on tables from US Census Bureau for American Community Survey 5-year summary file.
#' @details Wrapper for [get.field.info()]
#' @param tables Required vector of tables such as "B01001"
#' @param end.year Last year of 5-year summary file such as '2018'
#' @param table.info.only TRUE by default. See [get.field.info()]
#' @param moe FALSE by default. If TRUE, returns MOE versions of field names and descriptions.
#' @return data.frame of information about each table and each variable in table: \cr
#'   Table.ID, Line.Number, Table.Title, table.var, varname2 \cr\cr
#'     # Value returned is data.frame of info about each table and also each variable in the table:\cr
#'
#'         Table.ID Line.Number                                                 Table.Title  table.var                                           varname2\cr
#'   7       B01001          NA                                                  SEX BY AGE       <NA>                                           SEXBYAGE\cr
#'   8       B01001          NA                                 Universe:  Total population       <NA>                            UniverseTotalpopulation\cr
#'   9       B01001           1                                                      Total: B01001.001                                              Total\cr
#'   10      B01001           2                                                       Male: B01001.002                                               Male\cr
#' @seealso [get.acs()], [get.table.info()]
#'
#'
get.table.info2 <-  function(tables,
           end.year = acsdefaultendyearhere_func(),
           table.info.only = TRUE,
           moe = FALSE) {

    if (missing(tables)) {
      stop('Must specify tables as a vector of character string table IDs, such as B01001')
    }
  validate.end.year(end.year)

    return(
      get.field.info(
        tables = tables,
        end.year = end.year,
        table.info.only = table.info.only,
        moe = moe
      )
    )

  }
