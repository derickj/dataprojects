library (shiny)
library (rCharts)
options(RCHART_LIB = 'polycharts')
# Define UI for dataset viewer application
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Enrollments by Race in South African Universities"),
    
    sidebarPanel(
      selectInput(inputId = "year",
                  label = "Select year to compare universities",
                  choices = unique(as.character(unidata$year)),
                  selected = unidata$year[1]),
      checkboxGroupInput(inputId = "unis", 
                         label = "Select universities to compare", 
                         choices = unique(as.character(unidata$uni)),
                         inline = TRUE),
      selectInput(inputId = "trenduni",
                  label = "Select university to view trend",
                  choices = unique(as.character(unidata$uni)),
                  selected = unidata$uni[1]),
      helpText("Select a year and more than one university to compare data, select a single university to view trends")
 #     actionButton("go", label = "Show data")
    ),
    mainPanel(
        showOutput("chart1", "polycharts"),
        showOutput("chart2", "polycharts")
    )
  )
)

