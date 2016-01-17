#
# ui.R:  The user interface of the shiny app
#

#
# Load the required libraries
#
library (shiny)
library (rCharts)
require (markdown)
options(RCHART_LIB = 'polycharts')

# Define UI for dataset viewer application
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Enrollments by Race in South African Universities"),

    # Sidebar panel selects variables used in the server to display data    
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
      helpText("Select a year and more than one university to compare data, select a single university to view trends, select Instructions tab for more")
    ),
# Main panel contains two tabs - one with data (plots) and the other with the README (intrsuctions to use)
    mainPanel(
      tabsetPanel(
        tabPanel("Plots",  
                 showOutput("chart1", "polycharts"),
                 showOutput("chart2", "polycharts")),
        tabPanel("Instructions", includeMarkdown("README.md"))
      )
    )
  )
)
