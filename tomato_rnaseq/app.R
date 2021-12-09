## app.R ##
library(shiny)
library(shinydashboard)
suppressPackageStartupMessages(library("tidyverse"))
suppressPackageStartupMessages(library("plotly"))

source("utils/create_F2_plot.R")
source("utils/create_tissue_plot.R")
source("utils/create_20_accessions_plot.R")
source("utils/create_myc1_plot.R")

################
# User Interface
################
ui <- dashboardPage(
  dashboardHeader(title = "Tomato gene explorer", titleWidth = 200),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon("dashboard")),
      menuItem("Data", tabName = "data", icon = icon("th")),
      textInput("gene", label = "Type in your favorite gene",value = "Solyc10g075090")
      )
    ),
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "plots",
              fluidRow(
                box(status = "primary", width = 6, plotOutput("plot_f2")),
                box( status = "primary", width = 6, plotOutput("plot_tissues"))
              ),
              fluidRow(
                box(status = "success", plotlyOutput("plot_wild")),
                box(status = "success", plotlyOutput("plot_myc1"))
              )
      ),
      
      # Second tab content
      tabItem(tabName = "data",
              h2("FIXME")
      )
    )
  )
)

#############
# Server side
#############
server <- function(input, output) {
  # F2 data
  output$plot_f2 <- renderPlot({
    import_process_and_create_f2_plot_data(my_selected_gene = input$gene)
    })
  # Tissue plot
  output$plot_tissues <- renderPlot({
    create_tissue_plot(my_selected_gene = input$gene)
  })
  # 20 accessions plot
  output$plot_wild <- renderPlotly({
    create_20_accessions_plot(my_selected_gene = input$gene)
  })
  # MYC1 related plot
  output$plot_myc1 <- renderPlotly({
    create_myc1_plot(my_selected_gene = input$gene)
  })
}

shinyApp(ui, server)