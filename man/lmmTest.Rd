% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lmmTest.R
\name{lmmTest}
\alias{lmmTest}
\title{Fit mixed model to methylation values in one genomic region}
\usage{
lmmTest(
  betaOne_df,
  pheno_df,
  contPheno_char,
  covariates_char,
  modelType = c("randCoef", "simple"),
  genome = c("hg19", "hg38"),
  arrayType = c("450k", "EPIC"),
  manifest_gr = NULL,
  ignoreStrand = TRUE,
  outLogFile = NULL
)
}
\arguments{
\item{betaOne_df}{matrix of beta values for one genomic region, with row
names = CpG IDs and column names = sample IDs}

\item{pheno_df}{a data frame with phenotype and covariates, with variable
\code{Sample} indicating sample IDs.}

\item{contPheno_char}{character string of the main effect (a continuous
phenotype) to be tested for association with methylation values in the
region}

\item{covariates_char}{character vector for names of the covariate variables}

\item{modelType}{type of mixed model: can be \code{randCoef} for random
coefficient mixed model or \code{simple} for simple linear mixed model.}

\item{genome}{Human genome of reference: hg19 or hg38}

\item{arrayType}{Type of array: "450k" or "EPIC"}

\item{manifest_gr}{A GRanges object with the genome manifest (as returned by
\code{\link[ExperimentHub]{ExperimentHub}} or by
\code{\link{ImportSesameData}}). This function by default ignores this
argument in favour of the \code{genome} and \code{arrayType} arguments.}

\item{ignoreStrand}{Whether strand can be ignored, default is TRUE}

\item{outLogFile}{Name of log file for messages of mixed model analysis}
}
\value{
A dataframe with one row for association result of one region and 
  the following columns: \code{Estimate}, \code{StdErr}, and \code{pvalue}
  showing the association of methylation values in the genomic region tested
  with the continuous phenotype supplied in \code{contPheno_char}
}
\description{
Fit mixed model to methylation values in one genomic region
}
\details{
This function implements a mixed model to test association between
  methylation M values in a genomic region with a continuous phenotype. In
  our simulation studies, we found both models shown below are conservative,
  so p-values are estimated from normal distributions instead of Student's 
  \emph{t} distributions.
  
  When \code{modelType = "randCoef"}, the model is:

  \code{M ~ contPheno_char + covariates_char + (1|Sample) + (contPheno_char|CpG)}.
  
  The last term specifies random intercept and slope for each CpG. When
  \code{modelType = "simple"}, the model is

  \code{M ~ contPheno_char + covariates_char + (1|Sample)}.
}
\examples{
  data(betasChr22_df)

  CpGsChr22_char <- c(
    "cg02953382", "cg12419862", "cg24565820", "cg04234412", "cg04824771",
    "cg09033563", "cg10150615", "cg18538332", "cg20007245", "cg23131131",
    "cg25703541"
  )

  coMethCpGs <- CoMethSingleRegion(CpGsChr22_char, betasChr22_df)

  # test only the first co-methylated region
  coMethBeta_df <- betasChr22_df[coMethCpGs$CpGsSubregions[[1]], ]

  data(pheno_df)

  res <- lmmTest(
    betaOne_df = coMethBeta_df,
    pheno_df,
    contPheno_char = "stage",
    covariates_char = c("age.brain", "sex"),
    modelType = "randCoef",
    arrayType = "450k", 
    ignoreStrand = TRUE
  )

}
