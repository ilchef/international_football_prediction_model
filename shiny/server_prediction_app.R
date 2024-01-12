server_prediction_app <- function(input,output){
  
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
      normalise_neutral_prediction(prediction_normal(),prediction_inverse()) %>% melt()
    } else {
      prediction_normal() %>% melt()
    }
  })
  
  
  
  ############################################################################
  
  # Part 2: Last x matches summary table
  
  ############################################################################
  
  # Part 3: Outcome Graph
  
  outcome_graph <- reactive({
    prediction_final() %>%
      setDT() %>%
      .[,variable:=case_when(variable=="home.win"~paste0(input$home_team," win"),variable=="tie"~"tie",TRUE~paste0(input$away_team," win"))]%>%
      .[,variable:=fct_relevel(variable,c(paste0(input$home_team," win"),"tie"))]%>%
      ggplot() + 
      geom_bar(aes(x=variable,y=value,fill=variable),stat="identity") +
      # These variables are unique to prob vs odds
      geom_text(aes(x=variable,y=value+0.05,label=scales::percent(value,accuracy=0.01L)),size=7)+
      ylim(c(0,1.06))+
      #########3
      theme(axis.title = element_blank()
            ,axis.ticks = element_blank()
            ,panel.grid = element_blank()
            ,axis.text.y = element_blank()
            ,axis.text.x = element_text(size=17,color="black",face="bold")
            ,panel.background = element_blank()
            ) +
      scale_fill_manual(values=c("#551fbd","#cecece","#a2eacb"))
            
  })

  ############################################################################
  
  # Part X: Output
  
  
  output$outcome_graph <- renderPlot({
    outcome_graph()
  })
}