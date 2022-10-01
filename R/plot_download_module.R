plotdownloadUI <- function(id) {
  shiny::tagList(

    shiny::downloadButton(shiny::NS(id, 'downloadPlot'), 'Download plot',
                          style = "color: #fff; background-color: #007582; border-color: #007582")

  )
}

plotdownloadServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

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
  })
}
