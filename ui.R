# ui.R
library(shiny)

nifty_50_symbols <- c(
  "RELIANCE.NS", "TCS.NS", "HDFCBANK.NS", "INFY.NS", "ICICIBANK.NS",
  "HINDUNILVR.NS", "SBIN.NS", "BAJFINANCE.NS", "KOTAKBANK.NS", "LT.NS",
  "ADANIPORTS.NS", "AXISBANK.NS", "ASIANPAINT.NS", "BHARTIARTL.NS", "M&M.NS",
  "TITAN.NS", "ULTRACEMCO.NS", "NTPC.NS", "HCLTECH.NS", "POWERGRID.NS",
  "BAJAJFINSV.NS", "JSWSTEEL.NS", "NESTLEIND.NS", "WIPRO.NS", "GRASIM.NS",
  "HDFCLIFE.NS", "ADANIENT.NS", "COALINDIA.NS", "ONGC.NS", "DIVISLAB.NS",
  "SUNPHARMA.NS", "CIPLA.NS", "TECHM.NS", "SBILIFE.NS", "LTIM.NS",
  "APOLLOHOSP.NS", "EICHERMOT.NS", "BPCL.NS", "MARUTI.NS", "SHREECEM.NS",
  "TATACONSUM.NS", "HEROMOTOCO.NS", "INDUSINDBK.NS", "UPL.NS", "DMART.NS",
  "TATAMOTORS.NS", "HINDALCO.NS", "IOC.NS", "DRREDDY.NS", "ADANIPOWER.NS"
)

ui <- fluidPage(
  titlePanel("Nifty 50 Stock Data"),
  tabsetPanel(
    tabPanel("Stock Data",
      sidebarLayout(
        sidebarPanel(
          selectInput("stock", "Select Stock", choices = nifty_50_symbols),
          dateInput("start_date", "Start Date", value = Sys.Date() - 365),
          dateInput("end_date", "End Date", value = Sys.Date()),
          actionButton("get_data", "Get Stock Data")
        ),
        mainPanel(
          plotOutput("stock_plot"),
          dataTableOutput("stock_table")
        )
      )
    ),
    tabPanel("Stock vs Nifty",
      sidebarLayout(
        sidebarPanel(
          selectInput("stock_nifty", "Select Stock", choices = nifty_50_symbols),
          dateInput("start_date_nifty", "Start Date", value = Sys.Date() - 365),
          dateInput("end_date_nifty", "End Date", value = Sys.Date()),
          actionButton("get_data_nifty", "Get Stock and Nifty Data")
        ),
        mainPanel(
          plotlyOutput("stock_nifty_plot")
        )
      )
    )
  )
)
