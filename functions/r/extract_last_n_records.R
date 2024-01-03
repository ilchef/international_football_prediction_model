extract_last_n_records <- function(df,n){
  list_of_countries <- unique(matches_ts$home_team)
  
  ticker <- 1
  for(i in list_of_countries){
    print(paste0("Adding country",ticker," of ",length(list_of_countries),": ",i))
    
    #all records featuring country
    df_temp <- df %>%
      copy() %>%
      .[home_team==paste0(i)|away_team==paste0(i)]%>%
      .[,temp_rank :=dense_rank(desc(date))] %>%
      .[temp_rank <=n] %>%
      .[,record_country := paste0(i)]%>%
      .[,`match location` := city]%>%
      .[,outcome := case_when(home_score == away_score ~ "tie"
                              ,home_team == paste0(i) & home_score > away_score ~ paste0("win")
                              ,home_team == paste0(i) & home_score < away_score ~ paste0("loss")
                              ,away_team == paste0(i) & home_score > away_score ~ paste0("loss")
                              ,away_team == paste0(i) & home_score < away_score ~ paste0("win")
                              )]%>%
      .[,score := case_when(home_team == paste0(i)~paste0(home_score,":",away_score),TRUE~paste0(away_score,":",home_score))] %>% 
      .[,opponent := case_when(home_team == paste0(i)~away_team,TRUE ~ home_team)]%>%
      .[,.(record_country,date,opponent,score,outcome,`match location`)]
    
    if(ticker==1){
      output <- df_temp %>% copy()
    } else {
      output <- rbind(output,df_temp)
    }
    ticker <- ticker+1
  }
  
  return(output)
}