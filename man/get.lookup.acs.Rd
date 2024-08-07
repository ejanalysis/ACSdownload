% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.lookup.acs.R
\name{get.lookup.acs}
\alias{get.lookup.acs}
\title{Pick a year-specific table from among lookup.acs2022, etc.}
\usage{
get.lookup.acs(end.year = acsdefaultendyearhere_func())
}
\arguments{
\item{end.year}{Character, optional, like "2020", which specifies the 2016-2020 dataset.
Defines which 5-year summary file to use, based on end-year.
Note: Function stops with error if given end.year is not yet added to this package or is too old.}
}
\value{
returns a data.frame
}
\description{
Pick a year-specific lookup table of information on American Community Survey (ACS) tables, from the Census Bureau,
namely which sequence files on the FTP site contain which tables and which variables.
}
\examples{
 names(lookup.acs2022)
 names(lookup.acs)

}
\seealso{
\code{\link[=get.table.info]{get.table.info()}} and \code{\link[=get.field.info]{get.field.info()}}. \cr
Also see \code{\link[acs:acs.lookup]{acs::acs.lookup()}} which does something similar but is more flexible & robust.
Also see \code{\link[=download.lookup.acs]{download.lookup.acs()}} to download the file from the Census FTP site.
Also see \link{lookup.acs} \link{lookup.acs2022} and similar data for other years.
Also see \code{\link[=get.acs]{get.acs()}}, \code{\link[=get.lookup.file.name]{get.lookup.file.name()}}, \code{\link[=get.url.prefix.lookup.table]{get.url.prefix.lookup.table()}}
\code{\link[tidycensus:load_variables]{tidycensus::load_variables()}}
}
