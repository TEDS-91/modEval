
#' Graphical Interface for Model Evaluation
#'
#' @return graphical interface where the user can upload a .XLSX file to perform
#' the model evaluation
#' @export
run_modelEvalUI <- function() {

ui <- shiny::fluidPage(
  shinythemes::shinytheme("flatly"),
    shiny::titlePanel(shiny::h2(shiny::strong("Model Evaluation Tool", style = "color: #007582"))),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          uploadUI("data_uploaded"),
        width = 4),

    shiny::mainPanel(
      shiny::tabsetPanel(type = "tabs",
          shiny::tabPanel("Uploaded dataset",
                          shiny::hr(),
                          dataframevizUI("dataframe_viz")),
          shiny::tabPanel("Model Metrics",
                          shiny::hr(),
                          modelcomparisonsUI("model_comparisons")),
          shiny::tabPanel("Predicted vs Observed Plots",
                          shiny::hr(),
                          predobsUI("pred_vs_obs_viz"))
      ), width = 8)
  )
)

server <- function(input, output) {

   data_uploaded <- uploadServer("data_uploaded")

   df_viz <- dataframevizServer("dataframe_viz", dataset = data_uploaded)

   df_model_rank <- modelcomparisonsServer("model_comparisons", dataset = data_uploaded)

   predobsServer("pred_vs_obs_viz", dataset = data_uploaded)

}

shiny::shinyApp(ui, server)

}
