require(shiny)
require(rCharts)
# options(RCHART_WIDTH = 800)
require(reshape2)
require(RCurl)

#url <- "https://docs.google.com/spreadsheets/d/14EbD832LcfKEI2y4QIEJq8mvmkiVtFWNNPF3AEJap0Q/pub?output=csv"
datafile <- "data.csv"
#download.file(url, datafile, quiet = TRUE)
if(!file.exists(datafile))
{
  msg <- paste ("File could not be downloaded via url: ", url, sep = " ")
  stop (msg)
}

cname <- read.table (datafile, sep = ',', skip = 7, nrow = 1, stringsAsFactors = FALSE)
cname[1] <- "univ"
cname[2] <- "race"
cname[3:15] <- as.character(cname[3:15])
unidata <- read.table ("06 - enrolments by race group.csv", sep = ',', strip.white = TRUE, skip = 8, col.names = cname[1,], check.names = FALSE, stringsAsFactors = FALSE)
unidata <- unidata [1:nrow(unidata)-1,]
unidata[,1] <- as.factor(unidata[,1])
unidata[,2] <- as.factor(unidata[,2])
for (i in 3:15) {
  unidata[,i] <- as.integer(gsub("%","",unidata[,i]))
}
unidata <- melt(unidata,id.vars=c("univ","race"),measure.vars=cname[3:15], variable.name ="year", value.name ="perc")

shinyServer(
  function(input, output) {
  output$year <- renderPrint({ 
      input$year })
    output$unis <- renderPrint({ 
      if (input$go > 0)
      { input$unis }
      else "Not yet"})
    output$chart1 <- renderChart({
#     if (input$go > 0)
#    {
        thedata <- unidata[unidata$univ %in% input$unis,]
        thedata <- thedata[thedata$year == input$year,]
        r1 <- rPlot(perc ~ univ, color = 'race', data = thedata, type = 'bar')
        r1$guides(x = list(title = "Universities"))
        r1$guides(y = list(title = "Percentage enrollment"))
        r1$addParams(height = 300, 
                     dom = 'chart1', 
                     title = "Percentage of Enrollment By Race Group")
#    } 
#    else 
#      r1 <- Polycharts$new()
    r1
  })
    output$chart2 <- renderChart({
#      if (input$go > 0)
#      {
        thedata <- unidata[unidata$univ == input$trenduni,]
        r2 <- rPlot(perc ~ year, color = 'race', data = thedata, type = 'line')
        r2$guides(y = list(title = "Percentage enrollment"))
        r2$addParams(height = 300, 
                     dom = 'chart2', 
                     title = paste("Enrollment % Race Group Trends for ",input$trenduni))
#     } 
#      else 
#        r2 <- Polycharts$new()
      r2
    })
  }
)
