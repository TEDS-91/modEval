
model_explanationUI <- function(id) {
  shiny::tagList(

    shiny::tags$p(shiny::tags$b("Intercept and Slope:"), "etc"),
    shiny::tags$p(shiny::tags$b("Pearson Correlation:"), " Calculated ..."),
    shiny::tags$p(shiny::tags$b("R-squared:"), "Coefficient of determination"),
    shiny::tags$p(shiny::tags$b("MB:"), "Mean Bias: Calculated ..."),
    shiny::tags$p(shiny::tags$b("MAE:"), "MAE: Calculated ..."),
    shiny::tags$p(shiny::tags$b("MSE:"), "Mean square error"),
    shiny::tags$p(shiny::tags$b("RMSE:"), "Root mean square"),
    shiny::tags$p(shiny::tags$b("CCC:"), "Concordance correlation coefficient calcultade according to Silva et al. (1991)"),
    shiny::tags$p(shiny::tags$b("CD:"), "Coefficient of model determination"),
    shiny::tags$p(shiny::tags$b("ME:"), "Modeling efficiency"),

    shiny::br(),

    shiny::tags$p("All calculations for the metrics exposed in this application can be found by clicking ",
    shiny::tags$a(href = "https://www.sciencedirect.com/science/article/pii/S0308521X05002568", "here!"))

  )
}

model_explanationServer <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
