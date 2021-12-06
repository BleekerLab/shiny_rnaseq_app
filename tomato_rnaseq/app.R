## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)


source("utils/create_F2_plot.R")

################
# User Interface
################
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard", titleWidth = 200),
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
                box(plotOutput("plot1", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              ),
              fluidRow(
                box(plotOutput("plot2", height = 300))
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
  set.seed(122)
  histdata <- rnorm(500)
  cars <- read.csv("datasets/cars.csv")
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot2 <- renderPlot({
    import_process__and_create_f2_plot_data(my_selected_gene = input$gene)
    })
}

shinyApp(ui, server)