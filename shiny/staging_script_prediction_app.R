run_date <- as.Date("2023-11-21")
historical_lookback <- 9
# Non-reactive Components (move to staging script later?)
# model object
mod_obj <- readRDS(paste0("shiny/shiny_data/logreg_",format(run_date,"%d%b%y"),".rds"))$model

# Data
data <- readRDS(paste0("shiny/shiny_data/input_cleaned_pit_predictions_",format(run_date,"%b%Y"),".rds")) %>%
  .[!is.na(rank_chg)]

last_n_matches <- readRDS(paste0("shiny/shiny_data/last_",historical_lookback,"_matches_",format(run_date,"%b%Y"),".rds")) 
  
country_list <- data$team %>%unique() %>% sort()
