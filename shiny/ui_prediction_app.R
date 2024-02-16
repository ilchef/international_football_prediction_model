ui_prediction_app <- shinyUI(fluidPage(
  

  includeCSS("shiny/css/shiny_css.css"),
  HTML("<h3>International Men's Football Prediction Model:</h3>"),
  fluidRow(
    column(12,
           
           div(id = "app_info", class = "collapse out", 
               p(paste0("Reflecting data up to ",format(run_date,"%b-%Y",))),             
               tags$a(href = "https://www.wikipedia.com"),
               p(""),
           ),
           
           
           
           HTML("<button type='button' class='btn' data-toggle='collapse' style='float:left' data-target='#app_info'><span class='glyphicon glyphicon-collapse-down'></span> More Information</button>"),
           
           
           
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
    column(4,selectInput("home_team", "Select Home Team:", choices = country_list, selected = "morocco")),
    column(4,selectInput("away_team", "Select Away Team:", choices = country_list, selected = "denmark")),
  ),
  
  
  fluidRow(
    column(4,
           h3("Model Output:"),
           radioGroupButtons(
             inputId = "output_metric",
             label = "Select Metric:", 
             choices = c("Show Probabilities","Show Market Price"),
             status = "primary"
           ),
           plotOutput("outcome_graph",width="100%",height="250px")

           
           
           
    ),
    column(8,
           h3("Last 9 Matches:"),
           column(4,
                  h4(textOutput("home_team_name")),    
                  DT::dataTableOutput('home_dt',width="100%")
           ),
           column(4,
                  h4(textOutput("away_team_name")), 
                  DT::dataTableOutput('away_dt',width="100%")
           )
           )
  ),
  fluidRow(
    column(12,
           h3(paste0("Latest rankings")),
           plotly::plotlyOutput("rankings_graph",width="100%",height="350px")
           )
  )

)
)
