% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/clean.mystates.R
\name{clean.mystates}
\alias{clean.mystates}
\title{Utility to Clean Names of States for get.acs}
\usage{
clean.mystates(mystates, testing = FALSE)
}
\arguments{
\item{mystates}{Character vector, required. Defines which states, using 2-character abbreviations (case-insensitive), or 'all' for all available.}

\item{testing}{Logical value, optional, FALSE by default. LIMITS STATES TO DC AND DE if TRUE.}
}
\value{
Returns character vector of 2-character State abbreviations. Default is 50 States plus DC and PR and US total.
}
\description{
Utility function used by \code{\link{get.acs}}
}
\details{
Not in FTP ACS Summary files: \cr
 #53         60 AS              American Samoa               <NA>\cr
 #54         66 GU                        Guam               <NA>\cr
 #55         69 MP    Northern Mariana Islands               <NA>\cr
 #57         74 UM U.S. Minor Outlying Islands               <NA>\cr
 #58         78 VI         U.S. Virgin Islands               <NA>\cr
}
\seealso{
\code{\link{get.acs}} which uses this, and \code{data(lookup.states, package=proxistat)} using \pkg{proxistat} package
}
