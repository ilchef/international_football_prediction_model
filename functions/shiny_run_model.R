shiny_run_model <- function(pit_data,model,home_team,away_team,neutral){
        home_team <- pit_data %>%
                .[team ==paste0(home_team)] 
        away_team <- pit_data %>%
                .[team ==paste0(away_team)] 
        
        
        combined_output <- data.table(
                neutral = neutral
                ,home2away_delta_rankings = c(home_team$points - away_team$points)
                ,home2away_delta_goals_scored_last_9_matches = c(home_team$goals_scored_last_9_matches - away_team$goals_scored_last_9_matches)
                ,home2away_delta_goals_conceded_last_9_matches = c(home_team$goals_conceded_last_9_matches - away_team$goals_conceded_last_9_matches)
                ,home2away_delta_ties_last_9_matches = c(home_team$ties_last_9_matches - away_team$ties_last_9_matches)
                ,home2away_delta_wins_last_9_matches = c(home_team$goals_scored_last_9_matches - away_team$goals_scored_last_9_matches)
                ,away_fifa_rank_change = home_team$rank_chg
                ,home_fifa_rank_change = away_team$rank_chg
                ,home_team_wins_last_3_matches = home_team$wins_last_3_matches
                ,away_team_wins_last_3_matches = away_team$wins_last_3_matches
                )
        
        result <- predict(model$model,newdata=combined_output,type="probs") %>%
                as.list()%>%
                setDT() %>%
                .[,tie_odds := tie/(1-tie)]%>%
                .[,away_win_odds := `away win`/(1-`away win`)]%>%
                .[,home_win_odds := `home win`/(1-`home win`)]
                
}
