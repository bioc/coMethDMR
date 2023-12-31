% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CpGsInfoAllRegions.R
\name{CpGsInfoAllRegions}
\alias{CpGsInfoAllRegions}
\title{Test Associations Between Regions and Phenotype}
\usage{
CpGsInfoAllRegions(
  AllRegionNames_char,
  allRegions_gr = NULL,
  betas_df,
  pheno_df,
  contPheno_char,
  covariates_char,
  genome = c("hg19", "hg38"),
  arrayType = c("450k", "EPIC")
)
}
\arguments{
\item{AllRegionNames_char}{vector of character strings with location info for
all the genomic regions. Each region should be specified in this format:
\code{"chrxx:xxxxxx-xxxxxx"}}

\item{allRegions_gr}{An object of class \code{\link[GenomicRanges]{GRanges}}
with location information for the regions. If this argument is NULL, then
the regions in \code{AllRegionNames_char} are used. If this argument is not
NULL, then \code{region_gr} will overwrite any supplied ranges in 
\code{AllRegionNames_char}.}

\item{betas_df}{data frame of beta values for all genomic regions, with row
names = CpG IDs amd column names = sample IDs}

\item{pheno_df}{a data frame with phenotype and covariate variables, with
variable "Sample" for sample IDs.}

\item{contPheno_char}{character string of the continuous phenotype to be
tested against methylation values}

\item{covariates_char}{character vector of covariate variables names}

\item{genome}{human genome of reference hg19 (default) or hg38}

\item{arrayType}{Type of array, can be "450k" or "EPIC"}
}
\value{
a data frame with locations of the genomic region (Region), CpG ID
   (cpg), chromosome (chr), position (pos), results for testing association
   of methylation in individual CpGs with the continuous phenotype
   (slopeEstimate, slopePval), UCSC_RefGene_Name, UCSC_RefGene_Accession,
   and UCSC_RefGene_Group
}
\description{
Test associations of individual CpGs in multiple genomic regions
  with a continuous phenotype
}
\examples{
   data(betasChr22_df)
   data(pheno_df)
   AllRegionNames_char <- c(
     "chr22:18267969-18268249",
     "chr22:18531243-18531447"
   )

   CpGsInfoAllRegions(
     AllRegionNames_char,
     betas_df = betasChr22_df,
     pheno_df = pheno_df,
     contPheno_char = "stage",
     covariates_char = c("age.brain", "sex")
   )
   
}
