run_date <- as.Date("2024-11-19")
historical_lookback <- 9
# Non-reactive Components (move to staging script later?)
# model object
mod_obj <- readRDS(paste0("shiny/shiny_data/fnn_",format(run_date,"%d%b%y"),".rds"))
# Data
data <- readRDS(paste0("shiny/shiny_data/fnn_input_cleaned_pit_predictions_",format(run_date,"%b%Y"),".rds")) %>%
  .[!is.na(rank_chg)]

last_n_matches <- readRDS(paste0("shiny/shiny_data/last_",historical_lookback,"_matches_",format(run_date,"%b%Y"),".rds")) 
  
country_list <- data$team %>%unique() %>% sort()

