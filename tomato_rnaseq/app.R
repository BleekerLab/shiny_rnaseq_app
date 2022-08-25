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
source("utils/extract_gene_info_from_solgenomics.R")

################
# User Interface
################
ui <- dashboardPage(
  dashboardHeader(title = "Tomato gene explorer", titleWidth = 300),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon("dashboard")),
      menuItem("Gene info", tabName = "gene_counts", icon = icon("th")),
      menuItem("About", tabName = "about", icon = icon("th")),
      menuItem("Gene values", tabName="values", icon = icon("table")),
      textInput("gene", label = "Type in your favorite gene (see the 'About' section for more info)",
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
              )
      ),
      
      # Second tab: gene information
      tabItem(tabName = "gene_counts", 
              fluidRow(
                box(title = "Gene description based on ITAG4.0 annotation", tableOutput("gene_info"))
              )
      ),
      
      # Third tab content: information about the app
      tabItem(tabName = "about", includeMarkdown("about.md")),
      
      # Fourth tab: gene scaled count values
      tabItem(tabName = "values", tableOutput("gene_values"))
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
  # Table of gene scaled count values
  output$gene_values <- renderTable({
    create_table_gene_counts(my_selected_gene = input$gene)
  })
  # Gene information (description etc.)
  output$gene_info <- renderTable({
    extract_gene_info_from_solgenomics(my_selected_gene = input$gene)
  })
}

shinyApp(ui, server)