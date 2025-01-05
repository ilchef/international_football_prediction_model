two_countries_data_prep <- function(df,home_team,away_team,neutral_ground){
        home_team_temp <- df[team == home_team]
        
        away_team_temp <- df[team == away_team]
        
        output <- data.table(
                
                home2away_delta_rankings = home_team_temp$points - away_team_temp$points
                ,neutral = neutral_ground
                ,home2away_delta_goals_scored_last_9_matches = home_team_temp$goals_scored_last_9_matches - away_team_temp$goals_scored_last_9_matches
                ,home2away_delta_wins_last_9_matches = home_team_temp$wins_last_9_matches - away_team_temp$wins_last_9_matches
                ,home2away_delta_goals_conceded_last_9_matches = home_team_temp$goals_conceded_last_9_matches - away_team_temp$goals_conceded_last_9_matches
                ,home_fifa_rank_change = home_team_temp$rank_chg
                ,away_fifa_rank_change = away_team_temp$rank_chg
                ,away_team_wins_last_3_matches = away_team_temp$wins_last_3_matches
                #
                ,home_fifa_points = home_team_temp$points
                ,away_fifa_points = away_team_temp$points
                ,home_team_goals_scored_last_9_matches =  home_team_temp$goals_scored_last_9_matches
                ,away_team_goals_scored_last_9_matches =  away_team_temp$goals_scored_last_9_matches
                ,home_team_wins_last_9_matches =  home_team_temp$wins_last_9_matches
                ,away_team_wins_last_9_matches =  away_team_temp$wins_last_9_matches
                ,home_team_goals_conceded_last_9_matches = home_team_temp$goals_conceded_last_9_matches
                ,away_team_goals_conceded_last_9_matches = away_team_temp$goals_conceded_last_9_matches
        )
        return(output)
}
