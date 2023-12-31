#' Mark CpGs in contiguous and co-methylated region
#'
#' @param betaCluster_mat matrix of beta values, with rownames = sample ids and
#'   column names = CpG ids. Note that the CpGs need to be ordered by their
#'   genomic positions, this can be accomplished by the
#'   \code{OrderCpGbyLocation} function.
#' @param betaToM indicates if beta values should be converted to M values
#'   before computing correlations. Defaults to TRUE.
#' @param epsilon When transforming beta values to M values, what should be done
#'   to values exactly equal to 0 or 1? The M value transformation would yield
#'   \code{-Inf} or \code{Inf} which causes issues in the statistical model. We
#'    thus replace all values exactly equal to 0 with 0 + \code{epsilon}, and
#'    we replace all values exactly equal to 1 with 1 - \code{epsilon}. Defaults
#'    to \code{epsilon = 1e-08}.
#' @param rDropThresh_num threshold for minimum correlation between a cpg with
#'   the rest of the CpGs. Defaults to 0.4.
#' @param method correlation method; can be "pearson" or "spearman"
#' @param use method for handling missing values when calculating the
#'   correlation. Defaults to \code{"complete.obs"} because the option
#'   \code{"pairwise.complete.obs"} only works for Pearson correlation. 
#'
#' @return A data frame with the following columns:
#'   \itemize{
#'     \item{\code{CpG} : }{CpG ID}
#'     \item{\code{keep} : }{The CpGs with \code{keep = 1} belong to the
#'       contiguous and co-methylated region}
#'     \item{\code{ind} : }{Index for the CpGs}
#'     \item{\code{r_drop} : }{The correlation between each CpG with the sum of
#'       the rest of the CpGs}
#'   }
#'
#' @details An outlier CpG in a genomic region will typically have low
#'   correlation with the rest of the CpGs in a genomic region. On the other
#'   hand, in a cluster of co-methylated CpGs, we expect each CpG to have high
#'   correlation with the rest of the CpGs. The \code{r.drop} statistic is used
#'   to identify these co-methylated CpGs here.
#'
#' @export
#'
#' @examples
#'    data(betaMatrix_ex1)
#'    
#'    MarkComethylatedCpGs(
#'      betaCluster_mat = betaMatrix_ex1,
#'      betaToM = FALSE,
#'      method = "pearson"
#'    )
#'    
MarkComethylatedCpGs <- function(betaCluster_mat,
                                 betaToM = TRUE,
                                 epsilon = 1e-08,
                                 rDropThresh_num = 0.4,
                                 method = c("pearson", "spearman"),
                                 use = "complete.obs") {

  
  ### Calculate r_drop and Store CpGs ###
  if (!betaToM) {
    
    clusterRdrop_df <- CreateRdrop(
      data = betaCluster_mat, method = method, use = use
    )
    
  } else {
    
    # Check for beta values outside [0,1]
    badBetas <- 
      min(betaCluster_mat, na.rm = TRUE) < 0 |
        max(betaCluster_mat, na.rm = TRUE) > 1
    
    if (badBetas) {
      stop(
        "The input methylation values are not beta values; if they are M values,
      'betaToM' should be FALSE",
        call. = FALSE
      )
    }
    
    # "Fudge" beta values in {0, 1} away from boundary before transformation
    betaCluster_mat[betaCluster_mat == 0] <- 0 + epsilon
    betaCluster_mat[betaCluster_mat == 1] <- 1 - epsilon
    
    # Compute M values
    mvalues_mat <- log2(betaCluster_mat / (1 - betaCluster_mat))
    clusterRdrop_df <- CreateRdrop(
      data = mvalues_mat, method = method, use = use
    )
    
  }
  
  CpGs_char <- as.character(clusterRdrop_df$CpG)

  
  ### Drop CpGs with r.drop < threshold_r_num ###
  # drop these cpgs
  dropCpGs_char <- CpGs_char[clusterRdrop_df$r_drop < rDropThresh_num]

  ###  Create Output Data Frame  ###
  CpGs_df <- data.frame(
    CpG = clusterRdrop_df$CpG,
    keep = ifelse(CpGs_char %in% dropCpGs_char, 0, 1), ##(drop=0, keep=1)
    ind = seq_len(ncol(betaCluster_mat)),
    r_drop = clusterRdrop_df$r_drop,
    stringsAsFactors = FALSE
  )

  CpGs_df


}
