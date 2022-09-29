
model_explanationUI <- function(id) {
  shiny::tagList(

    shiny::tags$p(shiny::tags$b("Intercept and Slope:"), "Regressions coefficients."),
    shiny::tags$p(shiny::tags$b("r:"), " Peearson correlation."),
    shiny::tags$p(shiny::tags$b("r2:"), "Coefficient of determination."),
    shiny::tags$p(shiny::tags$b("MB:"), "Mean bias."),
    shiny::tags$p(shiny::tags$b("MAE:"), "Mean absolute error."),
    shiny::tags$p(shiny::tags$b("MSE:"), "Mean square error."),
    shiny::tags$p(shiny::tags$b("RMSE:"), "Root mean square."),
    shiny::tags$p(shiny::tags$b("CCC:"), "Concordance correlation coefficient."),
    shiny::tags$p(shiny::tags$b("CD:"), "Coefficient of model determination."),
    shiny::tags$p(shiny::tags$b("ME:"), "Modeling efficiency."),

    shiny::br(),

    shiny::tags$p("All calculations for the metrics exposed in this application can be found by clicking ",
    shiny::tags$a(href = "https://www.sciencedirect.com/science/article/pii/S0308521X05002568", "here!"))

  )
}

model_explanationServer <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
