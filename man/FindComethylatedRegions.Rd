% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FindComethylatedRegions.R
\name{FindComethylatedRegions}
\alias{FindComethylatedRegions}
\title{Find Contiguous Co-Methylated Regions}
\usage{
FindComethylatedRegions(CpGs_df, minCpGs_int = 3)
}
\arguments{
\item{CpGs_df}{an output dataframe from function \code{MarkComethylatedCpGs},
with variables: \code{CpG, keep, ind, r_drop}. See details in documentation
for \code{\link{MarkComethylatedCpGs}}.}

\item{minCpGs_int}{an integer indicating the minimum number of CpGs for
output genomic regions}
}
\value{
A data frame with variables \code{ProbeID} and \code{Subregion}
  (index for each output contiguous comethylated region)
}
\description{
Find contiguous comethylated regions based on output file from
  function \code{MarkComethylatedCpGs}
}
\examples{
   data(betaMatrix_ex4)

   CpGs_df <- MarkComethylatedCpGs(betaCluster_mat = betaMatrix_ex4)

   FindComethylatedRegions(CpGs_df)

}
