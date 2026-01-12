# Specify which ACS Variables are Needed

Utility used by [`get_acs_old()`](reference/get_acs_old.md) to help user
specify which variables are needed. User can specify this in a file in
the working directory, modifying "variables needed template.csv" that
this function can create based on tables parameter, to create
user-defined "variables needed.csv"

## Usage

``` r
set.needed(
  tables,
  lookup.acs,
  vars = "all",
  varsfile,
  folder = getwd(),
  noEditOnMac = FALSE,
  end.year = acsdefaultendyearhere,
  silent = TRUE,
  writefile = TRUE
)
```

## Arguments

- tables:

  Character vector, required. Specifies which ACS tables.

- lookup.acs:

  Data.frame, optional. Defines which variables are in which tables.
  Output of [`get.lookup.acs()`](reference/get.lookup.acs.md)

- vars:

  Optional default is all, which means all fields from table unless
  varsfile specified. Specifies what variables to use from specified
  tables, and how to determine that. If varsfile is provided, vars is
  ignored (see parameter varsfile). If vars="ask", function will ask
  user about variables needed and allow specification in an interactive
  session.

- varsfile:

  Optional name of file that can be used to specify which variables are
  needed from specified tables. If varsfile is specified, parameter vars
  is ignored, and the function just looks in folder for file called
  filename, e.g., "variables needed.csv" that should specify which
  variables to keep from each table. If not found in folder, then all
  variables from each table are used (same as if vars="all" and varsfile
  not specified). The format of that file should be the same as is found
  in the file "variables needed template.csv" created by this function.
  If the filename (e.g., "variables needed.csv" file) is not found, it
  looks for and uses the file called "variables needed template.csv"
  which is written by this function and specifies all of the variables
  from each table. The column called "keep" should have an upper or
  lowercase letter Y to indicate that row (variable) should be kept.
  Blanks or other values (even the word "yes") indicate the variable is
  not needed from that data table and it will be dropped.

- folder:

  Optional path, default is getwd(), specifying where to save the csv
  files that define needed variables.

- noEditOnMac:

  FALSE by default. If TRUE, do not pause to allow edit() when on Mac
  OSX, even if vars=TRUE. Allows you to avoid problem in RStudio if X11
  not installed.

- end.year:

  Optional, – specifies last year of 5-year summary file that is being
  used.

- silent:

  Optional, defaults to TRUE. If FALSE, prints some indications of
  progress.

- writefile:

  Optional, defaults to TRUE. If TRUE, saves template of needed
  variables as "variables needed template.csv" file to folder.

## Value

Returns data.frame of info on which variables are needed from each
table, much like annotated version of lookup.acs.

## See also

[`get_acs_old()`](reference/get_acs_old.md) which uses this
