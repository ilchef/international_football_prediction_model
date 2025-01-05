get_nnet_structure <- function(model) {
  
  
  # Extract input names from coefnames (removing ".to." and everything after)
  input_names <- unique(sub("\\.to\\..*", "", model$coefnames))
  output_names <- colnames(model$fitted.values)
  # Get weights and structure
  wts <- model$wts
  n_in <- length(model$coefnames)
  n_hidden <- model$n[2]
  n_out <- model$n[3]
  
  # Create nodes dataframe
  nodes <- data.frame(
    id = character(),
    layer = character(),
    stringsAsFactors = FALSE
  )
  
  # Input layer nodes
  input_nodes <- data.frame(
    id = paste0("i", 1:n_in),
    layer = "input",
    name=input_names,
    stringsAsFactors = FALSE
  )
  
  # Hidden layer nodes
  hidden_nodes <- data.frame(
    id = paste0("h", 1:n_hidden),
    layer = "hidden",
    name= "",
    stringsAsFactors = FALSE
  )
  
  # Output layer nodes
  output_nodes <- data.frame(
    id = paste0("o", 1:n_out),
    layer = "output",
    name=output_names,
    stringsAsFactors = FALSE
  )
  
  nodes <- rbind(input_nodes, hidden_nodes, output_nodes)
  
  # Create connections dataframe
  connections <- data.frame(
    from = character(),
    to = character(),
    weight = numeric(),
    stringsAsFactors = FALSE
  )
  
  # Input to hidden layer weights
  start_idx <- 1
  for(h in 1:n_hidden) {
    for(i in 1:n_in) {
      connections <- rbind(connections, data.frame(
        from = paste0("i", i),
        to = paste0("h", h),
        weight = wts[start_idx + i - 1],
        stringsAsFactors = FALSE
      ))
    }
    start_idx <- start_idx + n_in
  }
  
  # Hidden to output layer weights
  for(o in 1:n_out) {
    for(h in 1:n_hidden) {
      connections <- rbind(connections, data.frame(
        from = paste0("h", h),
        to = paste0("o", o),
        weight = wts[start_idx + h - 1],
        stringsAsFactors = FALSE
      ))
    }
    start_idx <- start_idx + n_hidden
  }
  
  return(list(
    nodes = nodes %>% mutate(num=as.numeric(str_extract(id,"-?\\d*\\.?\\d+"))
                             ,lay=fct_relevel(str_extract(id,"[A-Za-z]+"),"i","h","o")
    ) %>%
      mutate(num=case_when(lay=="h"~num+2.5,lay=="o"~num+4.5,TRUE~num))
    ,connections = connections%>%
      mutate(from_num=as.numeric(str_extract(from,"-?\\d*\\.?\\d+"))
             ,to_num=as.numeric(str_extract(to,"-?\\d*\\.?\\d+"))
             ,from_lay=fct_relevel(str_extract(from,"[A-Za-z]+"),"i","h","o")
             ,to_lay=fct_relevel(str_extract(to,"[A-Za-z]+"),"i","h","o")
      ) %>%
      mutate(from_num=case_when(from_lay=="h"~from_num+2.5,TRUE~from_num)
             ,to_num=case_when(to_lay=="h"~to_num+2.5,to_lay=="o"~to_num+4.5,TRUE~to_num))%>%
      group_by(to_lay) %>%
      mutate(weight=(weight-mean(weight))/(sd(weight))) # scaling by level
  ))
}