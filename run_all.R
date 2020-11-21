setwd("~/Dokumentumok/LABOR/covid-19-UA-class-predictor/")

# loading packages ----------
library(magrittr)
library(purrr)
library(pbapply)
library(ggplot2)
library(lubridate)

# creating new daily report ----------
source("collect_current_data.R")

# updating main page ----------
source("update_main.R")
