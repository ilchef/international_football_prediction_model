create_latest_country_snapshot <- function(matches_df_input,rankings_df_input,countries_loop,n){
        
        #rankings based features
        # need recent ranking and change
        current_rankings <- rankings_df_input[rankings_df_input[,.I[rank_date == max(rank_date)],by=country_full]$V1] %>%
                .[,]
        
        for(i in 1:nrow(countries_loop)){
        }
        current_rankings
}
# model vars are:
# outcome ~ 
#         home2away_delta_rankings+neutral+home2away_delta_goals_scored_last_9_matches
# +home2away_delta_goals_conceded_last_9_matches+home_fifa_rank_change
# +home2away_delta_ties_last_9_matches + home2away_delta_wins_last_9_matches
# +home_fifa_rank_change + away_fifa_rank_change
# 
#  ti_test <- create_latest_country_snapshot(
#          matches_ts
#         , rankings_ts
#          ,matched_countries
#          ,5
#  )
# # 
# testing <- readRDS("models/logreg_06Oct22.rds")
