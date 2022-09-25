
#' plot_pred_obs
#'
#' @param dataset provide a dataset to...
#'
#' @return a plot with ...
#' @export
plot_pred_obs <- function(dataset) {

   if(!is.data.frame(dataset) & !tibble::is_tibble(dataset)){

     "You have entered an object for the dataset argument of the plot_pred_obs() function that is not a data.frame or tibble."

   }else{

     dataset %>%
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
       ggplot2::geom_abline(slope = 1, intercept = 0, color = "blue") +
       ggplot2::geom_point(ggplot2::aes(x = predicted, y = residuals, color = "Residuals")) +
       ggplot2::geom_abline(slope = 0, intercept = 0, color = "black") +
       ggplot2::facet_wrap(~ models) +
       ggplot2::xlab("Predicted Values") +
       ggplot2::ylab("Observed Values") +
       ggplot2::scale_color_manual(name   = " ",
                                   breaks = c("Observed",
                                              "Regression Line (a + bx)",
                                              "Residuals",
                                              "Regression Line for Residuals"),
                                   values = c("Observed"        = "black",
                                              "Regression Line (a + bx)" = "blue",
                                              "Residuals"       = "red",
                                              "Regression Line for Residuals" = "black")) +
       ggplot2::theme(legend.position = "bottom",
                      text            = ggplot2::element_text(size = 14),
                      legend.text     = ggplot2::element_text(size = 14))

     #"You have entered an object for the dataset argument of the plot_pred_obs() function that is not a data.frame or tibble."
  }

}




