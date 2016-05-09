library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("HomeWrok 1.2"),
  
  tabsetPanel(
    tabPanel("Forest Fire", tableOutput('forestfires')),
    tabPanel("ENB2012", tableOutput('ENB2012')),
    tabPanel("German Credit", tableOutput('german')),
    tabPanel("Credit Approval", tableOutput('credit')),
    tabPanel("Iris", tableOutput('iris')),
    tabPanel("Lenses", tableOutput('lenses')),
    tabPanel("GPS", tableOutput('gps'))
  )

))