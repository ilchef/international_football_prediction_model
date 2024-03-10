ti_shiny_layout <- function(mainUI){
  header <- tagList(
    img(src = "fifa.png", class = "logo"),
    div(Text(variant = "xLarge", " | International Mens Football Prediction Model"), class = "title")#,
    # CommandBar(
    #   items = list(
    #     CommandBarItem("New", "Add", subitems = list(
    #       CommandBarItem("Email message", "Mail", key = "emailMessage", href = "mailto:me@example.com"),
    #       CommandBarItem("Calendar event", "Calendar", key = "calendarEvent")
    #     )),
    #     CommandBarItem("Upload sales plan", "Upload"),
    #     CommandBarItem("Share analysis", "Share"),
    #     CommandBarItem("Download report", "Download")
    #   ),
    #   farItems = list(
    #     CommandBarItem("Grid view", "Tiles", iconOnly = TRUE),
    #     CommandBarItem("Info", "Info", iconOnly = TRUE)
    #   ),
    #   style = list(width = "100%"))
    )
  
  navigation <- Nav(
    groups = list(
      list(links = list(
        list(name = 'Model Prediction', url = '#!/', key = 'home', icon = 'Soccer'),
        list(name = 'Model Performance: (coming soon)', url = '#!/other', key = 'analysis', icon = 'Chart'),
        list(name = 'My Github', url = 'https://github.com/ilchef/ilchef', key = 'repo', icon = 'GitGraph'),
        list(name = 'My Linkedin', url = 'https://www.linkedin.com/in/thomas-ilchef-b4a19b142/', key = 'shinyreact', icon = 'LinkedinLogo')
      ))
    ),
    initialSelectedKey = 'home',
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