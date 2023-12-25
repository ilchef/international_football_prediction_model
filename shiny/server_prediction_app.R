server_prediction_app <- function(input,output){
  
  temp <- reactive({two_countries_data_prep(data,home_team=input$home_team,away_team=input$away_team,input$neutral_grounds)})
  
  output$prediction <- renderTable({
    data.frame(as.list(predict(mod_obj,type="probs",newdata=temp())))
  })
  
}