require_relative "cashflow"

module Finance

  def npvMonthly(cashFlow, t0, yearlyInterestRate)
    quantizedCf = cashFlow.roundToEndOfMonth
    i = yearlyInterestRate / 12.0
    npv = 0.0
    quantizedCf.each do |sample|
      if sample.value
        nmonths = (sample.time.year-t0.year)*12 + sample.time.month - t0.month
        npv += sample.value/((1.0+i)**nmonths)
      end
    end
    return npv
  end

  def loanMonthlyPaymentCashFlow(principal, numMonths, yearlyInterestRate, t0)
    t0EndOfMonth = DateTime.new(t0.year, t0.month, -1)
    i = yearlyInterestRate / 12.0
    payment = principal*i*(1+i)**numMonths / ((1+i)**numMonths - 1)
    series = []
    (0..numMonths-1).each do |n|
      series << CashFlow::Sample.new(t0EndOfMonth >> n, payment)
    end
    return CashFlow::CashFlow.new(series)
  end

  def loanMonthlyInterestCashFlow(principal, numMonths, yearlyInterestRate, t0)
    t0EndOfMonth = DateTime.new(t0.year, t0.month, -1)
    i = yearlyInterestRate / 12.0
    payment = principal*i*(1+i)**numMonths / ((1+i)**numMonths - 1)
    series = []
    (1..numMonths).each do |n|
      interest = payment - payment*(1+i)**(n-1) + principal*i*(i+1)**(n-1)
      series << CashFlow::Sample.new(t0EndOfMonth >> n, interest)
    end
    return CashFlow::CashFlow.new(series)
  end

end # Finance module
