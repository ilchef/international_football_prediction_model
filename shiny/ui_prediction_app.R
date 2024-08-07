home_page <- makePage(
  title="Trained on scraped data up to:"
  ,subtitle=format(run_date,"%b-%Y")
  ,contents=div(
    fluidRow(
      column(2,
             h3("User Input:")
             ,shinyWidgets::switchInput(
               "neutral_grounds", "Neutral Grounds", onStatus = "success", width = "500px", labelWidth = "200px"
             )
             ,selectInput("home_team", "Select Home Team:", choices = country_list, selected = "morocco")
             ,selectInput("away_team", "Select Away Team:", choices = country_list, selected = "denmark")
             
      )
      ,column(4,
              h3("Model Output:"),
              radioGroupButtons(
                inputId = "output_metric",
                label = "Select Metric:", 
                choices = c("Show Probabilities","Show Market Price"),
                status = "primary"
              ),
              plotOutput("outcome_graph",width="100%",height="250px")
              
      )
      ,column(6,
              h3("Last 9 Matches:"),
              column(6,
                     h4(textOutput("home_team_name")),    
                     DT::dataTableOutput('home_dt',width="100%")
              ),
              column(6,
                     h4(textOutput("away_team_name")),    
                     DT::dataTableOutput('away_dt',width="100%")
              )
              
      )
    )
    ,fluidRow(
      column(12,
             h3(paste0("Latest rankings")),
             plotly::plotlyOutput("rankings_graph",width="100%",height="250px")
      )
    )
  )
)


ui_prediction_app <- shinyUI(fluidPage(
  
  includeCSS("shiny/css/shiny_css.css"),
  ti_shiny_layout(
    home_page
  )
)
)
