module MetricFu
  
  class Flay < Generator

    def emit
      files_to_flay = MetricFu.flay[:dirs_to_flay].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      @output = `flay #{files_to_flay.join(" ")}`

    end

    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

    def to_yaml
      @matches.flatten!
      potential_matches = []
      target = [] 
      while(! @matches.empty?) do
        candidate = @matches.pop
        if candidate.match(/Matches found in/)
          matches = potential_matches.map do |potential_match|
            name, line = potential_match.split(":")
            {:name => name.strip, :line => line.strip}
          end
          target << [:reason => candidate.strip, 
                     :matches => matches]
        else
          potential_matches << candidate.strip
        end
      end
      {:flay => {:matches => target.flatten}}
    end
  end
end
