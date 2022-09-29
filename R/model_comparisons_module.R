
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

      df <- dataset() %>%
        tibble::as_tibble() %>%
        dplyr::rename("observed" = names(dataset()[1]))

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

      model_metrics <- vector("list", length(model_names))

      for ( i in 1:length(model_names)) {

        model_metrics[[i]] <- model_eval(df_splited[[i]]$observed, df_splited[[i]]$predicted)

      }

      model_eval_outcomes <- model_metrics %>%
        purrr::set_names(model_names) %>%
        purrr::map_df(~ as.data.frame(.x), .id = "Models") %>%
        tibble::as_tibble() %>%
        dplyr::mutate(dplyr::across(where(is.numeric), round, digits = 3)) %>%
        dplyr::arrange(-CCC)

      DT::datatable(
        model_eval_outcomes,
        extensions = c('Buttons', 'Scroller'),
        options = list(
          dom         = 'Bfrtip',
          pageLength  = 20,
          scrollY     = TRUE,
          scrollY     = TRUE,
          scroller    = TRUE,
          autoWidth   = TRUE,
          columnDefs = list(list(width = '200px', targets = "_all")),
          buttons     = c('copy', 'csv', 'excel'),
          initComplete = DT::JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#16A085', 'color': '#FDFEFE'});",
            "}")
        )
      )
    })
  })
}
