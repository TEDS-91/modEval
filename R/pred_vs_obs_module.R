
predobsUI <- function(id) {
  shiny::tagList(

  shiny::downloadButton(shiny::NS(id, 'downloadPlot'), 'Download plot'),
  plotly::plotlyOutput(shiny::NS(id, "pred_vs_obs_viz"))

  )
}

predobsServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    output$pred_vs_obs_viz <- plotly::renderPlotly({

      plotly::ggplotly(plot_pred_obs(dataset()), height = 700, width = 1000) %>%
      plotly::layout(legend = list(orientation = "h", x = 0.4, y = -0.2))

    } )

    plot_downl <- shiny::reactive({

      plot_pred_obs(dataset())

    })

    output$downloadPlot <- shiny::downloadHandler(

      filename = function(){paste("Plot_Pred_vs_Obs", '.png', sep = '')},

      content = function(plot_d){
        ggplot2::ggsave(plot_d,
                        plot_downl(),
                        width  = 10,
                        height = 6,
                        dpi    = 300,
                        units  = "in")

    }
   )
  }
 )
}
