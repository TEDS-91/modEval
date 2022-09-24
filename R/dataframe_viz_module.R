



dataframevizUI <- function(id) {
  shiny::tagList(

    DT::dataTableOutput(shiny::NS(id, "dataframe_uploaded"))

  )
}

dataframevizServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$dataframe_uploaded <- DT::renderDataTable({

      dataset() %>%
        tibble::as_tibble() %>%
        dplyr::mutate(dplyr::across(where(is.numeric), round, digits = 3)) %>%
        DT::datatable(
        options = list(
            columnDefs = list(list(className = 'dt-center', targets = 5)),
            pageLength = 5,
            lengthMenu = c(5, 10, 15, 20)
          )
      )

    })
  })
}
