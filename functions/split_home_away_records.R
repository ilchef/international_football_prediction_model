split_home_away_records <- function(dt,tag,extras){
        dt_temp <- dt %>% copy()
        
        name_list <- names(dt_temp)
        name_list <- name_list[str_detect(name_list,tag)|name_list %in% extras]
        
        dt_temp <- dt_temp[,name_list]
        
        if(tag == "away"){
                list_h2a <- name_list[str_detect(name_list,"home2away")]
                for(i in list_h2a){
                        dt_temp[,paste0(list_h2a[i]) := get(list_h2a[i])*-1]
                }
                        
        }
        names(dt_temp) <- str_replace_all(names(dt_temp),paste0("home2away_|",tag,"_"),"")
        
        dt_temp
}

test <- split_home_away_records(matches_x_rankings_ts,"away",c("neutral","tournament","date"))