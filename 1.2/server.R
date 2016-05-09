library(shiny)
library(xlsx)

forestfires <- read.csv("1/forestfires.csv")
forestfires <- forestfires[sample(nrow(forestfires), 100),]

ENB2012 <- read.xlsx("2/ENB2012_data.xlsx", 1, rowIndex = 1:769, colIndex = 1:11)
ENB2012 <- ENB2012[sample(nrow(ENB2012), 100),]

german <- read.table("3/german.data-numeric.txt")
german <- german[sample(nrow(german), 100),]

credit <- read.csv("4/crx.data.txt", header = FALSE)
credit <- credit[sample(nrow(credit), 100),]

iris <- read.csv("5/iris.data.txt", header = FALSE)
colnames(iris) <- c("sl", "sw", "pl", "pw", "class")

lenses <- read.table("6/lenses.data.txt", header = FALSE)[,2:6]
colnames(lenses) <- c("class", "age", "spectacle", "astigmatic", "tpr")

gps <- rbind(
  read.csv("7/20121110035412.txt", header=FALSE, colClasses = c(NA, NA, NA, "character", NA, NA, NA, NA, NA)),
  read.csv("7/20121110035631.txt", header=FALSE, colClasses = c(NA, NA, NA, "character", NA, NA, NA, NA, NA)),
  read.csv("7/20121110035852.txt", header=FALSE, colClasses = c(NA, NA, NA, "character", NA, NA, NA, NA, NA)),
  read.csv("7/20121110040111.txt", header=FALSE, colClasses = c(NA, NA, NA, "character", NA, NA, NA, NA, NA)),
  read.csv("7/20121110040331.txt", header=FALSE, colClasses = c(NA, NA, NA, "character", NA, NA, NA, NA, NA))
)
gps <- gps[sample(nrow(gps), 100),]

shinyServer(function(input, output) {
  output$forestfires <- renderTable(forestfires)
  output$ENB2012 <- renderTable(ENB2012)
  output$german <- renderTable(german)
  output$credit <- renderTable(credit)
  output$iris <- renderTable(iris)
  output$lenses <- renderTable(lenses)
  output$gps <- renderTable(gps)
})
