
datatemplateUI <- function(id) {
  shiny::tagList(

    shiny::downloadButton(shiny::NS(id, "downloadBtn"), "Download CSV Template!")

  )
}

datatemplateServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$downloadBtn <- shiny::downloadHandler(
      filename = function() {
        paste("data_template", ".csv", sep = "")
      },
      content = function(file) {
        readr::write_csv(data_template, file)
      }
    )

  })
}
