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
  function( house_price, downpay_pct, int_rate, mortage_year, resale_at_year, growth_rate, tax_rate, ins_rate) {
  amort = mortgage(house_price*(1-downpay_pct), int_rate, mortage_year)
  monthly_payment = aDFmonth$Monthly_Payment[1] + 
    house_price*tax_rate/100/12 +
    house_price*ins_rate/100/12
  total_payment = resale_at_year*aDFyear$Annual_Payment[1] +
    get_total_fees(house_price, tax_rate, ins_rate, growth_rate, resale_at_year)
  ownership_pct = downpay_pct + sum(aDFyear$Annual_Principal[1:resale_at_year])/house_price
  current_property_value = house_price * (1+growth_rate/100)^resale_at_year
  roi = current_property_value*ownership_pct/ (total_payment + house_price*downpay_pct)
  
  return(list(monthly_payment = monthly_payment, 
              total_payment = total_payment,
              ownership_pct = ownership_pct,
              current_property_value = current_property_value,
              roi = roi))
}