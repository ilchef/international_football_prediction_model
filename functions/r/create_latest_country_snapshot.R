create_latest_country_snapshot <- function(matches_df_input,rankings_df_input,countries_loop,n){
        
        #rankings based features
        # need recent ranking and change
        current_rankings <- rankings_df_input[rankings_df_input[,.I[rank_date == max(rank_date)],by=country_full]$V1] %>%
                .[,]
        
        for(i in 1:nrow(countries_loop)){
        }
        current_rankings
}