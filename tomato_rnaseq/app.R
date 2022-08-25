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
source("utils/create_table_of_gene_counts.R")

################
# User Interface
################
ui <- dashboardPage(
  dashboardHeader(title = "Tomato gene explorer", titleWidth = 300),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Plots", 
               tabName = "plots", 
               icon = icon("chart-bar")),
      menuItem("Gene info", 
               tabName = "gene_info", 
               icon = icon("dna")),
      menuItem("Gene values", 
               tabName="gene_values", 
               icon = icon("table")),
      menuItem("About", 
               tabName = "about", 
               icon = icon("info")),
      textInput("gene", 
                label = "Type in your favorite gene (see 'About' tab)",
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
      tabItem(tabName = "gene_info", 
              fluidRow(
                box(title = "Gene information (from Sol Genomics)", tableOutput("sol_gene_info"))
              )
      ),
      
      # Fourth tab: gene scaled counts
      tabItem(tabName = "gene_values", 
              fluidRow(
                box(title = "Scaled gene counts",
                    width = 12,
                    tableOutput("gene_values"))
              )),
      # Third tab content: information about the app
      tabItem(tabName = "about", includeMarkdown("about.md"))
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
    create_table_of_gene_counts(my_selected_gene = input$gene)
  })
  # Gene information (description etc.)
  output$sol_gene_info <- renderTable({
    extract_gene_info_from_solgenomics(my_selected_gene = input$gene)
  })
}

shinyApp(ui, server)