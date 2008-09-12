module MetricFu::FlogReporter
  class Operator
    attr_accessor :score, :operator
    
    def initialize(score, operator)
      @score = score.to_f
      @operator = operator
    end
  end
end