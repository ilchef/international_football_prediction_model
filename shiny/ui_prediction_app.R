pageButtonUi <- function(id) {
  actionButton(NS(id, "page_change"),
               label="Change the Page")
}

ui <- navbarPage(
  title="International Mens Football Prediction:",
  id="pages",
  tabPanel(title="Model Implementation",
           sidebarLayout(
             sidebarPanel(
               fluidRow(width=2
                 ,column(12,
                        h3("User Input:")
                        ,shinyWidgets::switchInput(
                          "neutral_grounds", "Neutral Grounds", onStatus = "success", width = "500px", labelWidth = "200px"
                        )
                        ,selectInput("home_team", "Select Home Team:", choices = country_list, selected = "morocco")
                        ,selectInput("away_team", "Select Away Team:", choices = country_list, selected = "denmark")
                 )
               )
             ),
             mainPanel(
               fluidRow(width=10,
                        column(4,
                               h3("Model Output:"),
                               radioGroupButtons(
                                 inputId = "output_metric",
                                 label = "Select Metric:", 
                                 choices = c("Show Probabilities","Show Market Price"),
                                 status = "primary"
                               ),
                               plotOutput("outcome_graph",width="100%",height="250px")
                               
                        )
                        ,column(8,
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
                        ,fluidRow(
                          column(12,
                                 h3(paste0("Latest rankings")),
                                 plotly::plotlyOutput("rankings_graph",width="100%",height="250px")
                          )
                        )
                        )
               
             )
           )
  )
  ################################################################################
  ,tabPanel(title="Model Diagnostics"
            ,sidebarLayout(
              sidebarPanel(width=5
                  ,fluidRow(
                    selectInput("monitoring_pop", "Select Monitoring Population:"
                                , choices = c("All","Training","Out-of-sample")
                                , selected = "All")
                  )
              )
              ,mainPanel(width=7
                ,fluidRow(width=12
                  ,plotlyOutput("roc_plot")
                  
                )
              )
           )
  )
  ,includeCSS("shiny/css/shiny_css.css")
  
)

