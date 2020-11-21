# updates the main site (README.md) with links to new reports

tmplt <- readLines("templates/main_tmplt.md")
date_dirs <- list.files("data/output/") %>% as.Date() %>% sort(decreasing = T)
report_files <- paste0("data/output/", date_dirs, "/report.md")
report_links <- paste0("* [", date_dirs, "](https://github.com/lhgergo/covid-19-UA-class-predictor/blob/main/", report_files, ")")
outmd <- c(tmplt[1:7], report_links, tmplt[9:length(tmplt)])
write(outmd, file = "README.md")
