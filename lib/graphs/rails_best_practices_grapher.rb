module MetricFu
  
  class RailsBestPracticesGrapher < Grapher
    
    attr_accessor :rails_best_practices_count, :labels
    
    def initialize
      super
      @rails_best_practices_count = []
      @labels = {}
    end
    
    def get_metrics(metrics, date)
      if metrics[:rails_best_practices] && metrics[:rails_best_practices][:problems]
        size = metrics[:rails_best_practices][:problems].size
      else
        size = 0
      end
      @rails_best_practices_count.push(size)
      @labels.update( { @labels.size => date })
    end
    
  end
  
end
