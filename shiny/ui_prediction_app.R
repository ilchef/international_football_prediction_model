ui_prediction_app <- shinyUI(fluidPage(
  
  # tags$head(
  #   includeCSS("www/styles.css")
  # ),
  # 
  # tags$head(
  #   includeScript("www/ggcircos.js")
  # ),
  
  HTML("<h3>International Men's Football Prediction Model:</h3>"),
  fluidRow(
    column(7,
           
           div(id = "app_info", class = "collapse out", 
               p("Fill out later with more detail. See:"),             
               tags$a(href = "https://www.wikipedia.com"),
               p(""),
           ),
           
           
           
           HTML("<button type='button' class='btn' data-toggle='collapse' style='float:left' data-target='#app_info'><span class='glyphicon glyphicon-collapse-down'></span> More Information</button>"),
           
           br(),  br(), 
           
           
    ),
    
    column(5,
           br(),
           
           div(id = "genes_div"),
           
           div(id = "transcripts_div"),
           
           div(id = "clinvar_div"),
           
           h4("Match Input:"),
           br(),   
           
           selectInput("home_team", "Select Home Team:", choices = c("blah blah","??"), selected = "DO49184"),
           
           br(),   
           
           selectInput("away_team", "Select Away Team:", choices = c("blah blah","??"), selected = "DO49184"),
           
           br(),
           
           column(3, shinyWidgets::switchInput(
             "", "Played on Neutral Grounds", onStatus = "success"
           ), style = "padding-top: 25px;"),
           
           p("")
    )),
  fluidRow(column(12,HTML("<br><div class='footer'></div><br>")))
)
)
