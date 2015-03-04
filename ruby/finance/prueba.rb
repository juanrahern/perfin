require "Date"
require_relative "cashflow"
require_relative "./finance.rb"

extend Finance

s11 = CashFlow::Sample.new(DateTime.new(2015, 3, 1), 5)
s12 = CashFlow::Sample.new(DateTime.new(2015, 4, 1), -5)
s13 = CashFlow::Sample.new(DateTime.new(2015, 4, 15), 5)
s14 = CashFlow::Sample.new(DateTime.new(2015, 5, 1), -5)

s21 = CashFlow::Sample.new(DateTime.new(2015, 3, 1), 5)
s22 = CashFlow::Sample.new(DateTime.new(2015, 4, 1), -5)
s23 = CashFlow::Sample.new(DateTime.new(2015, 4, 15), 5)
s24 = CashFlow::Sample.new(DateTime.new(2015, 5, 1), -5)

cf1 = CashFlow::CashFlow.new([s11, s12, s13, s14])
cf2 = CashFlow::CashFlow.new([s21, s22, s23, s24])

puts cf1.to_s
puts '-------------'
puts cf2.to_s
puts '------- Round to end of month ------'
puts cf1.roundToEndOfMonth.to_s
puts '------- Round to beginning of month ------'
puts cf1.roundToBeginningOfMonth.to_s
puts '------- Round to end of year ------'
puts cf1.roundToEndOfYear.to_s
puts '------- Round to beginning of year ------'
puts cf1.roundToBeginningOfYear.to_s
puts '------- NPV --------'
puts "NPV = #{npvMonthly(cf2, DateTime.now, 0.1)}"
puts '------- Loan --------'
mortgage = Finance::Mortgage.new(400000, 30*12, 0.03)
puts mortgage.monthlyPaymentCashFlow(DateTime.now)
puts '---------------------'
puts mortgage.monthlyInterestCashFlow(DateTime.now)

