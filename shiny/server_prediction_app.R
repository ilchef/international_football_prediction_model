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
      .[,variable:=fct_relevel(variable,c("home.win","tie","away.win"))]%>%
      ggplot() + 
      geom_bar(aes(x=variable,y=value),stat="identity") +
      # These variables are unique to prob vs odds
      geom_text(aes(x=variable,y=value+0.05,label=scales::percent(value,accuracy=0.01L)))+
      ylim(c(0,1))+
      #########3
      theme(axis.title = element_blank()
            ,axis.ticks = element_blank()
            ,panel.grid = element_blank()
            ,axis.text.y = element_blank()
            ,panel.background = element_blank()
            )
            
  })

  ############################################################################
  
  # Part X: Output
  
  
  output$outcome_graph <- renderPlot({
    outcome_graph()
  })
}