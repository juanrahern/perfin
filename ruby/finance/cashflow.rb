require "Date"

module CashFlow

  class Sample
    attr_reader :time, :value
    attr_writer :time, :value

    def initialize(time, value)
      @time = time
      @value = value
    end

    def roundToEndOfMonth
      Sample.new(DateTime.new(@time.year, @time.month, -1), @value)
    end

    def roundToBeginningOfMonth
      Sample.new(DateTime.new(@time.year, @time.month, 1), @value)
    end

    def roundToEndOfYear
      Sample.new(DateTime.new(@time.year, 12, -1), @value)
    end

    def roundToBeginningOfYear
      Sample.new(DateTime.new(@time.year, 1, 1), @value)
    end

  end

  class CashFlow
    def initialize(series)
      @series = series
    end

    protected #------------------------------------------------------

    def quantize(quantize)
      newSeries = []
      @series.each do |sample|
        newSeries << sample.send(quantize)
      end
      return self.class.new(newSeries)
    end

    def consolidate    # Assumes samples are in cronological order
      newSeries = []
      @series.each do |sample|
        lastSample = newSeries[-1]
        if lastSample && (sample.time == lastSample.time)
          lastSample.value += sample.value
        else
          newSeries << sample
        end
      end
      return self.class.new(newSeries)
    end

    def quantizeAndConsolidate(quantize)
      newSeries = []
      @series.each do |sample|
        t = sample.time
        newSample = sample.send(quantize)
        lastSample = newSeries[-1]
        if lastSample && (newSample.time == lastSample.time)
          lastSample.value += newSample.value
        else
          newSeries << newSample
        end
      end
      return self.class.new(newSeries)
    end

    public #---------------------------------------------------------

    def to_s
      s = ""
      @series.each do |sample|
        s += "t=#{sample.time}, v=#{sample.value}\n"
      end
      return s
    end

    def roundToEndOfMonth
      self.quantizeAndConsolidate(:roundToEndOfMonth)
    end

    def roundToBeginningOfMonth
      self.quantizeAndConsolidate(:roundToBeginningOfMonth)
    end

     def roundToEndOfYear
      self.quantizeAndConsolidate(:roundToEndOfYear)
    end

    def roundToBeginningOfYear
      self.quantizeAndConsolidate(:roundToBeginningOfYear)
    end

  end #CashFlow class

end #CashFlow module
