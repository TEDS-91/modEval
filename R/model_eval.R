
#' Model evaluation.
#'
#' @param obs_values observed values.
#' @param pred_values predicted values.
#'
#' @return Data frame with the statistical metrics to perform model evaluation and comparison.
#' @export

model_eval <- function(obs_values, pred_values) {

  if(is.character(obs_values) | is.character(pred_values)){

    usethis::ui_stop("At least one of the vectors has a string element! Please check them!")}

  else if(length(obs_values) != length(pred_values)){

    usethis::ui_stop("The vectors do not have the same length! Please check them!")}

  else if(anyNA(obs_values) | anyNA(pred_values)){

    usethis::ui_stop("At least one vector has NA elements! Please check them!")

  } else {

    # general statistics
    mean_obs_values <- mean(obs_values, na.rm = TRUE)

    mean_pred_values <- mean(pred_values, na.rm = TRUE)

    var_obs_values <- stats::var(obs_values, na.rm = TRUE)

    var_pred_values <- stats::var(pred_values, na.rm = TRUE)

    # correlation analysis
    correlation <- stats::cor.test(obs_values, pred_values)

    correlation_estimate <- correlation$estimate[[1]]

    correlation_pvalue <- correlation$p.value[[1]]

    # Mean bias
    mean_bias <- mean_obs_values - mean_pred_values

    # Mean absolute error
    mae <- sum(abs(mean_obs_values - mean_pred_values)) / length(obs_values)

    # Mean absolute error
    mse <- sum((obs_values - pred_values)^2) / length(obs_values)

    # Root mean square
    rmse <- sqrt(sum((obs_values - pred_values)^2) / length(obs_values))

    # Concordance correlation coefficient
    ccc <- (2 * stats::cov(obs_values, pred_values)) / ((mean_obs_values - mean_pred_values)^2 + var_obs_values + var_pred_values)

    Cb <- 2 / ((sqrt(var_obs_values) / sqrt(var_pred_values)) + (1 / (sqrt(var_obs_values) / sqrt(var_pred_values))) + ((mean_obs_values - mean_pred_values) / sqrt(sqrt(var_obs_values) * sqrt(var_pred_values)) )^2)

    p <- ccc / Cb

    # Coefficient of model determination
    cd <- sum((obs_values - mean_obs_values)^2) / sum((pred_values - mean_obs_values)^2)

    # Modeling efficiency
    me <- 1 - sum((obs_values - pred_values)^2) / sum((obs_values - mean_obs_values)^2)

    # linear model
    linear_reg <- stats::lm(obs_values ~ pred_values)

    # calculating the coefficients
    intercept <- linear_reg$coefficients[[1]]

    slope <- linear_reg$coefficients[[2]]

    # calculating r2
    r_squared <- stats::cor(obs_values, pred_values)^2

    # calculating p-values (a = 0, b = 1) with t-test
    p_values <- summary(stats::lm(obs_values ~ 1 + pred_values + offset(pred_values)))

    # getting p-values
    intercept_pvalue <- p_values$coefficients[7]

    slope_pvalue <- p_values$coefficients[8]

    # Joint F test for beta0 = 0 beta1 = 1
    jointestF <- car::linearHypothesis(stats::lm(obs_values ~ pred_values), diag(2), c(0, 1))

    pvalueF <- jointestF[2, 6]

    # Kobayashi and Salam (2000)
    sb <- (mean_obs_values - mean_pred_values)^2

    sdsd <- (sqrt(var_obs_values) - sqrt(var_pred_values))^2

    lcs <- 2 * sqrt(var_obs_values) * sqrt(var_pred_values) * (1 - correlation_estimate)

    # proportion of each component
    sb_p <- sb / (sb + sdsd + lcs) * 100

    sdsd_p <- sdsd / (sb + sdsd + lcs) * 100

    lcs_p <- lcs / (sb + sdsd + lcs) * 100

    # model_eval outputs

    return(
      tibble::tibble(
        "Intercept"           = intercept,
        "Intercept - p-value" = intercept_pvalue,
        "Slope"               = slope,
        "Slope - p-value"     = slope_pvalue,
        "Joint F p-value"     = pvalueF,
        "r"                   = correlation_estimate,
        "r p-value"           = correlation_pvalue,
        "r2"                  = r_squared,
        "CCC"                 = ccc,
        "Cb"                  = Cb,
        "p"                   = p,
        "MB"                  = mean_bias,
        "MAE"                 = mae,
        "RMSE"                = rmse,
        "MSE"                 = mse,
        "SB (%)"              = sb_p,
        "SDSD (%)"            = sdsd_p,
        "LCS (%)"             = lcs_p,
        "CD"                  = cd,
        "ME"                  = me

      )
    )
  }
}
