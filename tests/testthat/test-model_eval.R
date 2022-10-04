test_that("plot_pred_obs works", {

  # Hope this works

  # checking type of output (class)
  expect_equal(is.data.frame(model_eval(obs_values = data_template$observed, pred_values = data_template$`Reduced Model 1`)), TRUE)

  # Hope this does not work
  # checking vectors with different lengths
  expect_error(model_eval(obs_values = rnorm(10), pred_values = rnorm(9)))

  # checking vectors with strings
  expect_error(model_eval(obs_values = rnorm(10), pred_values = c("a", rnorm(9))))

  # checking vectors with NA
  expect_error(model_eval(obs_values = rnorm(10), pred_values = c(NA, rnorm(9))))

})
