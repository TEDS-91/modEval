

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

    ccc <- (2 * stats::cov(obs_values, pred_values)) / ((mean_obs_values - mean_pred_values)^2 + var_obs_values + var_pred_values)

    mae <- sum(abs(mean_obs_values - mean_pred_values)) / length(obs_values)

    mse <- sum((obs_values - pred_values)^2) / length(obs_values)

    rmse <- sqrt(sum((obs_values - pred_values)^2) / length(obs_values))

    linear_reg <- stats::lm(obs_values ~ pred_values)

    intercept <- linear_reg$coefficients[[1]]

    slope <- linear_reg$coefficients[[2]]

    r_squared <- stats::cor(obs_values, pred_values)^2

    return(
      list(
        "intercept"   = intercept,
        "slope"       = slope,
        "r_squared"   = r_squared,
        "correlation" = correlation,
        "mean_bias"   = mean_bias,
        "mae"         = mae,
        "mse"         = mse,
        "rmse"        = rmse,
        "ccc"         = ccc
      )

    )

  }

}
