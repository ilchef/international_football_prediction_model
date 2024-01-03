server_prediction_app <- function(input,output){
  
  # Reactive Prediction
  temp <- reactive({two_countries_data_prep(data,home_team=input$home_team,away_team=input$away_team,input$neutral_grounds)})
  
  # Normalise neutral grounds prediction
  # home Country 1 vs away Country 2 should be the same as home Country 2 vs away Country 1 for neutral grounds
  # i.e. concept of a 'home' country doesnt exist on neutral matches
  # note: the model is actually already really good at doing this, but there is a small error equivalent to 0.5-1%
  reactive({
    if(input$neutral_grounds){
      temp_inverse <- reactive({two_countries_data_prep(data,home_team=input$away_team,away_team=input$home_team,input$neutral_grounds)})
      
      #Make Prediction
      prediction <- reactive({
        data.frame(as.list(predict(mod_obj,type="probs",newdata=temp())))
      })
      prediction_inverse <- reactive({
        data.frame(as.list(predict(mod_obj,type="probs",newdata=temp_inverse())))
      })
      prediction_norm <- normalise_neutral_prediction(prediction(),prediction_inverse())
      
      
    } else {
      #Make Prediction
      prediction <- reactive({
        data.frame(as.list(predict(mod_obj,type="probs",newdata=temp())))
      })
    }
  })
  
  
  
  output$prediction <- renderTable({
    data.frame(as.list(predict(mod_obj,type="probs",newdata=temp())))
  })
  
}