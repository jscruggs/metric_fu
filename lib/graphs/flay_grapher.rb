require 'graph'
require 'gruff'
module MetricFu
  
  class FlayGrapher
    
    attr_accessor :flay_score, :labels
    
    def initialize
      self.flay_score = []
      self.labels = {}
    end
    
    def get_metrics(metrics, date)
      self.flay_score.push(metrics[:flay][:total_score].to_i)
      self.labels.update( { self.labels.size => date })
    end
    
    def graph!
      g = Gruff::Line.new("1024x768")
      g.title = "Flay: duplication"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('flay', self.flay_score)
      g.labels = self.labels
      g.write(File.join(MetricFu.output_directory, 'flay.png'))
    end
    
  end
  
end
