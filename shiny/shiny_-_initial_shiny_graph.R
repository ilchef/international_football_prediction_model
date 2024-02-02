initial_shiny_graph <- function(df){
  df%>%
    copy()%>%
    ggplot() + 
    geom_bar(aes(x=variable,y=metric,fill=variable),stat="identity") +
    theme(axis.title = element_blank()
          ,axis.ticks = element_blank()
          ,panel.grid = element_blank()
          ,axis.text.y = element_blank()
          ,axis.text.x = element_text(size=17,color="black",face="bold")
          ,panel.background = element_blank()
          ,legend.position="none"
    ) +
    scale_fill_manual(values=c("#551fbd","#cecece","#a2eacb"))
}