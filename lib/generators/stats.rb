module MetricFu

  class Stats < Generator

    def emit
      `rake stats > #{metric_directory + '/stats.txt'}`
    end

    def analyze
      output = File.open(metric_directory + '/stats.txt').read
      output = output.split("\n")
      output = output.find_all {|line| line[0].chr != "+" }
      output = output.find_all {|line| line[0].chr != "(" }
      output.shift
      totals = output.pop
      totals = totals.split("  ").find_all {|el| ! el.empty? }
      @stats = {}
      @stats[:codeLOC] = totals[0].match(/\d.*/)[0].to_i
      @stats[:testLOC] = totals[1].match(/\d.*/)[0].to_i
      @stats[:code_to_test_ratio] = totals[2].match(/1\:(\d.*)/)[1].to_f
      
      @stats[:lines] = output.map do |line|
        elements = line.split("|")
        elements.map! {|el| el.strip }
        elements = elements.find_all {|el| ! el.empty? }
        info_line = {}
        info_line[:name] = elements.shift
        elements.map! {|el| el.to_i }
        [:lines, :loc, :classes, :methods, 
         :methods_per_class, :loc_per_method].each do |sym|
          info_line[sym] = elements.shift
        end
        info_line
      end
      @stats
    end

    def to_h
      {:stats => @stats}
    end

  end
end
