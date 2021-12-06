## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)


source("utils/create_F2_plot.R")
source("utils/create_tissue_plot.R")

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
                box(plotOutput("plot2", height = 300)),
                box(plotOutput("plot3", height = 300))
              )
              
      ),
      
      # Second tab content
      tabItem(tabName = "data",
              h2("Widgets tab content")
      )
    )
  )
)

#############
# Server side
#############
server <- function(input, output) {
  # F2 data
  output$plot2 <- renderPlot({
    import_process_and_create_f2_plot_data(my_selected_gene = input$gene)
    })
  # Tissue plot
  output$plot3 <- renderPlot({
    create_tissue_plot(my_selected_gene = input$gene)
  })
}

shinyApp(ui, server)