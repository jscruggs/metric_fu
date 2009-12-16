module MetricFu
  
  class Reek < Generator
    REEK_REGEX = /^(\S+) (.*) \((.*)\)$/

    def self.verify_dependencies!
      `reek --help`
      raise 'sudo gem install reek # if you want the reek tasks' unless $?.success?
    end

    def emit
      files_to_reek = MetricFu.reek[:dirs_to_reek].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      files = remove_excluded_files(files_to_reek.flatten)
      @output = `reek #{files.join(" ")}`
      @output = massage_for_reek_12 if reek_12?
    end

    def reek_12?
      return false if @output.length == 0
      (@output =~ /^"/) != 0
    end

    def massage_for_reek_12
      section_break = ''
      @output.split("\n").map do |line|
        case line
        when /^  /
          "#{line.gsub(/^  /, '')}\n"
        else
          parts = line.split(" -- ")
          if parts[1].nil?
            "#{line}\n"
          else
            warnings = parts[1].gsub(/ \(.*\):/, ':')
            result = "#{section_break}\"#{parts[0]}\" -- #{warnings}\n"
            section_break = "\n"
            result
          end
        end
      end.join
    end

    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n") }
      @matches = @matches.map do |match|
        file_path = match.shift.split('--').first
        file_path = file_path.gsub('"', ' ').strip
        code_smells = match.map do |smell|
          match_object = smell.match(REEK_REGEX)
          next unless match_object
          {:method => match_object[1].strip,
           :message => match_object[2].strip,
           :type => match_object[3].strip}
        end.compact
        {:file_path => file_path, :code_smells => code_smells}
      end
    end

    def to_h
      {:reek => {:matches => @matches}}
    end

  end
end
