module MetricFu
  
    
  class Roodi < Generator

    def analyze
      files_to_analyze = MetricFu.roodi[:dirs_to_roodi].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `roodi #{files_to_analyze.join(" ")}`
      @matches = output.chomp.split("\n").map{|m| m.split(" - ") }
      total = @matches.pop
      @matches.reject! {|array| array.empty? }
      @matches.map! do |match|
        file, line = match[0].split(':')
        problem = match[1]
        {:file => file, :line => line, :problem => problem}
      end
      @roodi_results = {:total => total, :problems => @matches}
    end

    def to_yaml
      {:roodi => @roodi_results}
    end
  end
end
