
#' Graphical Interface for Model Evaluation
#'
#' @return graphical interface where the user can upload a .XLSX file to perform
#' the model evaluation
#' @export
#'
#' @examples
run_modelEvalUI <- function() {

ui <- shiny::fluidPage(
  shiny::sidebarLayout(
    shiny::sidebarPanel(

    uploadUI("data_uploaded")

    ),

    shiny::mainPanel(
      dataframevizUI("dataframe_viz"),
      modelcomparisonsUI("model_comparisons"),
      predobsUI("pred_vs_obs_viz")
    )
  )
)

server <- function(input, output) {

   data_uploaded <- uploadServer("data_uploaded")

   df_viz <- dataframevizServer("dataframe_viz", dataset = data_uploaded)

   df_model_rank <- modelcomparisonsServer("model_comparisons", dataset = data_uploaded)

   model_pred_vs_obs <- predobsServer("pred_vs_obs_viz", dataset = data_uploaded)

}

shiny::shinyApp(ui, server)

}
