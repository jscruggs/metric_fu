require 'gruff'
module MetricFu
  
  class RoodiGrapher
    
    attr_accessor :roodi_count, :labels
    
    def initialize
      self.roodi_count = []
      self.labels = {}
    end
    
    def get_metrics(metrics, date)
      self.roodi_count.push(metrics[:roodi][:problems].size)
      self.labels.update( { self.labels.size  => date })
    end
    
    def graph!
      g = Gruff::Line.new("1024x768")
      g.title = "Roodi: design problems"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('roodi', self.roodi_count)
      g.labels = self.labels
      g.write(File.join(MetricFu.output_directory, 'roodi.png'))
    end
    
  end
  
end
