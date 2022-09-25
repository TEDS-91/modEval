
datatemplateUI <- function(id) {
  shiny::tagList(

    shiny::downloadButton(shiny::NS(id, "downloadBtn"), " Download CSV Template!")

  )
}

datatemplateServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    data_template_df <- modEval::data_template

    output$downloadBtn <- shiny::downloadHandler(
      filename = function() {
        paste("data_template", ".csv", sep = "")
      },
      content = function(file) {
        readr::write_csv(data_template_df, file)
      }
    )

  })
}
