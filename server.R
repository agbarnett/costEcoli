# for cost of resistant e-coli
# Feb 2017
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  source('simulate.R')
  
  # reactive function
  results = reactive({
    res = simulate(inbug=input$bug, inresUTI=input$pDrugResUTI,
                    inresResp=input$pDrugResResp, inresBSI=input$pDrugResBSI)
    res
  })
  
  output$cost_text <- renderText({
    meanc = round(mean(results()$cTreatment))
    ci = round(quantile(results()$cTreatment, probs=c(0.025, 0.975)))
    paste('Using a treatment cost of $',results()$tCost, ' per infection. Mean cost in 2017 = $', format(meanc, big.mark = ','), 
          ' per year, 95% confidence interval = $', format(ci[1], big.mark = ','), 
          ' to $', format(ci[2], big.mark = ','), '.', sep='')
  })
  
  output$account_text <- renderText({
    meanc = round(mean(results()$cBedAccount))
    ci = round(quantile(results()$cBedAccount, probs=c(0.025, 0.975)))
    paste('Using a bed day cost of $', results()$cAccount, ' per day obtained from the Australian Independent Hospital Pricing Authority. Mean cost in 2014 = $', format(meanc, big.mark = ','), 
          ' per year, 95% confidence interval = $', format(ci[1], big.mark = ','), 
          ' to $', format(ci[2], big.mark = ','), '.', sep='')
  })

  output$opp_text <- renderText({
    meanc = round(mean(results()$cBedOppCost))
    ci = round(quantile(results()$cBedOppCost, probs=c(0.025, 0.975)))
    paste('Using a bed day cost of $', results()$cOppCost, ' per day calculated as the opportunity cost of a bed-day obtained by contingent valuation (Page et al 2017). Mean cost = $', format(meanc, big.mark = ','), 
          ' per year, 95% confidence interval = $', format(ci[1], big.mark = ','), 
          ' to $', format(ci[2], big.mark = ','), '.', sep='')
  })

  })

