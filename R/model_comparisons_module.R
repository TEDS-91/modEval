
modelcomparisonsUI <- function(id) {
  shiny::tagList(

    DT::dataTableOutput(shiny::NS(id, "model_comparisons")),

    shiny::br(),

    model_explanationUI(shiny::NS(id, "model_metrics_explanation"))

  )
}

modelcomparisonsServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$model_comparisons <- DT::renderDataTable({

      # renaming the first column
      df <- dataset() %>%
        tibble::as_tibble() %>%
        dplyr::rename("observed" = names(dataset()[1]))

      # pivotting the dataset
      df_splited <- df %>%
        tidyr::pivot_longer(
          cols = -1,
          names_to = "models",
          values_to = "predicted"
        ) %>%
        dplyr::mutate(
          residuals = observed - predicted
        ) %>%
        dplyr::arrange(models) %>%
        dplyr::select(-residuals) %>%
        dplyr::relocate(models, .before = observed) %>%
        dplyr::group_split(models)

      # getting the model names
      model_names <- df %>%
        tidyr::pivot_longer(
          cols = -1,
          names_to = "models",
          values_to = "predicted"
        ) %>%
        dplyr::mutate(
          residuals = observed - predicted
        ) %>%
        dplyr::arrange(models) %>%
        dplyr::pull(models) %>%
        unique()

      # calculating the model metrics
      model_metrics <- vector("list", length(model_names))

      for ( i in 1:length(model_names)) {

        model_metrics[[i]] <- model_eval(df_splited[[i]]$observed, df_splited[[i]]$predicted)

      }

      # model metrics/outcomes
      model_eval_outcomes <- model_metrics %>%
        purrr::set_names(model_names) %>%
        purrr::map_df(~ as.data.frame(.x), .id = "Models") %>%
        tibble::as_tibble() %>%
        dplyr::mutate(dplyr::across(where(is.numeric), round, digits = 3)) %>%
        dplyr::arrange(-CCC) %>%
        tidyr::pivot_longer(
          cols = c(-Models),
          names_to = "Metrics"
        ) %>%
        tidyr::pivot_wider(names_from = c(Models))

      # creating the datatable
      DT::datatable(
        model_eval_outcomes,
        extensions = c('Buttons', 'Scroller'),
        options = list(
          dom          = 'Bfrtip',
          columnDefs   = list(list(className = 'dt-center', targets = 5)),
          pageLength   = 20,
          lengthMenu   = c(5, 10, 20, 40),
          buttons      = c('copy', 'csv', 'excel'),
          initComplete = DT::JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#16A085', 'color': '#FDFEFE'});",
            "}")
        )
      )
    })
  })
}
