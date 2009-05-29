module MetricFu
  class Roodi < Generator

    def self.verify_dependencies!
      `roodi --help`
      raise 'sudo gem install roodi # if you want the roodi tasks' unless $?.success?
    end

    
    def emit
      files_to_analyze = MetricFu.roodi[:dirs_to_roodi].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      @output = `roodi #{files_to_analyze.join(" ")}`
    end

    def analyze
      @matches = @output.chomp.split("\n").map{|m| m.split(" - ") }
      total = @matches.pop
      @matches.reject! {|array| array.empty? }
      @matches.map! do |match|
        file, line = match[0].split(':')
        problem = match[1]
        {:file => file, :line => line, :problem => problem}
      end
      @roodi_results = {:total => total, :problems => @matches}
    end

    def to_h
      {:roodi => @roodi_results}
    end
  end
end
