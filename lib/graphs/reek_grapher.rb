module MetricFu
  
  class ReekGrapher < Grapher
    
    attr_accessor :reek_count, :labels
    
    def initialize
      super
      @reek_count = {}
      @labels = {}
    end
    
    def get_metrics(metrics, date)
      counter = @labels.size
      year, month, day = self.class.parsedate(date)
      @labels.update( { @labels.size => "#{month}/#{day}" })
      
      metrics[:reek][:matches].each do |reek_chunk|
        reek_chunk[:code_smells].each do |code_smell|
          # speaking of code smell...
          @reek_count[code_smell[:type]] = [] if @reek_count[code_smell[:type]].nil?
          if @reek_count[code_smell[:type]][counter].nil?
            @reek_count[code_smell[:type]][counter] = 1
          else
            @reek_count[code_smell[:type]][counter] += 1
          end
        end
      end
    end
    
    def graph!
      determine_y_axis_scale(@reek_count.values.flatten.uniq)
      values = []
      legend = @reek_count.keys.sort
      legend.collect {|k| values << @reek_count[k]}
      
      url = Gchart.line(
        :size => MetricFu.graph_size,
        :title => URI.escape("Reek: code smells"),
        :data => values,
        :stacked => false,
        :bar_colors => COLORS,
        :legend => legend,
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'reek.png'))
    end
    
  end
  
end
