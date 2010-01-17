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
      @labels.update( { @labels.size => date })
    end
    
    private
    
    def calc_top_five_percent_average(metrics)
      methods = metrics[:flog][:pages].inject([]) {|methods, page| methods << page[:scanned_methods]}
      methods.flatten!
      methods = methods.sort_by {|method| method[:score]}.reverse

      number_of_methods_that_is_five_percent = (methods.size * 0.05).ceil

      total_for_five_percent =
        methods[0...number_of_methods_that_is_five_percent].inject(0) {|total, method| total += method[:score] }
      if number_of_methods_that_is_five_percent == 0
        0.0
      else
        total_for_five_percent / number_of_methods_that_is_five_percent.to_f
      end
    end
    
  end
  
end
