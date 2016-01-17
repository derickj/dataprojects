#
# ui.R:  The user interface of the shiny app
#

#
# Load the required libraries
#

library (shiny)
library (rCharts)
# options(RCHART_WIDTH = 800)

shinyServer(
  function(input, output) {
    output$chart1 <- renderChart({
        thedata <- unidata[unidata$univ %in% input$unis,]
        thedata <- thedata[thedata$year == input$year,]
        r1 <- rPlot(perc ~ univ, color = 'race', data = thedata, type = 'bar')
        r1$guides(x = list(title = "Universities"))
        r1$guides(y = list(title = "Percentage enrollment"))
        r1$addParams(height = 300, 
                     dom = 'chart1', 
                     title = paste("Percentage of Enrollment By Race Group",input$year))
        r1
    })
    output$chart2 <- renderChart({
        thedata <- unidata[unidata$univ == input$trenduni,]
        r2 <- rPlot(perc ~ year, color = 'race', data = thedata, type = 'line')
        r2$guides(y = list(title = "Percentage enrollment"))
        r2$addParams(height = 300, 
                     dom = 'chart2', 
                     title = paste("Enrollment % Race Group Trends for ",input$trenduni))
        r2
    })
  }
)
