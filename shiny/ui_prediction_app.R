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
           
           br(),  
           
           
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
    column(4,selectInput("home_team", "Select Home Team:", choices = country_list, selected = "netherlands")),
    column(4,selectInput("away_team", "Select Away Team:", choices = country_list, selected = "denmark")),
    br()
  ),
  
  
  fluidRow(
    column(12,
           h3("Model Output:"),
           radioGroupButtons(
             inputId = "output_metric",
             label = "Select Metric:", 
             choices = c("Show Probabilities","Show Fair-market Price (Reciprocal)"),
             status = "primary"
           ),
           plotOutput("outcome_graph",width="800px",height="300px"),
           plotOutput("rankings_graph",width="80%",height="250px"),
           br(),
           h3("Last 9 Matches:"),
           column(4,
              h4(textOutput("home_team_name")),    
              DT::dataTableOutput('home_dt')
           ),
           column(4,
                  h4(textOutput("away_team_name")), 
                  DT::dataTableOutput('away_dt')
           )
           
    )),
)
)
