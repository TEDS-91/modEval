test_that("model_eval works", {

  # Hope this does not work

  # checking for the type of output (class)
  expect_error(plot_pred_obs(matrix(2, 3)))

  # checking columns with strings
  expect_error(plot_pred_obs(data.frame(observed = c("a", 2), predicted = c(1, 2))))

})
