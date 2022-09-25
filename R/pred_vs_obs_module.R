predobsUI <- function(id) {
  shiny::tagList(

  shiny::plotOutput(shiny::NS(id, "pred_vs_obs_viz"))

  )
}

predobsServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$pred_vs_obs_viz <- shiny::renderPlot({

      plot_pred_obs(dataset())

    }, height = 700, width = 900)

  })
}
