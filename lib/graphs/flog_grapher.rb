module MetricFu
  
  class FlogGrapher < Grapher
    
    attr_accessor :flog_average, :labels, :top_five_percent_average
    
    def initialize
      super
      self.flog_average = []
      self.labels = {}
      self.top_five_percent_average =[]
    end
    
    def get_metrics(metrics, date)
      self.top_five_percent_average.push(calc_top_five_percent_average(metrics))
      self.flog_average.push(metrics[:flog][:average])
      self.labels.update( { self.labels.size => date })
    end
    
    def graph!
      g = Gruff::Line.new(MetricFu.graph_size)
      g.title = "Flog: code complexity"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      g.data('top five percent average', self.top_five_percent_average)
      g.data('flog average', self.flog_average)
      g.labels = self.labels
      g.title_font_size = MetricFu.graph_title_font_size
      g.legend_box_size = MetricFu.graph_legend_box_size
      g.legend_font_size = MetricFu.graph_legend_font_size
      g.marker_font_size = MetricFu.graph_marker_font_size
      g.write(File.join(MetricFu.output_directory, 'flog.png'))
    end
    
    private
    
    def calc_top_five_percent_average(metrics)
      methods = metrics[:flog][:pages].inject([]) {|methods, page| methods << page[:scanned_methods]}
      methods.flatten!
      
      methods = methods.sort_by {|method| method[:score]}.reverse

      number_of_methods_that_is_five_percent = (methods.size * 0.05).ceil

      total_for_five_percent = methods[0...number_of_methods_that_is_five_percent].inject(0) {|total, method| total += method[:score]}
      total_for_five_percent / number_of_methods_that_is_five_percent.to_f
    end
    
  end
  
end
