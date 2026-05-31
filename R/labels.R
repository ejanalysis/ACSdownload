# ---------------------------------------------------------------------------- #
# Public helpers for looking up human-readable labels for ACS variable codes.
# Backed by the `acs_table_shells` data object (see R/data_acs_table_shells.R).
# ---------------------------------------------------------------------------- #


#' Look up the human-readable label for one or more ACS variable codes
#'
#' Returns a data.table joining the input codes to the table title, label,
#' and population universe from `acs_table_shells`. Useful for turning
#' the cryptic column names that `get_acs_new()` returns (e.g.
#' `"B01001_001"`) into something a reader can understand.
#'
#' The shipped lookup is built from the 2022 5-year vintage of the Census
#' table shells. Labels for tables that exist across multiple vintages are
#' stable; for unfamiliar tables, double-check the official documentation
#' at <https://data.census.gov/>.
#'
#' @param variable_id character vector of ACS variable codes (e.g.
#'   `"B01001_001"`). The trailing margin-of-error variant
#'   (`"B01001_M001"`) is automatically normalized to the estimate
#'   variable, so MOE columns get their estimate's label.
#' @returns a data.table with one row per input, columns:
#'   `variable_id` (as supplied), `table_id`, `label`, `table_title`,
#'   `universe`. Unmatched codes get NA in the lookup columns.
#'
#' @examples
#'  acs_label(c("B01001_001", "B01001_M001", "C16001_002"))
#'
#' @export
acs_label <- function(variable_id) {
  if (!exists("acs_table_shells", envir = topenv())) {
    # Loaded via LazyData but also try explicit load when called from a
    # non-package context.
    e <- new.env()
    data("acs_table_shells", package = "ACSdownload", envir = e)
    acs_table_shells <- e$acs_table_shells
  } else {
    acs_table_shells <- get("acs_table_shells", envir = topenv())
  }

  vid <- as.character(variable_id)
  # Treat "_M001" (margin of error) as if it were the estimate variant.
  lookup_key <- sub("_M([0-9]+)$", "_\\1", vid)
  lookup_key <- sub("_E([0-9]+)$", "_\\1", lookup_key)

  # Build full lookup keys that match the table-shells "B01001_001" style.
  # Our v3 fread output uses "_001" / "_M001"; the table-shells use "_001"
  # for the underlying variable, so we need to add a leading underscore
  # back if the input was already stripped. The shells use the pattern
  # "<TABLE>_<NNN>", e.g. "B01001_001". After our normalization above,
  # lookup_key matches exactly.
  ids <- data.table::data.table(variable_id = vid, lookup_key = lookup_key)
  out <- merge(
    ids,
    acs_table_shells[, .(variable_id, table_id, label, table_title, universe)],
    by.x = "lookup_key", by.y = "variable_id",
    all.x = TRUE, sort = FALSE
  )
  out[, lookup_key := NULL]
  data.table::setcolorder(out,
    c("variable_id", "table_id", "label", "table_title", "universe"))
  out[]
}
