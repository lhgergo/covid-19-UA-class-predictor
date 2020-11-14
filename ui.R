library(shiny)
library(ggplot2)
readme <- readLines("main_readme.txt")

navbarPage("Ukrajna jelenlegi és jövő hétre várható ország-besorolásai az új COVID-19 esetszámok alapján",
           tabPanel("Kezdőlap",
                    fluidRow(h1("Kezdőlap"), p(readme[1]), p(readme[2]), p(readme[3]))),
           tabPanel("Országok aktuális besorolása",
                    sidebarLayout(position = "left",
                                  sidebarPanel(dateInput("origin_date", label = "Számítás kiindulási napja")),
                                  mainPanel(DT::dataTableOutput('latest_classification_df')))
            ),
           tabPanel("Várható jövő heti besorolás", 
                    sidebarLayout(position = "left",
                                  sidebarPanel(numericInput("n_pred_days", label = "A kiszámításhoz figyelembe vett elmúlt napok száma", value = 7)),
                                  mainPanel(DT::dataTableOutput('next_classification_df'))))
)