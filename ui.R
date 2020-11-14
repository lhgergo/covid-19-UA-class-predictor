library(shiny)
library(ggplot2)

dataset <- diamonds

fluidPage(
    
    titlePanel("Predicting UA categories"),
    
    sidebarPanel(
         dateInput("origin_date", label = "Date of origin")
    ),
    
    tabsetPanel(
        tabPanel("Latest classification", dataTableOutput('latest_classification_df')),
        tabPanel("Next classification", dataTableOutput('next_classification_df'))
    )
)