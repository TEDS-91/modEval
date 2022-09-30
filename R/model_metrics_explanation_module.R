
model_explanationUI <- function(id) {
  shiny::tagList(

    # model metrics
    shiny::tags$p(shiny::tags$b("Intercept and Slope:"),   "Regressions coefficients.",
    shiny::tags$b("Slope p-value and Intercept p-value:"), "Hipothesis test: b0 = 0 and b1 = 1.",
    shiny::tags$b("r:"),                                   "Pearson correlation.",
    shiny::tags$b("r2:"),                                  "Coefficient of determination.",
    shiny::tags$b("MB:"),                                  "Mean bias.",
    shiny::tags$b("MAE:"),                                 "Mean absolute error.",
    shiny::tags$b("MSE:"),                                 "Mean square error.",
    shiny::tags$b("RMSE:"),                                "Root mean square.",
    shiny::tags$b("CCC:"),                                 "Concordance correlation coefficient.",
    shiny::tags$b("Cb:"),                                  "CCC Accuracy.",
    shiny::tags$b("p:"),                                   "CCC Precision.",
    shiny::tags$b("CD:"),                                  "Coefficient of model determination.",
    shiny::tags$b("ME:"),                                  "Modeling efficiency.",

    shiny::tags$b("SB (%), SDSD (%), and LCS (%):"),                   "Decomposition of the MSE according to",
    shiny::tags$a(href = "https://www.sciencedirect.com/science/article/pii/S0308521X05002568", "Kobayashi and Salam (2000)"),
    shiny::tags$b("[Comparing Simulated and Measured Values Using Mean Squared Deviation and its Components].")),

    # message with reference!
    shiny::tags$p("Most of calculations for the metrics exposed in this application can be found in", shiny::tags$b("Tedeschi (2006)
                  [Assessment of the adequacy of mathematical models]"), "by clicking ",
    shiny::tags$a(href = "https://www.sciencedirect.com/science/article/pii/S0308521X05002568", "here!"))

  )
}

model_explanationServer <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
