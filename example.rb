#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'lib', 'cashflow')

CashflowProjector::Projector.setup do
  # This will be used as a reference for the biweekly pay. Any day from 
  #  the past or the future will work.
  payday = Date.new(2011,11,17)

  #ACCOUNTS
  # Create two accounts with names and starting values
  checking = account "Checking", 500.00
  savings = account "Savings", 2000.00

  #INCOME
  # Bob gets paid $1,000 every two weeks
  checking.payment_from "Work payroll (Bob)", 1000.00, biweekly(payday)

  # Jane gets paid $2,200 on the first of every month
  checking.payment_from "Work payroll (Jane)", 2200.00, monthly(1) 

  #SAVINGS
  # Bob and Jane set aside $200 of Bob's money to savings the day after a payday 
  checking.transfer_to savings, 200.00, biweekly(payday + 1)

  # ING Direct
  # Set aside some money from Janes paycheck for vacations
  checking.transfer_to "Vacations", 115, monthly(2)

  # AAA Insurance
  checking.transfer_to "Car Insurance", 200.00, monthly(22)

  # BILLS
  checking.transfer_to "SoCal Edison", 190, monthly(23)
  checking.transfer_to "DirecTV", 120, monthly(15)
  checking.transfer_to "ATT", 40, monthly(15)
  checking.transfer_to "Verizon", 110, monthly(14)

  # COLLEGE FUND FOR BABY
  checking.transfer_to "College Fund", 100, monthly(16)

  puts run(Date.today, Date.today+60)
end

