#! /usr/bin/env Rscript
if(!requireNamespace("tidyr")) install.packages("tidyr"); requireNamespace("tidyr")
if(!requireNamespace("tibble")) install.packages("tibble"); requireNamespace("tibble")
if(!requireNamespace("purrr")) install.packages("purrr"); requireNamespace("purrr")
if(!requireNamespace("knitr")) install.packages("knitr"); requireNamespace("knitr")
if(!requireNamespace("readr")) install.packages("readr"); requireNamespace("readr")
if(!requireNamespace("yaml")) install.packages("yaml"); requireNamespace("yaml")
if(!require("magrittr")) install.packages("magrittr"); require("magrittr")

args <- commandArgs(trailingOnly = TRUE)
input_path <- "comparison.yml"
if(length(args) > 0) {
  input_path <- args[[1]]
}
if(length(args) > 1) {
  output_path <- args[[2]]
}

  
y <- yaml::read_yaml(input_path)
tbl <- y %>% purrr::map_dfr(~ ., .id="Service") %>% tidyr::pivot_longer(-Service, names_to="Feature") %>%  tidyr::pivot_wider(names_from=Service, values_from=value)
md <- tbl %>% knitr::kable()

if(exists("output_path")) {
  md %>% readr::write_lines(output_path)
} else {
  cat(md, sep="\n")
}
