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
                box(plotOutput("plot2", height = 250))
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
    p <- import_process__and_create_f2_plot_data()
    p
    # new_genotype_levels = c("Elite_2017",
    #                         "Elite_2020",
    #                         "F1",     
    #                         "PI127826_2020",
    #                         "PI127826_2017",
    #                         "F2-28",
    #                         "F2-73",
    #                         "F2-127",
    #                         "F2-151",
    #                         "F2-411",
    #                         "F2-445")
    # df <- read.csv("datasets/F2.csv", stringsAsFactors = FALSE, check.names = FALSE) %>% 
    #   mutate(genotype = factor(genotype, levels = new_genotype_levels))
    # df_filtered <- dplyr::filter(.data = df, grepl(pattern = input$gene, x = gene))
    # ggplot(df_filtered, aes(x = genotype, y = counts, col = genotype)) + 
    #   geom_point(size = 3) + 
    #   scale_fill_brewer(type = "qual", palette = 3) +
    #   coord_flip() +
    #   labs("Genotypes (From the Elite x PI127826 cross")
  })
}

shinyApp(ui, server)