set_workspace <-function(){
        elements <- list("data","functions","data/input","data/input_cleaned","data/output")
        lapply(elements,create_if_missing)
}