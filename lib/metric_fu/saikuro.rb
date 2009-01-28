module MetricFu

class Saikuro < Base::Generator

  def analyze
    @units = []
    saikuro_results.each do |path|
      if Saikuro::Unit.is_valid_text_file?(path)
        unit = Saikuro::Unit.new(path) 
        if unit
          @units << unit
        end
      end
    end
  end

  def generate_report
    analyze
    to_yaml
  end

  def to_yaml
    units = @units.map do |unit|
      new_unit = unit.to_yaml
      new_unit[:filename] = unit.filename
      new_unit
    end
    {:saikuro => {:units => units} }
  end

  def saikuro_results
    Dir.glob("#{metric_dir}/**/*.html")
  end


end

class Saikuro::Unit

  attr_reader :elements
  
  def initialize(path)
    @path = path
    @file_handle = File.open(@path, "r")
    @elements = []
    get_elements
  end

  def self.is_valid_text_file?(path)
    File.open(path, "r") do |f|
      unless f.readline.match /--/
        return false
      else
        return true
      end
    end
  end

  def filename
    File.basename(@path, '_cyclo.html')
  end

  def to_yaml
    elements = @elements.map do |element|
      element.to_yaml
    end
    {:elements => elements}
  end

  def get_elements
    begin
      while ( line = @file_handle.readline) do
        if line.match /START/
          line = @file_handle.readline
          element = Saikuro::ParsingElement.new(line)
        elsif line.match /END/
          @elements << element 
          element = nil
        else
          element << line
        end
      end
    rescue EOFError
      nil
    end
  end


end

class Saikuro::ParsingElement
  TYPE_REGEX=/Type:(.*) Name/
  NAME_REGEX=/Name:(.*) Complexity/
  COMPLEXITY_REGEX=/Complexity:(.*) Lines/
  LINES_REGEX=/Lines:(.*)/

  attr_reader :name, :complexity, :lines, :defs, :element_type

  def initialize(line)
    @line = line
    @element_type = line.match(TYPE_REGEX)[1].strip
    @name = line.match(NAME_REGEX)[1].strip
    @complexity  = line.match(COMPLEXITY_REGEX)[1].strip
    @lines = line.match(LINES_REGEX)[1].strip
    @defs = []
  end

  def <<(line)
    @defs << Saikuro::ParsingElement.new(line) 
  end

  def to_yaml
    base = {:name => @name, :complexity => @complexity, :lines => @lines}
    unless @defs.empty?
      defs = @defs.map do |my_def|
        my_def = my_def.to_yaml
        my_def.delete(:defs)
        my_def
      end
      base[:defs] = defs
    end
    return base
  end
end


end
