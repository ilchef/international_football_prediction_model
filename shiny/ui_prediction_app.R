# pageButtonUi <- function(id) {
#   actionButton(NS(id, "page_change"),
#                label="Change the Page")
# }

ui <- navbarPage(
  title="International Mens Football Prediction:",
  id="pages",
  header=tags$head(tags$link(rel = "stylesheet", href = "https://use.fontawesome.com/releases/v5.15.4/css/all.css")),
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
                  ,fluidRow(
                    h3("Model Structure:", style = "margin-top: 20px;")
                    ,plotOutput("model_structure")
                    ,p("The prediction model is a fully-connected feedforward neural network (FFNN), configured to predict multiclass probabilities across Win, Lose or Draw (the three outcomes of a football match).")
                    ,p("The input layer consists of twelve variables that drive the prediction ")
                    ,p("The simple hidden layer consists of eight neurons, each fully connected to all twelve of the input variables. A weighted, linear function is calculated - and passed through a non-linear function (in this instance, the sigmoid function). This induced non-linearity allows the network to pick up complex relationships between one or more predictors, and the outcome.")
                    ,p("The output layer consists of the three outcomes: Win, Loss or Tie. Each are connected to all eight of the hidden layers, and are passed through the softmax activation function - ensuring the probabilities of all classes equal to 1 for a given prediction.")
                    
                  )
              )
              ,mainPanel(width=7
                ,fluidRow(width=12
                  ,plotlyOutput("roc_plot")
                )
              )
           )
  )
  ################################################################################
  ,tabPanel(title="More Info",
            fluidRow(
              column(8, offset = 2,
                     div(class = "info-container",
                         h2("About the Author", class = "section-header"),
                         p("Thank you for visiting my Football Prediction application. Connect with me on social media to learn more about my work:"),
                         
                         # Social Links Container
                         div(class = "social-links",
                             # LinkedIn Link
                             tags$a(
                               href = "https://www.linkedin.com/in/thomas-ilchef-b4a19b142/",
                               target = "_blank",
                               class = "social-button linkedin",
                               tags$i(class = "fab fa-linkedin"),
                               "Connect on LinkedIn"
                             ),
                             
                             # GitHub Link
                             tags$a(
                               href = "https://github.com/ilchef/international_football_prediction_model",
                               target = "_blank",
                               class = "social-button github",
                               tags$i(class = "fab fa-github"),
                               "View project on GitHub"
                             )
                         )
                     )
                  )
                )
            )
  ,includeCSS("shiny/css/shiny_css.css")
)

