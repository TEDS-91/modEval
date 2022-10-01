
predobsUI <- function(id) {
  shiny::tagList(

  plotly::plotlyOutput(shiny::NS(id, "pred_vs_obs_viz"))

  )
}

predobsServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$pred_vs_obs_viz <- plotly::renderPlotly({

      plotly::ggplotly(plot_pred_obs(dataset()), height = 700, width = 1000) %>%
      plotly::layout(legend = list(orientation = "h", x = 0.4, y = -0.2))

    })
  }
 )
}
