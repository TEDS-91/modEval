
#' model_eval
#'
#' @param obs_values observed values.
#' @param pred_values predicted values.
#'
#' @return list with the main statistics
#' @export

model_eval <- function(obs_values, pred_values) {

  if(is.character(obs_values) | is.character(pred_values)){

    "At least one of the vectors has a string element! Please check them!"}

  else if(length(obs_values) != length(pred_values)){

    "The vectors do not have the same length! Please check them!"}

  else if(anyNA(obs_values) | anyNA(pred_values)){

    "At least one vector has NA element! Please check them!"

  } else {

    mean_obs_values <- mean(obs_values, na.rm = TRUE)

    mean_pred_values <- mean(pred_values, na.rm = TRUE)

    var_obs_values <- stats::var(obs_values, na.rm = TRUE)

    var_pred_values <- stats::var(pred_values, na.rm = TRUE)

    mean_bias <- mean_obs_values - mean_pred_values

    correlation <- stats::cor(obs_values, pred_values)

    mae <- sum(abs(mean_obs_values - mean_pred_values)) / length(obs_values)

    mse <- sum((obs_values - pred_values)^2) / length(obs_values)

    rmse <- sqrt(sum((obs_values - pred_values)^2) / length(obs_values))

    ccc <- (2 * stats::cov(obs_values, pred_values)) / ((mean_obs_values - mean_pred_values)^2 + var_obs_values + var_pred_values)

    cd <- sum((obs_values - mean_obs_values)^2) / sum((pred_values - mean_obs_values)^2)

    me <- 1 - sum((obs_values - pred_values)^2) / sum((obs_values - mean_obs_values)^2)

    linear_reg <- stats::lm(obs_values ~ pred_values)

    intercept <- linear_reg$coefficients[[1]]

    slope <- linear_reg$coefficients[[2]]

    r_squared <- stats::cor(obs_values, pred_values)^2

    return(
      tibble::tibble(
        "Intercept"          = intercept,
        "Slope"              = slope,
        "R-squared"          = r_squared,
        "Peason Correlation" = correlation,
        "Mean Bias"          = mean_bias,
        "MAE"                = mae,
        "MSE"                = mse,
        "RMSE"               = rmse,
        "CCC"                = ccc,
        "CD"                 = cd,
        "ME"                 = me
      )

    )

  }

}
