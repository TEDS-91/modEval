
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
      DT::dataTableOutput("contents2"),
      #shiny::tableOutput("contents2"),
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

  output$contents2 <- DT::renderDataTable({

    df_cont <- contents3() |>
      tibble::as_tibble()

    df_splited <- df_cont |>
      tidyr::pivot_longer(
        cols = -1,
        names_to = "models",
        values_to = "predicted"
      ) |>
      dplyr::mutate(
        residuals = observed - predicted
      ) |>
      dplyr::arrange(models) |>
      dplyr::select(-residuals) |>
      dplyr::relocate(models, .before = observed) |>
      dplyr::group_split(models)

    model_names <- df_cont |>
      tidyr::pivot_longer(
        cols = -1,
        names_to = "models",
        values_to = "predicted"
      ) |>
      dplyr::mutate(
        residuals = observed - predicted
      ) |>
      dplyr::arrange(models) |>
      dplyr::pull(models) |>
      unique()

    model_metrics <- vector("list", length(model_names))

    for ( i in 1:length(model_names)) {

      model_metrics[[i]] <- model_eval(df_splited[[i]]$observed, df_splited[[i]]$predicted)

    }

    teste <- model_metrics |>
      purrr::set_names(model_names) |>
      purrr::map_df(~ as.data.frame(.x), .id = "Models") |>
      tibble::as_tibble() |>
      dplyr::arrange(-CCC)

    DT::datatable(
      teste, extensions = c('Buttons', 'Scroller'), options = list(
        dom = 'Bfrtip',
        deferRender = TRUE,
        scrollY = 400,
        scroller = TRUE,
        buttons = c('copy', 'csv', 'excel')
      )
    )





  })

  output$grafico <- shiny::renderPlot({

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
