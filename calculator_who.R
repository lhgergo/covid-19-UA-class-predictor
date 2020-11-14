# loading packages ---------
library(magrittr)
library(purrr)
library(pbapply)
library(ggplot2)

# downloading data ----------
current_filename <- paste0("data/WHO-COVID-19-global-data-", substr(Sys.time(), 1, 10), ".csv")
download.file("https://covid19.who.int/WHO-COVID-19-global-data.csv", destfile = current_filename)

date_today <- Sys.time() %>% substr(1, 10) %>% as.Date()

# loading data ---------
coviddf <- read.csv(current_filename, stringsAsFactors = FALSE)
popdf <- read.csv("data/population_data.csv", stringsAsFactors = FALSE) # https://databank.worldbank.org/reports.aspx?source=2&series=SP.POP.TOTL&country=#
populations <- popdf$X2019..YR2019. %>% as.numeric() %>% set_names(popdf$Country.Name)
populations <- populations[!is.na(populations)]
mutual_countries <- intersect(names(populations), coviddf$Country)

populations <- populations[mutual_countries]
coviddf <- coviddf[coviddf$Country %in% mutual_countries, ]
coviddf$Date_reported %<>% as.Date


# running analysis for lastest day of recategorisation ----------
# might be a bit different from the ones on moz.gov.ua, probably because they got population count data from somewhere else
origin_date <- date_today
last_14_days <- seq((origin_date-13), (origin_date), by = "day")

pbsapply(mutual_countries, function(cntry) {
  tmpdf <- coviddf[coviddf$Country == cntry, ]
  crnt_pop <- populations[cntry]
  ((tmpdf[tmpdf$Date_reported %in% last_14_days, "New_cases"] %>% sum())/crnt_pop)*100000
}) -> vals

# calculating probable case numbers based on next recategorization based on the trends in the last 28 days ----------
origin_date <- date_today
next_recategorization_date <- as.Date("2020-11-20")
last_14_days <- seq((origin_date-13), (origin_date), by = "day")
last_14_days_from_next_recat <- seq((next_recategorization_date-13), (next_recategorization_date), by = "day")
days_of_prediction <- seq((origin_date-7), (origin_date), by = "day")
next_days <- seq(origin_date+1, next_recategorization_date, by = "day")

pbsapply(mutual_countries, function(cntry) {
  tmpdf <- coviddf[coviddf$Country == cntry, ]
  tmpdf_pred <- tmpdf[tmpdf$Date_reported %in% days_of_prediction, ]
  mdl <- lm(New_cases ~ Date_reported, tmpdf_pred)
  predcnt_til_next_recat <- predict(mdl, newdata = data.frame(Date_reported = next_days)) %>% round()
  
  ggplot(data = tmpdf_pred, aes(x = Date_reported, y = New_cases)) + geom_point() + geom_smooth(method = "lm")
  crnt_pop <- populations[cntry]
  ((sum(tmpdf[tmpdf$Date_reported %in% last_14_days_from_next_recat, "New_cases"], predcnt_til_next_recat)/crnt_pop)*100000) %>% format(digits = 3) %>% as.numeric()
}) -> vals
