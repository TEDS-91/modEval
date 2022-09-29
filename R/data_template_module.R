
datatemplateUI <- function(id) {
  shiny::tagList(

    shiny::downloadButton(shiny::NS(id, "downloadBtn"), " Download .xlsx template!")

  )
}

datatemplateServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    data_template_df <- modEval::data_template

    output$downloadBtn <- shiny::downloadHandler(
      filename = function() {
        paste("data_template", ".xlsx", sep = "")
      },
      content = function(file) {
        writexl::write_xlsx(data_template_df, file)
      }
    )

  })
}
