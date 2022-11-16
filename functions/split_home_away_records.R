split_home_away_records <- function(dt,tag,extras){
        dt_temp <- dt %>% copy() %>% setDT()
        name_list <- names(dt_temp)
        name_list <- name_list[str_detect(name_list,tag)|name_list %in% extras]
        
        if(tag == "away"){
                list_h2a <- name_list[str_detect(name_list,"home2away")]
                for(i in list_h2a){
                        dt_temp[,paste0(i) := get(i)*-1]
                }
                
                dt_temp[,result := case_when(home_score > away_score ~"loss"
                                             ,home_score == away_score ~"tie"
                                             ,TRUE~"win")]
                        
        } else {
                dt_temp[,result := case_when(home_score > away_score ~"win"
                                             ,home_score == away_score ~"tie"
                                             ,TRUE~"loss")]
        }
        name_list <- append(name_list,"result")

        dt_temp <- dt_temp[,..name_list]
        
        names(dt_temp) <- str_replace_all(names(dt_temp),paste0("home2away_|",tag,"_"),"")
        
        dt_temp[,home_away_flag := tag]
        dt_temp[,score:=NULL]
}
