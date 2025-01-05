server_prediction_app <- function(input,output){
  
  
  ############################################################################
  
  # Part 1: Reactive Prediction
  
  temp <- reactive({two_countries_data_prep(data,home_team=input$home_team,away_team=input$away_team,input$neutral_grounds)})
  
  
  # Normalise neutral grounds prediction
  # home Country 1 vs away Country 2 should be the same as home Country 2 vs away Country 1 for neutral grounds
  # i.e. concept of a 'home' country doesnt exist on neutral matches
  # note: the model is actually already really good at doing this, but there is a small error equivalent to 0.5-1%
  temp_inverse <- reactive({two_countries_data_prep(data,home_team=input$away_team,away_team=input$home_team,input$neutral_grounds)})
  
  #Make Prediction
  prediction_normal <- reactive({
        data.frame(predict(mod_obj$model,type="raw",newdata=temp()))
  })
  prediction_inverse <- reactive({
        data.frame(predict(mod_obj$model,type="raw",newdata=temp_inverse()))
  })
  
  prediction_final <- reactive({
    if(input$neutral_grounds){
      normalise_neutral_prediction(prediction_normal(),prediction_inverse()) %>% setDT()%>%melt()
    } else {
      prediction_normal() %>% setDT() %>%melt()
    }
  })
  
  #  Data Prep
  prediction_final_reformat <- reactive({
    prediction_final() %>%
      setDT()%>%
      copy()%>%
      .[,fmp:=1/value]%>%
      .[,variable:=case_when(variable=="homewin"~paste0(input$home_team," win"),variable=="tie"~"tie",TRUE~paste0(input$away_team," win"))]%>%
      .[,variable:=fct_relevel(variable,c(paste0(input$home_team," win"),"tie"))] %>%
      .[,metric:= case_when(input$output_metric=="Show Market Price"~fmp,TRUE~value)]
  })
  
  ############################################################################
  
  # Part 2: Last x matches summary table
  
  home_lastn <- reactive({
    last_n_matches %>%
      copy() %>%
      .[record_country==input$home_team] %>%
      .[order(-date)]%>%
      .[,date := format(date,"%d/%m/%y")]%>%
      .[,.(opponent,date,outcome)] 
    })
  
  output$home_dt <- renderDataTable(
    datatable(home_lastn(),options = list(dom = 't',ordering=F),colnames=NULL,rownames=FALSE,selection='single')%>%
      formatStyle(columns=colnames(home_lastn()),backgroundColor="white",alpha=0.5)%>%
      formatStyle("outcome"
                  ,backgroundColor = styleEqual(c("win","tie","loss"),c("#9ADD6F","white","#FFA4A4"))
                  ,alpha=0.5) %>%
      formatStyle(columns =names(home_lastn()),fontSize = '80%')
    ,server=FALSE
    )
  
  home_team_name <- reactive({input$home_team})
  output$home_team_name <- renderText({home_team_name()})
  
  away_lastn <- reactive({
    last_n_matches %>%
      copy() %>%
      .[record_country==input$away_team] %>%
      .[order(-date)]%>%
      .[,date := format(date,"%d/%m/%y")]%>%
      .[,.(opponent,date,outcome)] 
  })
  
  output$away_dt <- renderDataTable(
    datatable(away_lastn(),options = list(dom = 't',ordering=F),colnames=NULL,rownames=FALSE,selection='single') %>%
      formatStyle(columns=colnames(away_lastn()),backgroundColor="white",alpha=0.5)%>%
      formatStyle("outcome"
                  ,backgroundColor = styleEqual(c("win","tie","loss"),c("#9ADD6F","white","#FFA4A4"))
                  ,alpha=.5) %>%
      formatStyle(columns =names(away_lastn()),fontSize = '80%')
    ,server=FALSE
    )
  
  # single selection DT
  proxyList <- reactive({
    proxies = list()
    i<-1
    for (tableID in c("home_dt","away_dt")){
      proxies[[i]] = dataTableProxy(tableID)
      i<-i+1
    }
    return(proxies)
  }) 
  
  reactiveSelection <- reactive({
    rownumhome<- input$home_dt_rows_selected
    rownumaway <- input$away_dt_rows_selected
    if (length(rownumhome) > 0){return(c(rownumhome, 1))}
    if (length(rownumaway ) > 0){return(c(rownumaway , 2))}
  })
  
  away_team_name <- reactive({input$away_team})
  output$away_team_name <- renderText({away_team_name()})
  
  
  ############################################################################
  
  # Part 3: Monitoring
  # auroc
  monitoring_data <- reactive({
    if(input$monitoring_pop=="All"){
      mod_obj$gini_tab %>% .[cat=="all"]%>%
        copy()%>%
        .[,cat:=NULL]%>%
        melt(id.vars=c("year"))
    } else if(input$monitoring_pop=="Training") {
      mod_obj$gini_tab %>% .[cat=="train"]%>%
        copy()%>%
        .[,cat:=NULL]%>%
        melt(id.vars=c("year"))
    } else {
      mod_obj$gini_tab %>% .[cat=="test"]%>%
        copy()%>%
        .[,cat:=NULL]%>%
        melt(id.vars=c("year"))
    }
    })
  
  roc_plot<- reactive({
    ggplotly(
      monitoring_data() %>%
      .[,AUROC:=sprintf("AUROC: %.1f%%",value*100)]%>%
      .[,variable:=case_when(variable=="home_gini"~"Home Classifier",variable=="away_gini"~"Away Classifier",TRUE~"Tie Classifier")]%>%
      ggplot(aes(x=year,y=value,color=variable,group=variable,text=AUROC))+
      geom_line()+
      theme(
          panel.background = element_blank()
          ,panel.grid.major = element_blank()
          ,panel.grid.minor = element_blank()
          ,panel.border = element_rect(colour="black",fill=NA)
          ,axis.title.x=element_blank()
          ,axis.line = element_line(color="black")
          ,axis.ticks = element_line(color="black")
          ,legend.title=element_blank()
      )+
      ggtitle("Discrimination by Sub-model")+
      ylab("Area under ROC")+
      scale_color_manual(values=c("#551fbd","#a2eacb","#cecece"))+
      scale_y_continuous(labels = scales::percent,limits=c(0,1))
      ,tooltip = c("year","text")
    )
  })
  
  # calibration
  calibration_data <- reactive({
    if(input$monitoring_pop=="All"){
      mod_obj$cal %>% .[cat=="all"] 
    } else if(input$monitoring_pop=="Training") {
      mod_obj$cal %>% .[cat=="train"]
    } else {
      mod_obj$cal %>% .[cat=="test"]
    }
  })
  
  calibration_plot <- reactive({
    calibration_data()
  })
  
  ############################################################################
  
  # Part 4: Graphs
  
  # Max fmp
  max_fmp<- reactive({max(prediction_final_reformat()$fmp)})
  
  outcome_graph <- reactive({
    if(input$output_metric=="Show Market Price"){ # If we are using fmp
      initial_shiny_graph(prediction_final_reformat()) +
        geom_text(aes(x=variable,y=metric+0.05*max_fmp(),label=round(metric,3)),size=7)+
        geom_hline(aes(yintercept=1),color="red",linetype=2)+
        ylim(c(0,max_fmp()*1.1))
    } else{ # Else probabilities
      initial_shiny_graph(prediction_final_reformat()) +
        geom_text(aes(x=variable,y=metric+0.05,label=scales::percent(metric,accuracy=0.01L)),size=7)+
        ylim(c(0,1.05))
    }
  })
  
  rankings_graph <- reactive({
    rankings_shiny_graph(df=data,home=input$home_team,away=input$away_team)
  })
  
  
  ############################################################################
  
  # Part X: Output
  
  
  output$outcome_graph <- renderPlot({
    outcome_graph()
  })
  
  output$rankings_graph <- plotly::renderPlotly({
    rankings_graph()
  })
  
  
  output$roc_plot <- plotly::renderPlotly({roc_plot()})
  
  output$model_structure <- renderPlot({mod_obj$model_structure})
  ############################################################################
  
  # Part X: garbage
  
  
}