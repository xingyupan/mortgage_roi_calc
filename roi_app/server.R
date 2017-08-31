#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/mortgage.R")
source("global.r")


shinyServer(function(input, output) {

  k15<- reactive({
    get_mortgage_calc(
      input$home_price, input$downpay_pct/100, input$int_rate_15, 15, 10, input$growth_rate,
      input$tax_rate, input$ins_rate)
  })

  k30<- reactive({
    get_mortgage_calc(
      input$home_price, input$downpay_pct/100, input$int_rate_30, 30, 10, input$growth_rate,
      input$tax_rate, input$ins_rate)
  })
  output$plot_15 <- renderPlot({

    #browser()
    plot_input = k15()$out_d
    print(plot_input)
    plot(plot_input$year, plot_input$roi,
         xlab="", ylab="", ylim=c(0,1), axes=F,
         type = "b", col='black', main= sprintf("Monthly payment: $%d", round(k15()$monthly_payment,0))
         )
    axis(2, ylim= c(0,1), col="black", las=1)
    mtext("ROI over time", side=2, line=2.5)
    box()
    par(new=T)
    plot(plot_input$year, plot_input$ownership_pct, pch=15,
         xlab="", ylab="", ylim=c(0,1),
         axes=F , type ="b", col="red")
    mtext("Ownership % over time", side=4, col="red", lin=4)
    axis(4, ylim=c(0,1), col="red", col.axis="red", las=1)
    
    axis(1, pretty(range(plot_input$year), 10))
    mtext("Year", side=1, col="black", line=2.5)
    
  })

  output$plot_30 <- renderPlot({
    #browser()
    plot_input = k30()$out_d
    print(plot_input)
    plot(plot_input$year, plot_input$roi, ylim=c(0,1), axes=F,
         xlab="", ylab="",
         type = "b", col='black', main= sprintf("Monthly payment: $%d", round(k30()$monthly_payment,0))
    )
    axis(2, ylim= c(0,1), col="black", las=1)
    mtext("ROI over time", side=2, line=2.5)
    box()
    par(new=T)
    plot(plot_input$year, plot_input$ownership_pct, pch=15,
         xlab="", ylab="", ylim=c(0,1),
         axes=F , type ="b", col="red")
    mtext("Ownership % over time", side=4, col="red", lin=4)
    axis(4, ylim=c(0,1), col="red", col.axis="red", las=1)
    
    axis(1, pretty(range(plot_input$year), 10))
    mtext("Year", side=1, col="black", line=2.5)
    
  })
  output$comp_table<-renderTable({
    dout<- data.frame(
      year = k15()$out_d$year,
      estim_home_value = round(k15()$out_d$current_property_value,0),
      ownership_15yr = round(k15()$out_d$ownership_pct,2),
      ownership_30yr = round(k30()$out_d$ownership_pct,2),
      tot_payment_15yr = round(k15()$out_d$total_payment,0),
      tot_payment_30yr = round(k30()$out_d$total_payment,0),
      roi_15yr = round(k15()$out_d$roi,2),
      roi_30yr = round(k30()$out_d$roi,2)      
    )
    dout
  })
})
