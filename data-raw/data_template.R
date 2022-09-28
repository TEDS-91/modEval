## code to prepare `data_template` dataset goes here

data_template <- readr::write_rds(data_template, path = "data-raw/data_template.rds")

usethis::use_data(data_template, overwrite = TRUE)
