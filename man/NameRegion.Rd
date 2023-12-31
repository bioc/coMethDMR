% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util2_NameRegion.R
\name{NameRegion}
\alias{NameRegion}
\title{Name a region with several CpGs based on its genomic location}
\usage{
NameRegion(CpGsOrdered_df)
}
\arguments{
\item{CpGsOrdered_df}{dataframe with columns for Probe IDs as character
(cpg), chromosome number as character (chr), and genomic location as
integer (pos)}
}
\value{
genome location of the CpGs formatted as \code{"chrxx:xxxxxx-xxxxxx"}
}
\description{
Name a region with several CpGs based on its genomic location
}
\examples{
 # Consider four probe IDs:
 CpGs_char <- c("cg04677227", "cg07146435", "cg11632906", "cg20214853")
 
 # After querying these four probes against an EPIC array via the 
 #   OrderCpGsByLocation() function, we get the following data frame:
 CpGsOrdered_df <- data.frame(
   chr = c("chr10", "chr10", "chr10", "chr10"),
   pos = c(100028236L, 100028320L, 100028468L, 100028499L),
   cpg = c("cg20214853", "cg04677227", "cg11632906", "cg07146435"),
   stringsAsFactors = FALSE
 )

 # Now, we can name the region that contains these four probes:
 NameRegion(CpGsOrdered_df)

}
