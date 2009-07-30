
module MetricFu
  
  class FlayGrapher < Grapher
    
    attr_accessor :flay_score, :labels
    
    def initialize
      super
      @flay_score = []
      @labels = {}
    end
    
    def get_metrics(metrics, date)
      @flay_score.push(metrics[:flay][:total_score].to_i)
      year, month, day = self.class.parsedate(date)
      @labels.update( { @labels.size => "#{month}/#{day}" })
    end
    
    def graph!
      determine_y_axis_scale(@flay_score)
      url = Gchart.line(
        :size => MetricFu.graph_size,
        :title => URI.escape("Flay: duplication"),
        :data => @flay_score,
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'flay.png'))
    end
    
  end
  
end
