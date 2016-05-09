library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("HomeWrok 1.2"),
  
  tabsetPanel(
    tabPanel("Forest Fire", tableOutput('forestfires'))#,
    #tabPanel("Forest Fire", tableOutput('forestfires')),
    #tabPanel("Forest Fire", tableOutput('forestfires'))
  )

))