module MetricFu
  class Grapher
    COLORS = %w{009999 FF7400 A60000 008500 E6399B 344AD7 00B860 D5CCB9}    
    
    def initialize
      self.class.require_libraries
    end
    
    def self.require_libraries
      require 'gchart'
    rescue LoadError
      puts "#"*99 + "\n" +
           "If you want to use metric_fu's graphing features then you'll need to install the googlecharts gem. " +
           "If you don't want graphs, then make sure you set config.graphs = [] (see the metric_fu's homepage for more details) " +
           "to indicate that you don't want graphing." +
           "\n" + "#"*99 
      raise
    end
    
    def self.parsedate(date)
      [date[0..3].to_i, date[4..5].to_i, date[6..7].to_i]
    end
    
    NUMBER_OF_TICKS = 6
    def determine_y_axis_scale(score)
      if score.empty?
        @max_value = 10
        @yaxis = [0, 2, 4, 6, 8, 10]
      else
        @max_value = score.max + Integer(0.1 * score.max)
        portion_size = (@max_value / (NUMBER_OF_TICKS - 1).to_f).ceil
        @yaxis = []
        NUMBER_OF_TICKS.times.each {|n| @yaxis << Integer(portion_size * n) }
        @max_value = @yaxis.last
      end
    end
  end
end