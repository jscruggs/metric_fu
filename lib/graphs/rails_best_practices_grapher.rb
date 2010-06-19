module MetricFu
  
  class RailsBestPracticesGrapher < Grapher
    
    attr_accessor :rails_best_practices_count, :labels
    
    def initialize
      super
      @rails_best_practices_count = []
      @labels = {}
    end
    
    def get_metrics(metrics, date)
      @rails_best_practices_count.push(metrics[:rails_best_practices][:problems].size)
      @labels.update( { @labels.size => date })
    end
    
  end
  
end
