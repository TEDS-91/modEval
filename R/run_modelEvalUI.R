
#' Graphical Interface for Model Evaluation
#'
#' @return graphical interface where the user can upload a .XLSX file to perform
#' the model evaluation
#' @export
#'
#' @examples
run_modelEvalUI <- function() {

ui <- shiny::fluidPage(
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::fileInput("file1", "Choose a .XLSX File", accept = ".xlsx"),
      shiny::checkboxInput("header", "Header", TRUE)
    ),
    shiny::mainPanel(
      shiny::tableOutput("contents"),
      shiny::tableOutput("contents2"),
      shiny::plotOutput("grafico_res"),
      shiny::plotOutput("grafico"),
      shiny::textOutput("shapiro_test")
    )
  )
)

server <- function(input, output) {

  contents3 <- shiny::reactive({

    file <- input$file1
    ext <- tools::file_ext(file$datapath)

    shiny::req(file)
    shiny::validate(shiny::need(ext == "xlsx", "Please upload a csv file"))

    readxl::read_excel(file$datapath)

  })

  output$contents <- shiny::renderTable({

    contents3() |>
      tibble::as_tibble()

  })

  output$contents2 <- shiny::renderTable({

    observed <- contents3()[[1]]

    predicted <- contents3()[[2]]

    teste <- model_eval(obs_values  = contents3()[[1]],
                        pred_values = contents3()[[2]])

    tibble::tibble(

      "Intercept"   = teste$intercept,
      "slope"       = teste$slope,
      "R-Squared"   = teste$r_squared,
      "Correlation" = teste$correlation,
      "CCC"         = teste$ccc,
      "MAE"         = teste$mae,
      "MSE"         = teste$mse,
      "RMSE"        = teste$rmse,
      "Mean Bias"   = teste$mean_bias


    )


  })

  output$grafico <- shiny::renderPlot({

    # graphics::plot(contents3()[[2]], contents3()[[1]],
    #      xlab = "Predicted values",
    #      ylab = "Observed values",
    #      main = "Predicted vs Observed")
    # graphics::abline(a = 0, b = 1, col = "blue")

    df_cont <- contents3() |>
      tibble::as_tibble()

    df_cont |>
      tidyr::pivot_longer(
        cols = -1,
        names_to = "models",
        values_to = "predicted"
      ) |>
      dplyr::mutate(
        residuals = observed - predicted
      ) |>
      dplyr::arrange(models) |>
      dplyr::relocate(models, .before = observed) |>
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
                                             "Regression Line for Residuals" = "black")
      ) +
      ggplot2::theme(legend.position = "bottom")







  })

  output$grafico_res <- shiny::renderPlot({

    graphics::hist(contents3()[[2]] - contents3()[[1]],
         xlab = "Residuals",
         ylab = "Frequency",
         main = "Histogram of Residuals",
         col = "blue")

  })

  output$shapiro_test <- shiny::renderPrint({

    shapiro_test <- stats::shapiro.test(contents3()[[2]] - contents3()[[1]])

    pvalue_shapiro <- round(shapiro_test[[2]], 3)

    glue::glue("The p-value for normalitiy according to Shapiro-Wilks tests is:
                 {pvalue_shapiro}")

  })


}

shiny::shinyApp(ui, server)

}
