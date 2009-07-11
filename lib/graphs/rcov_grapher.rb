module MetricFu
  
  class RcovGrapher < Grapher
    
    attr_accessor :rcov_percent, :labels
    
    def initialize
      super
      self.rcov_percent = []
      self.labels = {}
    end
    
    def get_metrics(metrics, date)
      self.rcov_percent.push(metrics[:rcov][:global_percent_run])
      self.labels.update( { self.labels.size => date })
    end
    
    def graph!
      g = Gruff::Line.new(MetricFu.graph_size)
      g.title = "Rcov: code coverage"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('rcov', self.rcov_percent)
      g.labels = self.labels
      g.title_font_size = MetricFu.graph_title_font_size
      g.legend_box_size = MetricFu.graph_legend_box_size
      g.legend_font_size = MetricFu.graph_legend_font_size
      g.marker_font_size = MetricFu.graph_marker_font_size
      g.write(File.join(MetricFu.output_directory, 'rcov.png'))
    end
    
  end
  
end
