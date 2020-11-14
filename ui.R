library(shiny)
library(ggplot2)

navbarPage("Current and predicted next week-classification of countries by UA Ministry of Health based on COVID-19 case numbers",
           tabPanel("Latest classification",
                    sidebarLayout(position = "left",
                                  sidebarPanel(dateInput("origin_date", label = "Date of origin"),),
                                  mainPanel(dataTableOutput('latest_classification_df')))
            ),
           tabPanel("Next classification", 
                    sidebarLayout(position = "left",
                                  sidebarPanel(numericInput("n_pred_days", label = "Number of latest days to use during prediction", value = 7)),
                                  mainPanel(dataTableOutput('next_classification_df'))))
)