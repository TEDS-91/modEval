
datatemplateUI <- function(id) {
  shiny::tagList(

    shiny::downloadButton(shiny::NS(id, "downloadBtn"), "Download Excel Template!")

  )
}

datatemplateServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$downloadBtn <- shiny::downloadHandler(

      filename = function() {
        paste("data_template.xlsx", sep = '')
      },
      content = function(file) {
        myfile <- srcpath <- 'data-raw/data_template.xlsx'
        file.copy(myfile, file)
      }
    )
  })
}
