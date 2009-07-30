module MetricFu
  
  class RoodiGrapher < Grapher
    
    attr_accessor :roodi_count, :labels
    
    def initialize
      super
      @roodi_count = []
      @labels = {}
    end
    
    def get_metrics(metrics, date)
      @roodi_count.push(metrics[:roodi][:problems].size)
      year, month, day = self.class.parsedate(date)
      @labels.update( { @labels.size => "#{month}/#{day}" })
    end
    
    def graph!
      determine_y_axis_scale(@roodi_count)
      url = Gchart.line(
        :size => MetricFu.graph_size,
        :title => URI.escape("Roodi: potential design problems"),
        :data => @roodi_count,
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'roodi.png'))
    end
    
  end
  
end
