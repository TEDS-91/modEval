
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

    mean_obs_values <- mean(obs_values, na.rm = TRUE)

    mean_pred_values <- mean(pred_values, na.rm = TRUE)

    var_obs_values <- stats::var(obs_values, na.rm = TRUE)

    var_pred_values <- stats::var(pred_values, na.rm = TRUE)

    mean_bias <- mean_obs_values - mean_pred_values

    correlation <- stats::cor(obs_values, pred_values)

    # Mean absolute error
    mae <- sum(abs(mean_obs_values - mean_pred_values)) / length(obs_values)

    # Mean absolute error
    mse <- sum((obs_values - pred_values)^2) / length(obs_values)

    # Root mean square
    rmse <- sqrt(sum((obs_values - pred_values)^2) / length(obs_values))

    # Concordance correlation coefficient
    ccc <- (2 * stats::cov(obs_values, pred_values)) / ((mean_obs_values - mean_pred_values)^2 + var_obs_values + var_pred_values)

    # Coefficient of model determination
    cd <- sum((obs_values - mean_obs_values)^2) / sum((pred_values - mean_obs_values)^2)

    # Modeling efficiency
    me <- 1 - sum((obs_values - pred_values)^2) / sum((obs_values - mean_obs_values)^2)

    # linear model
    linear_reg <- stats::lm(obs_values ~ pred_values)

    # getting the coefficients
    intercept <- linear_reg$coefficients[[1]]

    slope <- linear_reg$coefficients[[2]]

    # getting r-squared
    r_squared <- stats::cor(obs_values, pred_values)^2

    # calculating p-values (a = 0, b = 1)
    p_values <- summary(stats::lm(obs_values ~ 1 + pred_values + offset(pred_values)))

    # getting p-values
    intercept_pvalue <- p_values$coefficients[7]

    slope_pvalue <- p_values$coefficients[8]

    return(
      tibble::tibble(
        "Intercept"           = intercept,
        "Intercept - p-value" = intercept_pvalue,
        "Slope"               = slope,
        "Slope - p-value"     = slope_pvalue,
        "r"                   = correlation,
        "r2"                  = r_squared,
        "MB"                  = mean_bias,
        "MAE"                 = mae,
        "MSE"                 = mse,
        "RMSE"                = rmse,
        "CCC"                 = ccc,
        "CD"                  = cd,
        "ME"                  = me
      )
    )
  }
}
