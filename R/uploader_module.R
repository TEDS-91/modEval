


uploadUI <- function(id) {
  shiny::tagList(

    shiny::fileInput(shiny::NS(id, "main_file"), "Choose a .CSV File", accept = ".csv")

  )
}

uploadServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    uploaded_data <- shiny::reactive({

      file <- input$main_file

      ext <- tools::file_ext(file$datapath)

      shiny::req(file)

      shiny::validate(shiny::need(ext == "csv", "Please upload a CSV file"))

      uploaded_data <- readr::read_csv(file$datapath, show_col_types = FALSE)

    })

    return(uploaded_data)

  })
}
