merge_rankings_matches <- function(matches_df_input,rankings_df_input){
        #create eff from/to date
        rankings_df <- rankings_df_input %>% copy()
        rankings_df[,c("country_abrv","previous_points","rank"):= NULL]
        rankings_df[order(rank_date)]
        rankings_df[,last_rank_date := coalesce(shift(rank_date,type="lag",n=1L),as.IDate("2000-01-01")),by=country_full]
        
        matches_df <- matches_df_input %>% copy()
        
        matches_df <- matches_df[,date :=as.character(date)]
        rankings_df <- rankings_df[,rank_date := as.character(rank_date)] %>%
                .[,last_rank_date := as.character(last_rank_date)]
        
        output  <- sqldf("
        select
        a.*
        ,b.total_points as home_fifa_points
        ,b.rank_change as home_fifa_rank_change
        ,b.confederation as home_confederation
        from matches_df as a
        left join rankings_df as b
        on a.home_team = b.country_full
        and a.date > b.last_rank_date
        and a.date <= b.rank_date
                        ")
        
        output_2 <- sqldf("
        select
        a.*
        ,b.total_points as away_fifa_points
        ,b.rank_change as away_fifa_rank_change
        ,b.confederation as away_confederation
        from output as a
        left join rankings_df as b
        on a.away_team = b.country_full
        and a.date > b.last_rank_date
        and a.date <= b.rank_date
                        ")
        
        output_2 <- output_2 %>%
                setDT() %>%
                .[,home2away_delta_rankings := home_fifa_points - away_fifa_points]
}
