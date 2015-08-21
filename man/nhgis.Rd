% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/nhgis.R
\name{nhgis}
\alias{nhgis}
\title{Read and Parse NHGIS.org ACS Data Files and Codebooks}
\usage{
nhgis(base.path = getwd(), code.dir = file.path(base.path, "nhgiscode"),
  data.dir = file.path(base.path, "nhgisdata"), silent = FALSE,
  savefiles = FALSE)
}
\arguments{
\item{base.path}{Optional base path, default is getwd()}

\item{code.dir}{Optional path where extra code is. Not used.}

\item{data.dir}{Optional path where data files are stored and output could be saved. Default is nhgiscode folder under base.path}

\item{silent}{Optional, FALSE by default, whether to print info about progress, filenames found, etc.}

\item{savefiles}{Optional, FALSE by default, whether to save .RData and maybe csv files of output returned.}
}
\value{
Returns a named list, one element per summary level found (names are, e.g., 'us', 'states', etc.).
  Each summary level has a list of the following: data, contextfields, fields, tables, geolevel, years, dataset \cr
  For example: \cr
  \code{
  summary(x[['us']]) \cr
                Length Class      Mode \cr
  data          279    data.frame list \cr
  contextfields   3    data.frame list \cr
  fields          4    data.frame list \cr
  tables          4    data.frame list \cr
  geolevel        1    -none-     character \cr
  years           1    -none-     character \cr
  dataset         1    -none-     character \cr
  }
}
\description{
Read downloaded and unzipped csv and txt files obtained from NHGIS.org,
  with US Census Bureau data from the American Community Survey (ACS).
}
\details{
This is designed to read and parse csv and txt files
  obtained from NHGIS.org and already unzipped in a local folder.
  Obtaining NHGIS.org data requires an account at
  \url{https://data2.nhgis.org/main}, \url{https://www.nhgis.org}
  Data can be downloaded by selecting, for example, \cr
  tracts and block groups, all in US, acs2007-2011, and specifying the desired ACS Table(s). \cr
  Research using NHGIS data should cite it as: \cr
  Minnesota Population Center. National Historical Geographic Information System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
}
\examples{
\\donotrun{
x <- nhgis(data.dir = '~/Desktop/nhgis0009_csv')
# Which geolevels were found (and what years)?
summary(x)
t(cbind(sapply(x, function(y) y[c('geolevel', 'years')])))
summary(x[['counties']])
# Which Census Bureau tables were found?
x[['states']]$tables
# See the data for one State
t(x[['states']]$data[1, ])
# How many counties are in each State?
dat <- x[['counties']]$data
cbind(sort(table(dat$STATE)))
# How many counties have population > 1 million, for each State?
cbind(sort(table(dat$STATE[dat$B01001.001 > 1E6])))
}
}
\seealso{
\code{\link{nhgisread}} used by this function. Also, for other ways to obtain ACS data see \code{\link{get.acs}}
}
