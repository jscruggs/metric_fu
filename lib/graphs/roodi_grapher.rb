module MetricFu
  
  class RoodiGrapher < Grapher
    
    attr_accessor :roodi_count, :labels
    
    def initialize
      super
      self.roodi_count = []
      self.labels = {}
    end
    
    def get_metrics(metrics, date)
      self.roodi_count.push(metrics[:roodi][:problems].size)
      self.labels.update( { self.labels.size  => date })
    end
    
    def graph!
      g = Gruff::Line.new(MetricFu.graph_size)
      g.title = "Roodi: design problems"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('roodi', self.roodi_count)
      g.labels = self.labels
      g.title_font_size = MetricFu.graph_title_font_size
      g.legend_box_size = MetricFu.graph_legend_box_size
      g.legend_font_size = MetricFu.graph_legend_font_size
      g.marker_font_size = MetricFu.graph_marker_font_size
      g.write(File.join(MetricFu.output_directory, 'roodi.png'))
    end
    
  end
  
end
