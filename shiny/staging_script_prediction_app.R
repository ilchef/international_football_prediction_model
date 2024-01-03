run_date <- as.Date("2023-11-21")
historical_lookback <- 9
# Non-reactive Components (move to staging script later?)
# model object
mod_obj <- readRDS(paste0("models/logreg_",format(run_date,"%d%b%y"),".rds"))$model

# Data
data <- readRDS(paste0("data/current_pit/input_cleaned_pit_predictions_",format(run_date,"%b%Y"),".rds")) %>%
  .[!is.na(rank_chg)]

last_n_matches <- readRDS(paste0("data/current_pit/last_",historical_lookback,"_matches_",format(run_date,"%b%Y"),".rds")) 
  
country_list <- data$team %>%unique() %>% sort()

# ## DELETE Later!!!!!
# 
# 
# testing <- two_countries_data_prep(data,home_team="france",away_team="hong kong",TRUE)
# 
# testing_inverse <- two_countries_data_prep(data,home_team="hong kong",away_team="france",TRUE)
# 
# 
# prediction <- data.frame(as.list(predict(mod_obj,type="probs",newdata=testing)))
# 
# prediction_inverse <- data.frame(as.list(predict(mod_obj,type="probs",newdata=testing_inverse)))
# 
# prediction_harmonised <- data.frame(away.win = c(mean(c(prediction$away.win,prediction_inverse$home.win)))
#                                     ,home.win = c(mean(c(prediction$home.win,prediction_inverse$away.win)))
#                                     ,tie = c(mean(c(prediction$tie,prediction_inverse$tie)))
#                                     )

