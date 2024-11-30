
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
library(shiny.router)
library(shinyWidgets)
library(DT)

library(nnet)
library(plotly)


# load functions
source("shiny/staging_script_prediction_app.R")
lapply(paste0("shiny/", list.files("shiny/", pattern = "\\.R$")), source) %>% invisible()

shinyApp(ui=ui
         ,server=server_prediction_app)

