require 'gruff'
module MetricFu
  
  class FlogGrapher
    
    attr_accessor :flog_total, :flog_average, :labels
    
    def initialize
      self.flog_total = []
      self.flog_average = []
      self.labels = {}
    end
    
    def get_metrics(metrics, date)
      self.flog_total.push(metrics[:flog][:total])
      self.flog_average.push(metrics[:flog][:average])
      self.labels.update( { self.labels.size => date })
    end
    
    def graph!
      g = Gruff::Line.new("1024x768")
      g.title = "Flog: code complexity"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('flog total', self.flog_total)
      g.data('flog average', self.flog_average)
      g.labels = self.labels
      g.write(File.join(MetricFu.output_directory, 'flog.png'))
    end
    
  end
  
end
