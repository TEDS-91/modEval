
#' Plots predicted versus observed values with some additional statistics.
#'
#' @param dataset with observed and predicted values from one or more models. The first column of these data frame MUST be named as observed.
#'
#' @return a plot with predicted vs observed values, in addition to another statistical features.
#' @export
plot_pred_obs <- function(dataset) {

   if(!is.data.frame(dataset) & !tibble::is_tibble(dataset)) {

      usethis::ui_stop("You have entered an object for the dataset argument of the plot_pred_obs() function that is not a data.frame or tibble.")

   } else if (any(sapply(dataset, is.factor) == TRUE) | any(sapply(dataset, is.character) == TRUE)) {

      usethis::ui_stop("Your dataset contains factors or characters! Please upload a dataset with just numerical columns.")

   } else {

     plot_p <- dataset %>%
       dplyr::rename("observed" = names(dataset)[1]) %>%
       tidyr::pivot_longer(
         cols = -1,
         names_to = "models",
         values_to = "predicted"
       ) %>%
       dplyr::mutate(
         residuals = observed - predicted
       ) %>%
       dplyr::arrange(models) %>%
       dplyr::relocate(models, .before = observed) %>%
       ggplot2::ggplot() +
       ggplot2::theme_bw() +
       ggplot2::geom_point(ggplot2::aes(x = predicted, y = observed, color = "Observed")) +
       ggplot2::geom_abline(slope = 1, intercept = 0, color = "blue", linetype = "dashed") +
       ggplot2::geom_smooth(ggplot2::aes(x = predicted, y = observed, color = "Fitted"), method = 'lm',
                            se = FALSE, size = 1) +
       ggplot2::geom_point(ggplot2::aes(x = predicted, y = residuals, color = "Residuals")) +
       ggplot2::geom_abline(slope = 0, intercept = 0, color = "black", linetype = "dashed") +
         ggplot2::geom_smooth(ggplot2::aes(x = predicted, y = residuals, color = "Regression line for residuals"), method = 'lm',
                              se = FALSE, size = 1) +
       ggplot2::facet_wrap(~ models) +
       ggplot2::xlab("Predicted Values") +
       ggplot2::ylab("Observed Values") +
       ggplot2::scale_color_manual(name   = " ",
                                   breaks = c("Observed",
                                              "Regression line",
                                              "Fitted",
                                              "Residuals",
                                              "Zero Line Residuals",
                                              "Regression line for residuals"),
                                   values = c("Observed"                          = "grey",
                                              "Regression line"                   = "blue",
                                              "Fitted"                            = "black",
                                              "Residuals"                         = "orange",
                                              "Zero line residuals"               = "black",
                                              "Regression line for residuals"     = "blue")) +
       ggplot2::theme(legend.position = "bottom",
                      text            = ggplot2::element_text(size = 11),
                      legend.text     = ggplot2::element_text(size = 9))

     plot_p

  }
}




