

uploadUI <- function(id) {
  shiny::tagList(

    shiny::fileInput(shiny::NS(id, "main_file"), "Choose a .xlsx File", accept = ".xlsx")

  )
}

uploadServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    uploaded_data <- shiny::reactive({

      file <- input$main_file

      ext <- tools::file_ext(file$datapath)

      shiny::req(file)

      shiny::validate(shiny::need(ext == "xlsx", "Please upload a XLSX file"))

      uploaded_data <- readxl::read_excel(file$datapath)

    })

    return(uploaded_data)

  })
}
