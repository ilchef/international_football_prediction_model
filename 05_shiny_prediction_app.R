
# 0.0 Setup
rm(list=ls())

# load packages
library(data.table)
library(dplyr)
library(stringr)
library(forcats)

library(ggplot2)
library(plotly)

library(shiny)
library(shiny.fluent)
library(shinyWidgets)
library(DT)

library(nnet)

# load functions
lapply(paste0("shiny/", list.files("shiny/", pattern = "\\.R$")), source) %>% invisible()

shinyApp(ui=ui_prediction_app
         ,server=server_prediction_app)