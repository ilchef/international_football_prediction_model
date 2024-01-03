save_rds_and_csv <- function(df,filepathname){
  #good to have both
  fwrite(df,paste0(filepathname,".csv"))
  saveRDS(df,paste0(filepathname,".rds"))
}