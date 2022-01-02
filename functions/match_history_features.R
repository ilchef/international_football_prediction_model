match_history_features <- function(df,countries_loop,n){
        
        df_temp <- df %>% 
                copy() %>%
                #these are the historical features we add. initialised at zero
                .[,paste0("home_team_wins_last_",n,"_matches") := 0]%>%
                .[,paste0("home_team_ties_last_",n,"_matches") := 0]%>%
                .[,paste0("home_team_goals_scored_last_",n,"_matches") := 0]%>%
                .[,paste0("home_team_goals_conceded_last_",n,"_matches") := 0]%>%
                
                .[,paste0("away_team_wins_last_",n,"_matches") := 0]%>%
                .[,paste0("away_team_ties_last_",n,"_matches") := 0]%>%
                .[,paste0("away_team_goals_scored_last_",n,"_matches") := 0]%>%
                .[,paste0("away_team_goals_conceded_last_",n,"_matches") := 0]
        
        #loooping through distinct home countries
        for(i in 1:nrow(countries_loop)){
                cat(paste0("Looping through country ",i," of ",nrow(countries_loop),": ",countries_loop[i],"\n"))
                
                df_temp <- df_temp %>%
                        
                        # temp variable identifies the the match involves country "i". important.
                        .[home_team == countries_loop[i]%>%as.character() | away_team == countries_loop[i]%>%as.character(),temp:=1]%>%
                        # ranking by date for country i (temp). 1 is earliest 
                        .[temp==1,temp_rank := frank(date)]%>%
                        
                        # the four spot variables
                        .[temp==1,temp_win := case_when(home_team==countries_loop[i]%>%as.character() & as.numeric(home_score) > as.numeric(away_score) ~ 1,
                                                        away_team==countries_loop[i]%>%as.character() & as.numeric(home_score) < as.numeric(away_score)~1,
                                                        TRUE~0
                                                        )]%>%
                        .[temp==1,temp_tie := case_when(home_score==away_score~1,TRUE~0)]%>%
                        .[temp==1,temp_goals_scored := case_when(home_team==countries_loop[i]%>%as.character() ~ home_score,
                                                                 away_team==countries_loop[i]%>%as.character() ~ away_score)]%>%
                        .[temp==1,temp_goals_conceded := case_when(home_team==countries_loop[i]%>%as.character() ~ away_score,
                                                 away_team==countries_loop[i]%>%as.character() ~ home_score)]
                        
                #loop through j, the aggregation number (ie last j games)
                for(j in 1:n){
                        df_temp_join <- df_temp %>% 
                                copy() %>% 
                                .[temp==1,.(temp,temp_rank,temp_win,temp_tie,temp_goals_scored,temp_goals_conceded)]%>%
                                setnames(c("temp_win","temp_tie","temp_goals_scored","temp_goals_conceded"),c("temp_win_x","temp_tie_x","temp_goals_scored_x","temp_goals_conceded_x"))%>%
                                .[,temp_rank := temp_rank+j]
                        
                        df_temp <- df_temp %>%
                                merge(df_temp_join,by=c("temp","temp_rank"),all.x=TRUE) %>%
                                # aggregator - but only for home country 
                                .[home_team == countries_loop[i]%>%as.character(),paste0("home_team_wins_last_",n,"_matches") := get(paste0("home_team_wins_last_",n,"_matches"))+temp_win_x]%>%
                                .[home_team == countries_loop[i]%>%as.character(),paste0("home_team_ties_last_",n,"_matches") := get(paste0("home_team_ties_last_",n,"_matches"))+temp_tie_x]%>%
                                .[home_team == countries_loop[i]%>%as.character(),paste0("home_team_goals_scored_last_",n,"_matches") := get(paste0("home_team_goals_scored_last_",n,"_matches"))+temp_goals_scored_x]%>%
                                .[home_team == countries_loop[i]%>%as.character(),paste0("home_team_goals_conceded_last_",n,"_matches") := get(paste0("home_team_goals_conceded_last_",n,"_matches"))+temp_goals_conceded_x]%>%
                        
                                # aggregator - but only for away country this time 
                                .[away_team == countries_loop[i]%>%as.character(),paste0("away_team_wins_last_",n,"_matches") := get(paste0("away_team_wins_last_",n,"_matches"))+temp_win_x]%>%
                                .[away_team == countries_loop[i]%>%as.character(),paste0("away_team_ties_last_",n,"_matches") := get(paste0("away_team_ties_last_",n,"_matches"))+temp_tie_x]%>%
                                .[away_team == countries_loop[i]%>%as.character(),paste0("away_team_goals_scored_last_",n,"_matches") := get(paste0("away_team_goals_scored_last_",n,"_matches"))+temp_goals_scored_x]%>%
                                .[away_team == countries_loop[i]%>%as.character(),paste0("away_team_goals_conceded_last_",n,"_matches") := get(paste0("away_team_goals_conceded_last_",n,"_matches"))+temp_goals_conceded_x]%>%
                                
                                
                                # remove joined columns for next join
                                .[,temp_win_x:=NULL]%>%.[,temp_tie_x:=NULL]%>%.[,temp_goals_scored_x:=NULL]%>%.[,temp_goals_conceded_x:=NULL]
                        
                        rm(df_temp_join)
                }
                #for records with temp_rank less than n we need to overwrite to NA, because they are not a full observation period
                df_temp <- df_temp %>%
                        .[home_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("home_team_wins_last_",n,"_matches"):=NA]%>%
                        .[home_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("home_team_ties_last_",n,"_matches"):=NA]%>%
                        .[home_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("home_team_goals_scored_last_",n,"_matches"):=NA]%>%
                        .[home_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("home_team_goals_conceded_last_",n,"_matches"):=NA]%>%
                        
                        .[away_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("away_team_wins_last_",n,"_matches"):=NA]%>%
                        .[away_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("away_team_ties_last_",n,"_matches"):=NA]%>%
                        .[away_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("away_team_goals_scored_last_",n,"_matches"):=NA]%>%
                        .[away_team == countries_loop[i]%>%as.character() & temp_rank < n,paste0("away_team_goals_conceded_last_",n,"_matches"):=NA]%>%
                        #drop variables that will need restating
                        .[,temp:=NULL]%>%.[,temp_rank:=NULL]%>%.[,temp_win:=NULL]%>%.[,temp_tie:=NULL]%>%.[,temp_goals_scored:=NULL]%>%.[,temp_goals_conceded:=NULL]%>%
                        #relativities
                        .[,paste0("home2away_delta_wins_last_",n,"_matches"):=get(paste0("home_team_wins_last_",n,"_matches"))-get(paste0("away_team_wins_last_",n,"_matches"))]%>%
                        .[,paste0("home2away_delta_ties_last_",n,"_matches"):=get(paste0("home_team_ties_last_",n,"_matches"))-get(paste0("away_team_ties_last_",n,"_matches"))]%>%
                        .[,paste0("home2away_delta_goals_scored_last_",n,"_matches"):=get(paste0("home_team_goals_scored_last_",n,"_matches"))-get(paste0("away_team_goals_scored_last_",n,"_matches"))]%>%
                        .[,paste0("home2away_delta_goals_conceded_last_",n,"_matches"):=get(paste0("home_team_goals_conceded_last_",n,"_matches"))-get(paste0("away_team_goals_conceded_last_",n,"_matches"))]
                
        }
        
        
        return(df_temp)
}
