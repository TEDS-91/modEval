


modelcomparisonsUI <- function(id) {
  shiny::tagList(

    DT::dataTableOutput(shiny::NS(id, "model_comparisons"))

  )
}

modelcomparisonsServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$model_comparisons <- DT::renderDataTable({

      df_cont <- dataset() %>%
        tibble::as_tibble()

      df_splited <- df_cont %>%
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

      model_names <- df_cont %>%
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
        dplyr::mutate(dplyr::across(where(is.numeric), round, digits = 2)) %>%
        dplyr::arrange(-CCC)

      DT::datatable(
        model_eval_outcomes,
        extensions = c('Buttons', 'Scroller'),
        options = list(
          dom = 'Bfrtip',
          deferRender = TRUE,
          scrollY = 400,
          scroller = TRUE,
          buttons = c('copy', 'csv', 'excel')
        )
      )

    })

  })
}
