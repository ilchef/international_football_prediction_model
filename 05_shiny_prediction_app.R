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

# 1.0 

shinyApp(ui=ui_prediction_app
         ,server=server_prediction_app)