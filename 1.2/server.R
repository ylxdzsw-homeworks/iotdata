library(shiny)

forestfires <- read.csv("1/forestfires.csv")

ENB2012 <- read.xlsx("2/ENB2012_data.xlsx", 1, rowIndex = 1:769, colIndex = 1:11)

german <- read.table("3/german.data-numeric.txt")

credit <- read.csv("4/crx.data.txt", header = FALSE)

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
colnames(gps) <- c("车辆标识", "触发事件", "运营状态", "GPS时间", "GPS经度", "GPS纬度", "GPS速度", "GPS方位", "GPS状态")

shinyServer(function(input, output) {
  output$forestfires <- renderTable(forestfires)
  output$ENB2012 <- renderTable(ENB2012)
  output$german <- renderTable(german)
  output$credit <- renderTable(credit)
  output$iris <- renderTable(iris)
  output$lenses <- renderTable(lenses)
  output$gps <- renderTable(gps)
})