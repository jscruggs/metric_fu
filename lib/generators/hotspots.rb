module MetricFu

  class Hotspots < Generator

    def initialize(options={})
      super
    end

    def self.verify_dependencies!
      true
    end

    
    def emit
      yaml = File.read('tmp/metric_fu/report.yml')
      @analyzer = MetricAnalyzer.new(yaml)
    end

    def analyze
      num = nil
      worst_items = {}
      worst_items[:files] = 
        @analyzer.worst_files(num).inject([]) do |array, worst_file|
        array << 
          {:location => @analyzer.location(:file, worst_file),
          :details => @analyzer.problems_with(:file, worst_file)}
        array
      end
      worst_items[:classes] = @analyzer.worst_classes(num).inject([]) do |array, class_name|
        location = @analyzer.location(:class, class_name)
        array << 
          {:location => location,
          :details => @analyzer.problems_with(:class, class_name)}
        array
      end
      worst_items[:methods] = @analyzer.worst_methods(num).inject([]) do |array, method_name|
        location = @analyzer.location(:method, method_name)
        array << 
          {:location => location,
          :details => @analyzer.problems_with(:method, method_name)}
        array
      end
      @worst_items = worst_items
      #TODO HOTSPOTS METRIC FU investigate
      #why doesn't @worst items show up on the erb page but hotspots does?
      @hotspots = @worst_items
    end

    def to_h
      {:hotspots => @worst_items}
    end
  end

end
