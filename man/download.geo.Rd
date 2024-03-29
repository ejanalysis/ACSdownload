% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download.geo.R
\name{download.geo}
\alias{download.geo}
\title{Download GEO txt file(s) with geo information for ACS}
\usage{
download.geo(
  mystates,
  end.year = acsdefaultendyearhere_func(),
  folder = getwd(),
  testing = FALSE,
  attempts = 5,
  silent = FALSE
)
}
\arguments{
\item{mystates}{vector of character 2-letter State abbreviations specifying which are needed}

\item{end.year}{Specifies end year of 5-year summary file such as '2020'}

\item{folder}{folder to use for saving files - default is current working directory}

\item{testing}{Default to FALSE. If TRUE, provides info on progress of download.}

\item{attempts}{Default is 5, specifies how many tries (maximum) for unzipping before trying to redownload and then give up.}

\item{silent}{Optional, default is FALSE. Whether progress info should be sent to standard output (like the screen)}
}
\value{
Side effect is downloading the file.
}
\description{
Download text file from US Census Bureau with geographic information for American Community Survey.
 The geo file is used to join data file(s) to FIPS/GEOID/NAME/SUMLEVEL/CKEY.
 Used by \code{\link{get.acs}}
}
\details{
Downloads to the current working directory unless another folder is specified.
  In contrast to the data files, the geo file is not zipped so does not have to be unzipped once downloaded.
  Key functions used:
 \itemize{
   \item \code{\link{url.to.find.zipfile}}
   \item \code{\link{geofile}}
   \item \code{data(lookup.states, package='proxistat')}
 }
}
\examples{
 \dontrun{
   download.geo("de")
   download.geo( c("pr", "dc") )
 }
}
\seealso{
\code{\link{get.acs}} which uses this, and \code{\link{get.read.geo}}
}
