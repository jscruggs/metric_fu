module MetricFu
  
  class FlogGrapher < Grapher
    
    attr_accessor :flog_average, :labels, :top_five_percent_average
    
    def initialize
      super
      @flog_average = []
      @labels = {}
      @top_five_percent_average =[]
    end
    
    def get_metrics(metrics, date)
      @top_five_percent_average.push(calc_top_five_percent_average(metrics))
      @flog_average.push(metrics[:flog][:average])
      year, month, day = self.class.parsedate(date)
      @labels.update( { @labels.size => "#{month}/#{day}" })
    end
    
    def graph!
      determine_y_axis_scale(@top_five_percent_average + @flog_average)
      url = Gchart.line(
        :size => MetricFu.graph_size,
        :title => URI.escape("Flay: code complexity"),
        :data => [@flog_average, @top_five_percent_average],
        :stacked => false,
        :bar_colors => COLORS[0..2],
        :legend => ['average', 'top 5%25 average'],
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'flog.png'))
    end
    
    private
    
    def calc_top_five_percent_average(metrics)
      methods = metrics[:flog][:pages].inject([]) {|methods, page| methods << page[:scanned_methods]}
      methods.flatten!
      methods = methods.sort_by {|method| method[:score]}.reverse

      number_of_methods_that_is_five_percent = (methods.size * 0.05).ceil

      total_for_five_percent = methods[0...number_of_methods_that_is_five_percent].inject(0) {|total, method| total += method[:score]}
      number_of_methods_that_is_five_percent == 0 ? 0.0 : total_for_five_percent / number_of_methods_that_is_five_percent.to_f
    end
    
  end
  
end
