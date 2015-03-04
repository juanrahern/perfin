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

end # Finance module
