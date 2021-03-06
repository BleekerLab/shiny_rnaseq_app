## app.R ##
suppressPackageStartupMessages(library("periscope")) # had to be installed with devtools::install_github('cb4ds/periscope')
suppressPackageStartupMessages(library("shiny"))
suppressPackageStartupMessages(library("shinydashboard"))
suppressPackageStartupMessages(library("tidyverse"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("glue"))

source("utils/create_F2_plot.R")
source("utils/create_active_lazy_t6glands_plot.R")
source("utils/create_tissue_plot.R")
source("utils/create_20_accessions_plot.R")
source("utils/create_myc1_plot.R")

################
# User Interface
################
ui <- dashboardPage(
  dashboardHeader(title = "Tomato gene explorer", titleWidth = 300),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon("dashboard")),
      menuItem("About", tabName = "about", icon = icon("th")),
      textInput("gene", label = "Type in your favorite gene (ITAG4 annotation, see the 'About' section)",
                value = "Solyc10g075090")
      )
    ),
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "plots",
              fluidRow(
                box(status = "primary", width = 6, plotlyOutput("plot_glands")),
                box( status = "primary", width = 6, plotlyOutput("plot_tissues"))
              ),
              fluidRow(
                box(status = "success", plotlyOutput("plot_wild")),
                box(status = "success", plotlyOutput("plot_myc1"))
              ),
      ),
      
      # Second tab content
      tabItem(tabName = "about",
              includeMarkdown("about.md")
      )
    )
  )
)

#############
# Server side
#############
server <- function(input, output) {
  # F2 data
  output$plot_glands <- renderPlotly({
    import_process_and_create_gland_plot(my_selected_gene = input$gene)
    })
  # Tissue plot
  output$plot_tissues <- renderPlotly({
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