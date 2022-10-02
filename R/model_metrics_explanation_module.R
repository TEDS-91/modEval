
model_explanationUI <- function(id) {

  shiny::tagList(

    shiny::hr(),

    shiny::tags$b("Model Metrics Description"),

    # model metrics
    shiny::tags$p(shiny::tags$b("Intercept and Slope:"),    "regressions coefficients obtained using the least squares method.",

    shiny::tags$b("Slope and Intercept p-values:"),         "p-values obtained using T test for the coefficients under the hypothesis: \u03B2", shiny::tags$sub("0"), "= 0 and \u03B2", shiny::tags$sub("1"),"= 1.",

    shiny::tags$b("Joint F p-value:"),                      "linear hypothesis F test: \u03B2", shiny::tags$sub("0"), "= 0 and \u03B2", shiny::tags$sub("1"), " = 1.",

    shiny::tags$b("r:"),                                    "Pearson's correlation coefficient.",

    shiny::tags$b("r p-value:"),                            "Pearson's correlation coefficient p-value.",

    shiny::tags$b("r2:"),                                   "coefficient of determination.",

    shiny::tags$b("CCC:"),                                  "concordance correlation coefficient.",

    shiny::tags$b("Cb:"),                                   "CCC accuracy.",

    shiny::tags$b("p:"),                                    "CCC precision.",

    shiny::tags$b("MB:"),                                   "mean bias.",

    shiny::tags$b("MAE:"),                                  "mean absolute error.",

    shiny::tags$b("RMSE:"),                                 "root mean square.",

    shiny::tags$b("MSE:"),                                  "mean square error.",
    shiny::tags$b("SB (%), SDSD (%), and LCS (%):"),        "decomposition of the MSE according to",
    shiny::tags$a(href = "https://www.sciencedirect.com/science/article/pii/S0308521X05002568", "Kobayashi and Salam (2000)"),
    shiny::tags$em("[Comparing Simulated and Measured Values Using Mean Squared Deviation and its Components]."),

    shiny::tags$b("CD:"),                                   "coefficient of model determination.",

    shiny::tags$b("ME:"),                                   "modeling efficiency.", "."),

    # message with reference!
    shiny::tags$p("Most of calculations for the metrics exposed in this application can be found in",
                  shiny::tags$a(href = "https://www.sciencedirect.com/science/article/pii/S0308521X05002568", "Tedeschi (2006)"),
    shiny::tags$em("[Assessment of the adequacy of mathematical models]"), ".")

  )
}

model_explanationServer <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
