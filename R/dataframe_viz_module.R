



dataframevizUI <- function(id) {
  shiny::tagList(
    shiny::tableOutput(shiny::NS(id, "dataframe_uploaded"))
  )
}

dataframevizServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$dataframe_uploaded <- shiny::renderTable({

      dataset() %>%
        tibble::as_tibble()

    })

  })
}
