# ---------------------------------------------------------------------------- #
# Build the `acs_table_shells` data object: a tidy lookup from ACS variable
# code (e.g. "B01001_001") to its human-readable label, parent table title,
# and population universe.
#
# Source: the Census Bureau's ACS 5-Year Table Shells text file, kept at
# data-raw/ACS20225YR_Table_Shells.txt (build-ignored, so it does not bloat
# the installed package). The 2022 vintage labels are stable across more
# recent vintages too; refresh by replacing the source file from Census.
#
# Run with:
#   devtools::load_all(".")
#   source("data-raw/datacreate_acs_table_shells.R")
# ---------------------------------------------------------------------------- #

suppressPackageStartupMessages(library(data.table))

src <- "data-raw/ACS20225YR_Table_Shells.txt"
stopifnot(file.exists(src))

raw <- fread(src, sep = "|", header = TRUE, encoding = "UTF-8",
             check.names = TRUE)

setnames(raw,
         old = c("Table.ID", "Line", "Indent", "Unique.ID", "Label",
                 "Title", "Universe", "Type"),
         new = c("table_id", "line", "indent", "variable_id", "label",
                 "table_title", "universe", "type"))

acs_table_shells <- raw[, .(variable_id, table_id, label, table_title,
                            universe, indent, line, type)]

# Stamp provenance.
attr(acs_table_shells, "source") <-
  "Census Bureau ACS 2022 5YR Table Shells (inst/ACS20225YR_Table_Shells.txt)"
attr(acs_table_shells, "date_saved_in_package") <- as.character(Sys.Date())

usethis::use_data(acs_table_shells, overwrite = TRUE)
