
#' Graphical Interface for Model Evaluation
#'
#' @return graphical interface where the user must upload a .xlsx file to perform
#' the model evaluation. There is no parameters for this function.
#' @export
model_eval_ui <- function() {

ui <- shiny::fluidPage(
  shinythemes::shinytheme("flatly"),
    shiny::titlePanel(shiny::h2(shiny::strong("Model Evaluation (modEval) Package", style = "color: #007582"))),
      shiny::sidebarLayout(
        shiny::sidebarPanel(

          uploadUI("data_uploaded"),

          datatemplateUI("template"),

        width = 3),

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
                          plotdownloadUI("downl_plot"),
                          shiny::hr(),
                          predobsUI("pred_vs_obs_viz"))
      ), width = 9)
  )
)

server <- function(input, output) {

   # running the template module
   datatemplateServer("template")

   # running the upload module
   data_uploaded <- uploadServer("data_uploaded")

   # running the dataframeviz module
   df_viz <- dataframevizServer("dataframe_viz", dataset = data_uploaded)

   # running the model comparisons module
   df_model_rank <- modelcomparisonsServer("model_comparisons", dataset = data_uploaded)

   # running the plot predobs module
   predobsServer("pred_vs_obs_viz", dataset = data_uploaded)

   # running the plot download module
   plotdownloadServer("downl_plot", dataset = data_uploaded)

}

shiny::shinyApp(ui, server)

}
