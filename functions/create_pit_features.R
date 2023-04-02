
create_pit_features <- function(matches_ts,rankings_features,n){
        list_of_countries <- unique(matches_ts$home_team)
        ticker <- 1
        for(i in list_of_countries){
                print(paste0("Analysing country ",ticker," of ",length(list_of_countries),": ",i))
                
                for(j in 1:length(n)){ # looping through each element in "n"
                        matches_temp <- matches_ts %>% 
                                copy() %>%
                                .[home_team==paste0(i)|away_team == paste0(i)] %>%
                                .[,temp_rank :=dense_rank(desc(date))] %>%
                                .[temp_rank <= n[j]]%>%
                                .[,team:= i]  %>%
                                .[,.(goals_concede = sum(case_when(away_team == i ~ home_score,TRUE~away_score))
                                     ,goals_score= sum(case_when(away_team == i ~ away_score,TRUE~home_score))
                                     ,ties=  sum(case_when(away_score == home_score ~1, TRUE~0))
                                     ,wins=  sum(case_when(home_team ==i & home_score >away_score ~ 1
                                                           ,away_team ==i & away_score >home_score ~ 1
                                                           ,TRUE~0))
                                ),by=team]
                        
                        setnames(matches_temp,new = c(
                                "team"
                                ,paste0("goals_conceded_last_",n[j],"_matches")
                                ,paste0("goals_scored_last_",n[j],"_matches")
                                ,paste0("ties_last_",n[j],"_matches")
                                ,paste0("wins_last_",n[j],"_matches")
                        ))
                        
                        if(length(n)>1 & j >1){ # if we require backward-looking of more than one length
                          matches_temp_final <- cbind(matches_temp_final,matches_temp[,team := NULL]) 
                        } else{ 
                          matches_temp_final <- matches_temp      
                        }
                }
                
                
                
                
                
                rankings_temp <- rankings_features %>% 
                        copy() %>%
                        .[home_team==paste0(i)|away_team == paste0(i)] %>%
                        .[,temp_rank :=dense_rank(desc(date))]  %>%
                        .[temp_rank==1] %>%
                        .[,points:= case_when(home_team == i~ home_fifa_points, TRUE ~away_fifa_points)]%>%
                        .[,rank_chg := case_when(home_team == i~home_fifa_rank_change, TRUE ~away_fifa_rank_change)]%>%
                        .[,.(points,rank_chg)]
                
                matches_temp <- cbind(matches_temp_final,rankings_temp)
                        
                
                if(ticker==1){
                        data_out <- matches_temp         
                }else{
                        data_out <- rbind(data_out,matches_temp)
                }
                ticker <- ticker+1
        }
        data_out %>% return()
}
