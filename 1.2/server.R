library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$forestfires <- renderTable(read.csv("1/forestfires.csv"))
})