module MetricFu
 
  class Saikuro < Generator

    def emit
      relative_path = [File.dirname(__FILE__), '..', '..',
                       'vendor', 'saikuro', 'saikuro.rb']
      saikuro = File.expand_path(File.join(relative_path))
 
      MetricFu.saikuro[:input_directory] = format_directories
 
      options_string = MetricFu.saikuro.inject("") do |options, option|
        options + "--#{option.join(' ')} "
      end
 
      sh %{ruby "#{saikuro}" #{options_string}} do |ok, response|
        unless ok
          puts "Saikuro failed with exit status: #{response.exitstatus}"
          exit 1
        end
      end
    end

    def format_directories
      dirs = MetricFu.saikuro[:input_directory].join(" | ")
      "\"#{dirs}\""
    end
 
    def analyze
      @files = []
      saikuro_results.each do |path|
        if Saikuro::SFile.is_valid_text_file?(path)
          file = Saikuro::SFile.new(path)
          if file
            @files << file
          end
        end
      end
      @files = @files.sort_by do |file|
        file.elements.
             max {|a,b| a.complexity.to_i <=> b.complexity.to_i}.
             complexity.to_i
      end
      @files.reverse!
      klasses = []
      @files.each {|f| klasses << f.elements}
      klasses.flatten!
      @classes = klasses.sort_by {|k| k.complexity.to_i}
      @classes.reverse!
      meths = []
      @files.each {|f|
        f.elements.each {|el|
          el.defs.each {|defn|
            defn.name = "#{el.name}##{defn.name}"
            meths << defn}
        }
      }
      meths = meths.sort_by {|meth| meth.complexity.to_i}
      @meths = meths.reverse
    end
 
    def to_h
      files = @files.map do |file|
        my_file = file.to_h
        my_file[:filename] = file.filename
        my_file
      end
      {:saikuro => {:files => files,
                    :classes => @classes.map {|c| c.to_h},
                    :methods => @meths.map {|m| m.to_h}
                   }
      }
    end
 
    def saikuro_results
      Dir.glob("#{metric_directory}/**/*.html")
    end
  end
 
  class Saikuro::SFile
 
    attr_reader :elements

    def initialize(path)
      @path = path
      @file_handle = File.open(@path, "r")
      @elements = []
      get_elements
    end
 
    def self.is_valid_text_file?(path)
      File.open(path, "r") do |f|
        if f.eof? || !f.readline.match(/--/)
          return false
        else
          return true
        end
      end
    end
 
    def filename
      File.basename(@path, '_cyclo.html')
    end
 
    def to_h
      merge_classes
      {:classes => @elements}
    end
 
    def get_elements
      begin
        while (line = @file_handle.readline) do
          return [] if line.nil? || line !~ /\S/
          element ||= nil
          if line.match /START/
            unless element.nil?
              @elements << element
              element = nil
            end
            line = @file_handle.readline
            element = Saikuro::ParsingElement.new(line)
          elsif line.match /END/
            @elements << element if element
            element = nil
          else
            element << line if element
          end
        end
      rescue EOFError
        nil
      end
    end
 
 
    def merge_classes
      new_elements = []
      get_class_names.each do |target_class|
        elements = @elements.find_all {|el| el.name == target_class }
        complexity = 0
        lines = 0
        defns = []
        elements.each do |el|
          complexity += el.complexity.to_i
          lines += el.lines.to_i
          defns << el.defs
        end
 
        new_element = {:class_name => target_class,
                       :complexity => complexity,
                       :lines => lines,
                       :methods => defns.flatten.map {|d| d.to_h}}
        new_element[:methods] = new_element[:methods].
                                sort_by {|x| x[:complexity] }.
                                reverse
 
        new_elements << new_element
      end
      @elements = new_elements if new_elements
    end
 
    def get_class_names
      class_names = []
      @elements.each do |element|
        unless class_names.include?(element.name)
          class_names << element.name
        end
      end
      class_names
    end
 
  end
 
  class Saikuro::ParsingElement
    TYPE_REGEX=/Type:(.*) Name/
    NAME_REGEX=/Name:(.*) Complexity/
    COMPLEXITY_REGEX=/Complexity:(.*) Lines/
    LINES_REGEX=/Lines:(.*)/
 
    attr_reader :complexity, :lines, :defs, :element_type
    attr_accessor :name
 
    def initialize(line)
      @line = line
      @element_type = line.match(TYPE_REGEX)[1].strip
      @name = line.match(NAME_REGEX)[1].strip
      @complexity = line.match(COMPLEXITY_REGEX)[1].strip
      @lines = line.match(LINES_REGEX)[1].strip
      @defs = []
    end
 
    def <<(line)
      @defs << Saikuro::ParsingElement.new(line)
    end
 
    def to_h
      base = {:name => @name, :complexity => @complexity.to_i, :lines => @lines.to_i}
      unless @defs.empty?
        defs = @defs.map do |my_def|
          my_def = my_def.to_h
          my_def.delete(:defs)
          my_def
        end
        base[:defs] = defs
      end
      return base
    end
  end
end
