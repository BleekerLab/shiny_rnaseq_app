#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title = "Tomato RNA-seq gene explorer"),
    dashboardSidebar(),
    dashboardBody(
        fluidRow(
            box(title = "20 accessions dataset", plotOutput("plot1", height = 250))),
        fluidRow(
            box(title = "Controls", sliderInput("slider", "Number of observations:", 1, 100, 50)))
    )
)
