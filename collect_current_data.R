# loading packages and functions ---------
library(magrittr)
library(purrr)
library(pbapply)
library(ggplot2)
library(lubridate)

# from stackoverflow: https://stackoverflow.com/a/32434900
nextweekday <- function(date, wday) {
  date <- as.Date(date)
  diff <- wday - wday(date)
  if( diff < 0 )
    diff <- diff + 7
  return(date + diff)
}

PredictIndicators <- function(n_days) {
  next_recategorization_date <- nextweekday(date_ytday, 6)
  
  if(wday(date_ytday) == 6) {
    next_recategorization_date <- next_recategorization_date + 7
  }
  
  last_14_days <- seq((date_ytday-13), (date_ytday), by = "day")
  last_14_days_from_next_recat <- seq((next_recategorization_date-13), (next_recategorization_date), by = "day")
  days_of_prediction <- seq((date_ytday-(n_days-1)), (date_ytday), by = "day")
  next_days <- seq(date_ytday+1, next_recategorization_date, by = "day")
  
  last_14_days_from_next_recat <- setdiff(last_14_days_from_next_recat, next_days)
  
  pbsapply(mutual_countries, function(cntry) {
    tmpdf <- coviddf[coviddf$Country == cntry, ]
    tmpdf_pred <- tmpdf[tmpdf$Date_reported %in% days_of_prediction, ]
    mdl <- lm(New_cases ~ Date_reported, tmpdf_pred)
    predcnt_til_next_recat <- predict(mdl, newdata = data.frame(Date_reported = next_days)) %>% round()
    
    # ggplot(data = tmpdf_pred, aes(x = Date_reported, y = New_cases)) + geom_point() + geom_smooth(method = "lm")
    crnt_pop <- populations[cntry]
    ((sum(tmpdf[tmpdf$Date_reported %in% last_14_days_from_next_recat, "New_cases"], predcnt_til_next_recat)/crnt_pop)*100000) %>% format(digits = 3) %>% as.numeric()
  }) 
}

neighbouring_cntrys<- c("Ukraine", "Slovakia", "Poland", "Belarus", "Russian Federation", "Moldova", "Romania", "Hungary")

# downloading data ----------
date_today <- Sys.time() %>% substr(1, 10) %>% as.Date()
date_ytday <- date_today - 1 # I will deal with data from yesterday!
current_filename <- paste0("data/input/WHO-COVID-19-global-data-", date_today, ".csv")
download.file("https://covid19.who.int/WHO-COVID-19-global-data.csv", destfile = current_filename)

# loading data ---------
coviddf <- read.csv(current_filename, stringsAsFactors = FALSE)
popdf <- read.csv("https://raw.githubusercontent.com/lhgergo/covid-19-UA-class-predictor/main/data/input/population_data.csv", stringsAsFactors = FALSE) # https://databank.worldbank.org/reports.aspx?source=2&series=SP.POP.TOTL&country=#
populations <- popdf$X2019..YR2019. %>% as.numeric() %>% set_names(popdf$Country.Name)
names(populations)[names(populations) == "Slovak Republic"] <- "Slovakia"
coviddf$Country[coviddf$Country == "Republic of Moldova"] <- "Moldova"

populations <- populations[!is.na(populations)]
mutual_countries <- intersect(names(populations), coviddf$Country)

populations <- populations[mutual_countries]
coviddf <- coviddf[coviddf$Country %in% mutual_countries, ]
coviddf$Date_reported %<>% as.Date

# running indicator calculation and grouping for yesteraday ----------
# might be a bit different from the ones on moz.gov.ua, probably because they got population count data from somewhere else
last_14_days <- seq((date_ytday-13), (date_ytday), by = "day")

pbsapply(mutual_countries, function(cntry) {
  tmpdf <- coviddf[coviddf$Country == cntry, ]
  crnt_pop <- populations[cntry]
  ((tmpdf[tmpdf$Date_reported %in% last_14_days, "New_cases"] %>% sum())/crnt_pop)*100000
}) %>% set_names(mutual_countries) -> indicators_ytday

indicators_ytday_df <- data.frame(country = names(indicators_ytday),
                                  indicators_ytday = indicators_ytday,
                                  cats = ifelse(indicators_ytday > indicators_ytday["Ukraine"], "vörös", "zöld"))
indicators_ytday_df <- indicators_ytday_df[order(indicators_ytday_df$indicators_ytday, decreasing = T), ]
rownames(indicators_ytday_df) <- NULL

# running indicator calculation and grouping for next Friday (based on last 7 days) ----------
# simple lm models of last n days
predictionsdf <- data.frame(predvals_7days = PredictIndicators(7),
                            predvals_14days = PredictIndicators(14))

predictionsdf <- predictionsdf[order(predictionsdf$predvals_14days, decreasing = T), ]
predictionsdf$cats_7days <- ifelse(predictionsdf$predvals_7days > predictionsdf["Ukraine", "predvals_7days"], "vörös", "zöld")
predictionsdf$cats_14days <- ifelse(predictionsdf$predvals_14days > predictionsdf["Ukraine", "predvals_14days"], "vörös", "zöld")
predictionsdf$country <- rownames(predictionsdf)
rownames(predictionsdf) <- NULL

############## PRODUCING REPORT IN MARKDOWN FORMAT ----------
# loading template ---------
mrkdwn_tmplt <- readLines("templates/report_tmplt.md")
mrkdwn_tmplt <- gsub("DATE", date_ytday, mrkdwn_tmplt)

# rendering indicators_ytday_df ----------
indicators_ytday_df_kbl <- indicators_ytday_df[indicators_ytday_df$country %in% neighbouring_cntrys, c("country", "indicators_ytday", "cats")] %>% 
  knitr::kable(col.names = c("ország", "mutató", "besorolás"))

# rendering predictionsdf ---------
predictionsdf_kbl <- predictionsdf[predictionsdf$country %in% neighbouring_cntrys, c("country", "predvals_7days", "cats_7days", "predvals_14days", "cats_14days")] %>% 
  knitr::kable(col.names = c("ország", "várható mutató az elmúlt 7 nap alapján", "várható besorolás az elmúlt 7 nap alapján",
                             "várható mutató az elmúlt 14 nap alapján", "várható besorolás az elmúlt 14 nap alapján"))

mrkdwn_output <- c(mrkdwn_tmplt[1:3], "", indicators_ytday_df_kbl, mrkdwn_tmplt[3], predictionsdf_kbl)

datadir_path <- paste0("data/output/", date_ytday, "/")
dir.create(datadir_path)
write(mrkdwn_output, file = paste0(datadir_path, "report.md"))

