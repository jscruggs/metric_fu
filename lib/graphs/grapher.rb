module MetricFu
  class Grapher
    def initialize
      self.class.require_gruff
    end
    
    def self.require_gruff
      require 'gruff'
    rescue LoadError
      puts "#"*99 + "\n" +
           "If you want to use metric_fu's graphing features then you'll need to install the gems " + 
           "'topfunky-gruff' (or 'umang-gruff' if you use 1.9x) and 'rmagick' (and rmagick requires ImageMagick).  "+
           "If you don't want to deal with that, then make sure you set config.graphs = [] (see the metric_fu's homepage for more details) "+
           "to indicate that you don't want graphing." +
           "\n" + "#"*99 
      raise
    end
  end
end