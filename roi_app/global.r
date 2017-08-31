source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/mortgage.R")

get_total_fees = 
  function (house_price, tax_rate, ins_rate, growth_rate,resale_at_year) {
  total_fee <- 0
  for (i in c(1:resale_at_year)) {
    new_base_price = house_price * (1+growth_rate/100)^(resale_at_year-1)
    total_ins = new_base_price * ins_rate/100
    total_tax = new_base_price * tax_rate/100
    total_fee = total_fee + total_ins + total_tax
  }
  total_fee
}

get_mortgage_calc = 
  function( house_price, downpay_pct, int_rate, mortage_year, hold_length, growth_rate, tax_rate, ins_rate) {
  amort = mortgage(house_price*(1-downpay_pct), int_rate, mortage_year, plotData=F)
  monthly_payment = aDFmonth$Monthly_Payment[1] + 
    house_price*tax_rate/100/12 +
    house_price*ins_rate/100/12
  tot_pay<-c()
  tot_own<-c()
  mkt_val<-c()
  tot_roi<-c()
  for (i in c(1:hold_length)) {
    total_payment = 
      i*aDFyear$Annual_Payment[1] +
      get_total_fees(house_price, tax_rate, ins_rate, growth_rate, i)
    
    ownership_pct = downpay_pct + sum(aDFyear$Annual_Principal[1:i])/house_price
    
    current_property_value = house_price * (1+growth_rate/100)^i
    
    roi = current_property_value*ownership_pct/ (total_payment + house_price*downpay_pct)
    tot_pay[i] = total_payment + house_price * downpay_pct
    tot_own[i] = ownership_pct
    mkt_val[i] = current_property_value
    tot_roi[i] = roi
  }
  d<- data.frame(year=c(1:hold_length),
                 total_payment = tot_pay,
                 ownership_pct = tot_own,
                 current_property_value = mkt_val,
                 roi = tot_roi)

  return(list(monthly_payment = monthly_payment, 
              out_d = d))
}