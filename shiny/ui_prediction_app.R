ui_prediction_app <- shinyUI(fluidPage(
  

  includeCSS("shiny/css/shiny_css.css"),
  HTML("<h3>International Men's Football Prediction Model:</h3>"),
  fluidRow(
    column(12,
           
           div(id = "app_info", class = "collapse out", 
               p("Fill out later with more detail. See:"),             
               tags$a(href = "https://www.wikipedia.com"),
               p(""),
           ),
           
           
           
           HTML("<button type='button' class='btn' data-toggle='collapse' style='float:left' data-target='#app_info'><span class='glyphicon glyphicon-collapse-down'></span> More Information</button>"),
           
           br(),  br(), 
           
           
    )),
  fluidRow(
    column(12,
           h3("User Input:"),
           shinyWidgets::switchInput(
        "neutral_grounds", "Played on Neutral Grounds", onStatus = "success", width = "500px", labelWidth = "200px"
      )
    ),
  ),
  fluidRow(
    column(6,selectInput("home_team", "Select Home Team:", choices = country_list, selected = "france")),
    column(6,selectInput("away_team", "Select Away Team:", choices = country_list, selected = "brazil")),
    br()
  ),
  
  
  fluidRow(
    column(12,
           br(),
           h3("Model Output:"),
           radioGroupButtons(
             inputId = "output_metric",
             label = "Select Metric:", 
             choices = c("Show in logit space","Show as probability"),
             #choices = c("Show Probabilities","Show Fair-market Price (Reciprocal)"),
             status = "primary"
           ),
           plotOutput("outcome_graph",width="1000px"),
           p("")
    )),
)
)
