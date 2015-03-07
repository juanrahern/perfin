require 'csv'

module Bankia

  class AccountTransaction
    attr_reader :date, :valueDate, :description, :amount, :currency, :postState, :stateCurrency, :details

    def initialize(date, valueDate, description, amount, currency, postState, stateCurrency, details)
      @date = date
      @valueDate = valueDate
      @description = description
      @amount = amount
      @currency = currency
      @postState = postState
      @stateCurrency = stateCurrency
      @details = details
    end

    def to_s
      "Transaction: #{@date} - #{@description} ; #{@details}"
    end

  end # AccountTransaction class

  class CreditCardTransaction
  end # CreditCardTransaction class

  class Parser
    def initialize(filename)
      @filename = filename
    end

    def extractTransactions
      @series = []
      CSV.foreach(@filename) do |row|
        if row[0] =~ /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}/  # row contains a transaction
          transaction = AccountTransaction.new(
            date = DateTime.strptime(row[0], '%d/%m/%Y'),
            valueDate = row[1],
            description = row[2],
            amount = row[3].gsub('.', '').gsub(',', '.').to_f,
            currency = row[4],
            postState = row[5],
            stateCurrency = row[6],
            details = "#{row[7]} #{row[8]} #{row[9]} #{row[10]} #{row[11]} #{row[12]}"
          )
          @series << transaction
        end
      end
    end

    def numberOfExtractedTransactions
      @series.length
    end

    def to_cashFlow
      cfSeries = []
      @series.each do |transaction|
        cfSeries << CashFlow::Sample.new(transaction.date, transaction.amount)
      end
      return CashFlow::CashFlow.new(cfSeries)
    end

  end # Parser class

end # Bankia module
