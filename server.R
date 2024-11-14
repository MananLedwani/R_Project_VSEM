server <- function(input, output, session) {
  
  # Link the Get Started button to the Predict AQI tab
  observeEvent(input$start, {
    updateTabItems(session, "tabs", "predict")
  })
  
  # Prediction and AQI Calculation
  observeEvent(input$predict_btn, {
    req(input$date_input, input$hour_input, input$minute_input)
    date_time <- paste(input$date_input, sprintf("%02d:%02d", as.numeric(input$hour_input), as.numeric(input$minute_input)))
    
    forecast_data <- forecast_or_return_data(date_time)
    
    if (!is.null(forecast_data)) {
      aqi <- forecast_data$AQI
      
      output$results <- renderPrint({
        list(Predicted_Values = forecast_data, AQI = aqi)
      })
    } else {
      output$results <- renderPrint("Date not found in dataset.")
    }
  })
  
  # Data Table
  output$data_table <- renderDataTable({
    datatable(df %>% select(date, co, no, no2, o3, so2, pm2_5, pm10, nh3, AQI))
  })
  
  # Analysis Plot for Selected Gas/AQI
  observeEvent(input$view_graph, {
    req(input$gas_selection, input$date_input, input$hour_input, input$minute_input)
    date_time <- paste(input$date_input, sprintf("%02d:%02d", as.numeric(input$hour_input), as.numeric(input$minute_input)))
    
    forecast_data <- forecast_or_return_data(date_time)
    
    output$trend_plot <- renderPlot({
      selected_gas <- input$gas_selection
      historical_data <- df %>% select(date, all_of(selected_gas))
      
      plot_data <- historical_data %>%
        ggplot(aes(x = date, y = get(selected_gas))) +
        geom_line(color = "#1E90FF", size = 1, aes(label = "Existing Values")) +
        geom_point(data = data.frame(date = as.POSIXct(date_time),
                                     predicted = forecast_data[[selected_gas]]),
                   aes(x = date, y = predicted), color = "red", size = 3, label = "Predicted Value") +
        labs(title = paste("Historical and Forecasted Values for", selected_gas), 
             x = "Date", y = selected_gas) +
        theme_minimal() +
        scale_color_manual(values = c("Existing" = "#1E90FF", "Predicted" = "red")) +
        guides(color = guide_legend("Legend"))
      
      plot_data
    })
  })
}
