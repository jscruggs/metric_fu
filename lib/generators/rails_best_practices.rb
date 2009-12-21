module MetricFu
  class RailsBestPractices < Generator

    def self.verify_dependencies!
      `rails_best_practices --help`
      raise 'sudo gem install rails_best_practices # if you want the rails_best_practices tasks' unless $?.success?
    end

    
    def emit
      files_to_analyze = MetricFu.rails_best_practices[:dirs_to_rails_best_practices].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      files = remove_excluded_files(files_to_analyze.flatten)
      @output = `rails_best_practices #{files.join(" ")}`
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
      @rails_best_practices_results = {:total => total, :problems => @matches}
    end

    def to_h
      {:rails_best_practices => @rails_best_practices_results}
    end
  end
end
