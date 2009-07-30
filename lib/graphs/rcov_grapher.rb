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
      year, month, day = self.class.parsedate(date)
      self.labels.update( { self.labels.size => "#{month}/#{day}" })
    end
    
    def graph!
      determine_y_axis_scale(self.rcov_percent)
      url = Gchart.line(
        :size => MetricFu.graph_size,
        :title => URI.escape("Rcov: code coverage"),
        :data => self.rcov_percent,
        :max_value => 101,
        :axis_with_labels => 'x,y',
        :axis_labels => [self.labels.values, [0,20,40,60,80,100]],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'rcov.png'))
    end
    
  end
  
end
