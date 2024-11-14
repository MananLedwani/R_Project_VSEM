ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(title = "Delhi Air Quality Prediction"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("info-circle")),
      menuItem("Predict AQI", tabName = "predict", icon = icon("chart-line")),
      menuItem("View Data", tabName = "data", icon = icon("table")),
      menuItem("Analysis", tabName = "analysis", icon = icon("chart-area"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .main-header .logo {
          font-family: 'Montserrat', sans-serif;
          font-weight: bold;
        }
        .box {
          border-top: 2px solid #1E90FF;
          border-radius: 10px;
          box-shadow: 0px 0px 15px rgba(0,0,0,0.1);
        }
        .content-wrapper {
          background-color: #f4f6f9;
        }
        .selectize-input {
          font-size: 16px;
        }
        .splash {
          text-align: center;
          padding-top: 50px;
        }
      "))
    ),
    
    tabItems(
      # Splash Screen
      tabItem(tabName = "intro",
              fluidPage(
                tags$div(class = "splash",
                         h1("Welcome to the Delhi Air Quality Predictor"),
                         p("This application uses predictive modeling to forecast AQI levels and individual gas concentrations."),
                         actionButton("start", "Get Started", class = "btn-primary")
                )
              )
      ),
      
      # Prediction Tab
      tabItem(tabName = "predict",
              fluidPage(
                box(title = "Select Date and Time for Prediction", width = 4,
                    dateInput("date_input", "Select Date:", format = "yyyy-mm-dd"),
                    selectInput("hour_input", "Select Hour:", choices = sprintf("%02d", 0:23)),
                    selectInput("minute_input", "Select Minute:", choices = sprintf("%02d", seq(0, 55, by = 5))),
                    actionButton("predict_btn", "Predict AQI", class = "btn-success")),
                
                box(title = "Prediction Results", width = 8,
                    verbatimTextOutput("results"),
                    plotOutput("forecast_plot", height = 300))
              )
      ),
      
      # Data Tab
      tabItem(tabName = "data",
              fluidPage(
                box(title = "Air Quality Data", width = 12,
                    dataTableOutput("data_table"))
              )
      ),
      
      # Analysis Tab with Select Input for Gas
      tabItem(tabName = "analysis",
              fluidPage(
                box(title = "Select Gas or AQI to View Trends", width = 4,
                    selectInput("gas_selection", "Select Gas/AQI:", choices = c("co", "no", "no2", "o3", "so2", "pm2_5", "pm10", "nh3", "AQI")),
                    actionButton("view_graph", "View Graph", class = "btn-info")),
                
                box(title = "Gas/AQI Trend Analysis", width = 8,
                    plotOutput("trend_plot", height = 400))
              )
      )
    )
  )
)
