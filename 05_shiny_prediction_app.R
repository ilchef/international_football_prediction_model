
# 0.0 Setup
rm(list=ls())

# load packages
library(data.table)
library(dplyr)
library(stringr)

library(ggplot2)
library(plotly)

library(shiny)
library(shinyWidgets)

library(nnet)

# load functions
lapply(paste0("shiny/",list.files("shiny/")),source) %>% invisible()
source("functions/r/two_countries_data_prep.R")

shinyApp(ui=ui_prediction_app
         ,server=server_prediction_app)