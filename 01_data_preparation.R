# 0.0 Setup
rm(list=ls())
library(data.table)
library(dplyr)
library(stringr)
library(sqldf)

lapply(paste0("functions/",list.files("functions")),source) %>% invisible()
set_workspace()

# 1.0 Read Data
input_files <- list.files("data/input") 

rankings_ts <- input_files %>% 
        str_subset(pattern="^fifa_ranking-.*\\.csv")

rankings_ts <- fread(paste0("data/input/",rankings_ts))

matches_ts <- fread("data/input/results.csv")

# 2.1 Clean data - date matches

max_date_rankings <- max(rankings_ts$rank_date)
max_date_matches <- max(matches_ts$date)


filter_date_upper <- max(max_date_matches,max_date_rankings)
filter_date_lower <- filter_date_upper - 365*15

rankings_ts <- rankings_ts[rank_date %between% c(filter_date_lower,filter_date_upper)]

matches_ts <- matches_ts[date %between% c(filter_date_lower,filter_date_upper)]

# 2.1b If ranking data not as current as match data, use latest available rankings

if(max(rankings_ts$rank_date < filter_date_upper)){
        latest_rankings_temp <- rankings_ts[rank_date == max(rank_date)] %>%
                .[,rank_date := filter_date_upper]
        
        rankings_ts <- rbind(rankings_ts,latest_rankings_temp)
        rm(latest_rankings_temp)
}

# 2.2 Clean data - country names

matches_ts <- matches_ts%>% standardise_countries("home_team") %>% standardise_countries("away_team")
rankings_ts <- rankings_ts%>% standardise_countries("country_full")

countries_matches <- matches_ts[,home_team] %>% unique() %>% as.data.table() 
countries_rankings <- rankings_ts[,country_full] %>% unique() %>% as.data.table() 

analyse_country_matchrate(countries_matches,countries_rankings)

matched_countries <- countries_matches %>% 
        merge(countries_rankings,by=".",all=FALSE) 

rm(list= c("countries_matches","countries_rankings"))

matches_ts <- matches_ts%>% 
        merge(matched_countries, by.x = "home_team",by.y=".",all=FALSE)%>% 
        merge(matched_countries, by.x = "away_team",by.y=".",all=FALSE)

rankings_ts <- rankings_ts%>% 
        merge(matched_countries, by.x = "country_full",by.y=".",all=FALSE)


# 2.3 Clean data - interim save

saveRDS(matches_ts,"data/input_cleaned/matches_cleaned_ts.rds")
saveRDS(rankings_ts,"data/input_cleaned/rankings_cleaned_ts.rds")

# 3.0 Feature Engineering

matches_ts_hist_feats <- match_history_features(matches_ts,matched_countries,3) %>%
        match_history_features(matched_countries,9)
rm(matches_ts)

# 3.1 Feature Enineering - rankings
matches_x_rankings_ts <- merge_rankings_matches(matches_ts_hist_feats,rankings_ts)

rm(rankings_ts,matches_ts_hist_feats)

matches_x_rankings_ts <- matches_x_rankings_ts %>% 
        setDT() %>%
        .[,outcome := case_when(home_score == away_score ~ "tie"
                                ,home_score > away_score ~ "home win"
                                , TRUE ~ "away win")]


# 4.0 Save data
output_data <- split_home_away_records(matches_x_rankings_ts,"away",c("neutral","tournament","date")) %>% 
        rbind(split_home_away_records(matches_x_rankings_ts,"home",c("neutral","tournament","date")))

saveRDS(output_data,paste0("data/output/final_model_data_",format(filter_date_upper,"_%d%b%y"),".rds"))
write.csv(output_data,paste0("data/output/final_model_data_",format(filter_date_upper,"_%d%b%y"),".csv"))

saveRDS(matches_x_rankings_ts,paste0("data/output/final_model_data_multiclass_",format(filter_date_upper,"_%d%b%y"),".rds"))
write.csv(matches_x_rankings_ts,paste0("data/output/final_model_data_multiclass_",format(filter_date_upper,"_%d%b%y"),".csv"))