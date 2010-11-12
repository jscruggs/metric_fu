module MetricFu
  class RailsBestPractices < Generator

    def emit
      @output = `rails_best_practices .`
    end

    def analyze
      @matches = @output.chomp.split("\n").map{|m| m.split(" - ") }
      total = @matches.pop
      2.times { @matches.pop } # ignore wiki link
      @matches.reject! {|array| array.empty? }
      @matches.map! do |match|
        file, line = match[0].split(':')
        problem = match[1]
        {:file => file, :line => line, :problem => problem}
      end
      @rails_best_practices_results = {:total => total, :problems => @matches}
    end

    def to_h
      {:rails_best_practices => @rails_best_practices_results}
    end
  end
end
