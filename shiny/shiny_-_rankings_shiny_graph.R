rankings_shiny_graph <- function(df,home,away){
  set.seed(1)
  data_temp <- data %>%
    copy() %>%
    .[,team:=fct_reorder(team,points,.desc=TRUE)] %>%
    .[,dummy:=as.factor(case_when(team==paste0(home)~0,team==paste0(away)~1,TRUE~2))] %>%
    .[, rank := frank(-points)]%>%
    .[,alpha_dummy:= case_when(team%in%c(home,away)~1,TRUE~0)]
  
  data_temp %>%
    ggplot()+
    #geom_bar(aes(y=points,x=team,color=dummy),stat="identity")+
    geom_vline(data=data_temp[team==away],aes(xintercept=-points),linetype=2,color="#a2eacb",alpha=0.7)+
    geom_vline(data=data_temp[team==home],aes(xintercept=-points),linetype=2,color="#551fbd",alpha=0.7)+
    
    geom_text(data=data_temp[team==away],aes(x=-points+ifelse(points>1000,45,-280),y=0.16,label=sprintf("%s rank:\n#%s (%spts)",away,rank,points)),color="#a2eacb",size=7,hjust=0)+
    geom_text(data=data_temp[team==home],aes(x=-points+ifelse(points>1000,45,-280),y=0.23,label=sprintf("%s rank:\n#%s (%spts)",home,rank,points)),color="#551fbd",size=7,hjust=0)+
    
    geom_jitter(aes(y=0,x=-points,color=dummy,alpha=alpha_dummy,size=alpha_dummy),stat="identity",height=.05)+
    scale_alpha(range=c(0.65,1))+
    scale_size(range=c(3,5))+
    theme(axis.title = element_blank()
          ,axis.ticks = element_blank()
          ,panel.grid = element_blank()
          ,axis.text.y = element_blank()
          ,axis.text.x = element_blank()
          ,panel.background = element_blank()
          ,legend.position="none"
    ) +
    ylim(c(-.05,.25))+
    xlim(c(-max(data_temp$points),-min(data_temp$points)+100))+
    scale_color_manual(values=c("#551fbd","#a2eacb","#cecece"))
}


#rankings_shiny_graph(df,"croatia","australia")