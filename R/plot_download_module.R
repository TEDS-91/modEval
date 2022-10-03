plotdownloadUI <- function(id) {
  shiny::tagList(

    shiny::uiOutput(shiny::NS(id, "plot_download_button"))

  )
}

plotdownloadServer <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {

    # plot download button
    output$plot_download_button <- shiny::renderUI({

      shiny::validate(
        shiny::need(dataset(), " "
        )
      )

      shiny::downloadButton(shiny::NS(id, 'downloadPlot'), 'Download plot',
                            style = "color: #fff; background-color: #004E63; border-color: #004E63")

    })

    plot_downl <- shiny::reactive({

      plot_pred_obs(dataset())

    })

    output$downloadPlot <- shiny::downloadHandler(

      filename = function(){
        paste("plot_pred_vs_obs", '.png', sep = '')
        },

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
