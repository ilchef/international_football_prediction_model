create_if_missing <- function(fp){
        if(dir.exists(fp)){
                cat("\nFilepath ",paste0(getwd(),"/",fp)," already exists.\n")
        } else {
                dir.create(fp)
                cat("\nCreated filepath ",paste0(getwd(),"/",fp))
        }
        return(invisible(NULL))
}

