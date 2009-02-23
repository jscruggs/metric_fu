module MetricFu
  
  class Reek < Generator
    PROBLEM_CLASS_REGEX = /\[(.*)\]/
    PROBLEM_MESSAGE_REGEX = /\](.*)/

    def emit
      files_to_reek = MetricFu.reek[:dirs_to_reek].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      @output = `reek #{files_to_reek.join(" ")}`
    end

    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n") }
      @matches.map! do |match|
        file_path = match.shift.split('--').first
        file_path = file_path.gsub('"', ' ').strip
        code_smells = match.map do |smell|
          problem_class = smell.match(PROBLEM_CLASS_REGEX)[1].strip
          problem_message = smell.match(PROBLEM_MESSAGE_REGEX)[1].strip
          {:problem_class => problem_class,
           :problem_message => problem_message}
        end
        {:file_path => file_path, :code_smells => code_smells}
      end
    end

    def to_h
      {:reek => {:matches => @matches}}
    end

  end
end
