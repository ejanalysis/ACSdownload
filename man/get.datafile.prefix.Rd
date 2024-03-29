% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.datafile.prefix.R
\name{get.datafile.prefix}
\alias{get.datafile.prefix}
\title{Get first part of ACS datafile name.}
\usage{
get.datafile.prefix(end.year = acsdefaultendyearhere_func())
}
\arguments{
\item{end.year}{Optional character, such as "2012", specifying last year of 5-year summary file data.}
}
\description{
Get the first part of the datafile name for the ACS 5-year summary file datafiles on the US Census Bureau FTP site.
}
\seealso{
\code{\link{get.acs}}, \code{\link{datafile}}, \code{\link{geofile}}, \code{\link{get.zipfile.prefix}}
}
