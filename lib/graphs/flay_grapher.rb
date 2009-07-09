
module MetricFu
  
  class FlayGrapher < Grapher
    
    attr_accessor :flay_score, :labels
    
    def initialize
      super
      self.flay_score = []
      self.labels = {}
    end
    
    def get_metrics(metrics, date)
      self.flay_score.push(metrics[:flay][:total_score].to_i)
      self.labels.update( { self.labels.size => date })
    end
    
    def graph!
      g = Gruff::Line.new(MetricFu.graph_size)
      g.title = "Flay: duplication"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('flay', self.flay_score)
      g.labels = self.labels
      g.title_font_size = MetricFu.graph_title_font_size
      g.legend_box_size = MetricFu.graph_legend_box_size
      g.legend_font_size = MetricFu.graph_legend_font_size
      g.marker_font_size = MetricFu.graph_marker_font_size
      g.write(File.join(MetricFu.output_directory, 'flay.png'))
    end
    
  end
  
end
