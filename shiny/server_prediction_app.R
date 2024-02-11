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
        data.frame(as.list(predict(mod_obj,type="probs",newdata=temp())))
  })
  prediction_inverse <- reactive({
        data.frame(as.list(predict(mod_obj,type="probs",newdata=temp_inverse())))
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
      .[,variable:=case_when(variable=="home.win"~paste0(input$home_team," win"),variable=="tie"~"tie",TRUE~paste0(input$away_team," win"))]%>%
      .[,variable:=fct_relevel(variable,c(paste0(input$home_team," win"),"tie"))] %>%
      .[,metric:= case_when(input$output_metric=="Show Fair-market Price (Reciprocal)"~fmp,TRUE~value)]
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
    datatable(home_lastn(),options = list(dom = 't',ordering=F),colnames=NULL,rownames=FALSE)%>%
      formatStyle("outcome",backgroundColor = styleEqual(c("win","tie","loss"),c("#9ADD6F","#F5EF8E","#FFA4A4")))
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
    datatable(away_lastn(),options = list(dom = 't',ordering=F),colnames=NULL,rownames=FALSE) %>%
      formatStyle("outcome",backgroundColor = styleEqual(c("win","tie","loss"),c("#9ADD6F","#F5EF8E","#FFA4A4")))
    ,server=FALSE
    )
  
  away_team_name <- reactive({input$away_team})
  output$away_team_name <- renderText({away_team_name()})
  

  ############################################################################
  
  # Part 3: Graphs
  
  # Max fmp
  max_fmp<- reactive({max(prediction_final_reformat()$fmp)})
  
  outcome_graph <- reactive({
    if(input$output_metric=="Show Fair-market Price (Reciprocal)"){ # If we are using fmp
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
  
  output$rankings_graph <- renderPlot({
    rankings_graph()
  })
}