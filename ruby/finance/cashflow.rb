module Cashflow

  class Sample
    attr_reader :time, :value
    attr_writer :time, :value

    def initialize(time, value)
      @time = time
      @value = value
    end
  end

  class Cashflow
    attr_reader :series

    def initialize(series)
      @series = series
    end

    def to_s
      str = ''
      @series.each do |sample|
        str += "t=#{sample.time}; v=#{sample.value}\n"
      end
      return str
    end

    def roundToEndOfMonth
      newSeries = []
      @series.each do |sample|
        t = sample.time
        newSample = Sample.new(DateTime.new(t.year, t.month, -1), sample.value)
        lastSample = newSeries[-1]
        if lastSample && (newSample.time == lastSample.time)
          lastSample.value += newSample.value
        else
          newSeries << newSample
        end
      end
      return self.class.new(newSeries)
    end

    def roundToBeginningOfMonth
      newSeries = []
      @series.each do |sample|
        t = sample.time
        newSample = Sample.new(DateTime.new(t.year, t.month, 1), sample.value)
        lastSample = newSeries[-1]
        if lastSample && (newSample.time == lastSample.time)
          lastSample.value += newSample.value
        else
          newSeries << newSample
        end
      end
      return self.class.new(newSeries)
    end

    def roundToEndOfYear
      newSeries = []
      @series.each do |sample|
        t = sample.time
        newSample = Sample.new(DateTime.new(t.year, 12, -1), sample.value)
        lastSample = newSeries[-1]
        if lastSample && (newSample.time == lastSample.time)
          lastSample.value += newSample.value
        else
          newSeries << newSample
        end
      end
      return self.class.new(newSeries)
    end

    def roundToBeginningOfYear
      newSeries = []
      @series.each do |sample|
        t = sample.time
        newSample = Sample.new(DateTime.new(t.year, 1, 1), sample.value)
        lastSample = newSeries[-1]
        if lastSample && (newSample.time == lastSample.time)
          lastSample.value += newSample.value
        else
          newSeries << newSample
        end
      end
      return self.class.new(newSeries)
    end

    def consolidateDaily
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

    def +(cf)
      series1 = self.series
      series2 = cf.series
      newSeries = []
      while (series1 != []) || (series2 != []) do
        lastSample = newSeries[-1]
        if series1 == []
          nextSample = series2.shift
        else
          if series2 == []
            nextSample = series1.shift
          else
            if series1[0].time < series2[0].time
              nextSample = series1.shift
            else
              nextSample = series2.shift
            end
          end
        end
        if lastSample && (lastSample.time == nextSample.time)
          lastSample.value += nextSample.value
        else
          newSeries << nextSample
        end
      end
      return self.class.new(newSeries)
    end

  end

end
