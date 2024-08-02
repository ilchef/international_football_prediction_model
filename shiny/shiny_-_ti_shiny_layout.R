ti_shiny_layout <- function(mainUI){
  header <- tagList(
    img(src = "fifa.png", class = "logo"),
    div(Text(variant = "xLarge", " | International Mens Football Prediction Model"), class = "title")
    )
  
  navigation <- Nav(
    groups = list(
      list(links = list(
        list(name = 'Model Prediction', url = '/', key = 'home_page', icon = 'Soccer'),
        list(name = 'Model Performance: (coming soon)', url = '/monitoring', key = 'monitoring_page', icon = 'Chart'),
        list(name = 'My Github', url = 'https://github.com/ilchef/ilchef', key = 'repo', icon = 'GitGraph'),
        list(name = 'My Linkedin', url = 'https://www.linkedin.com/in/thomas-ilchef-b4a19b142/', key = 'shinyreact', icon = 'LinkedinLogo')
      ))
    ),
    initialSelectedKey = 'home_page',
    styles = list(
      root = list(
        height = '100%',
        boxSizing = 'border-box',
        overflowY = 'auto'
      )
    )
  )
  
  
  
  
  div(class = "grid-container",
      div(class = "header", header),
      div(class = "sidenav", navigation),
      div(class = "main", mainUI)
  )
}