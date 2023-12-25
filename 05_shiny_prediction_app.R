
# 0.0 Setup
rm(list=ls())

# load packages
library(data.table)
library(dplyr)
library(stringr)

library(ggplot2)
library(plotly)

library(shiny)
library(shinydashboard)
library(shinyWidgets)

# load functions
lapply(paste0("shiny/",list.files("shiny/")),source) %>% invisible()
source("functions/r/two_countries_data_prep.R")

# load model object
mod_obj <- readRDS("models/logreg_21Nov23.rds")

# 1.0 Data
data <- readRDS("data/current_pit/input_cleaned_pit_predictions.rds") %>%
  .[!is.na(rank_chg)]

country_list <- data$team %>% unique() %>% sort()

shinyApp(ui=ui_prediction_app
         ,server=server_prediction_app)