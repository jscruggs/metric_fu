module MetricFu

class Flog < Generator
  attr_reader :pages

  SCORE_FORMAT = "%0.2f"
  METHOD_LINE_REGEX = /([A-Za-z]+#.*):\s\((\d+\.\d+)\)/
  OPERATOR_LINE_REGEX = /\s+(\d+\.\d+):\s(.*)$/

  def emit
    begin
    metric_dir = MetricFu::Flog.metric_directory
    MetricFu::Flog.dirs_to_flog do |directory|
      Dir.glob("#{directory}/**/*.rb").each do |filename|
        output_dir = "#{metric_dir}/#{filename.split("/")[0..-2].join("/")}"
        mkdir_p(output_dir, :verbose => false) unless File.directory?(output_dir)
        if MetricFu::MD5Tracker.file_changed?(filename, metric_dir)
          `flog #{filename} > #{metric_dir}/#{filename.split('.')[0]}.txt`
        end
      end
    end
    rescue LoadError
      if RUBY_PLATFORM =~ /java/
        puts 'running in jruby - flog tasks not available'
      else
        puts 'sudo gem install flog # if you want the flog tasks'
      end
    end
  end

  def parse(text)
    score = text[/\w+ = (\d+\.\d+)/, 1]
    return nil unless score
    page = Flog::Page.new(score)
    text.each_line do |method_line|
     if match = method_line.match(METHOD_LINE_REGEX)
        page.scanned_methods << ScannedMethod.new(match[1], match[2])
      end
      if match = method_line.match(OPERATOR_LINE_REGEX)
        return if page.scanned_methods.empty?
        page.scanned_methods.last.operators << Operator.new(match[1], match[2])
      end
    end
    page
  end

  def analyze
    @pages = []
    flog_results.each do |path|
      page = parse(open(path, "r") { |f| f.read })
      if page
        page.path = path 
        @pages << page
      end
    end
  end

  def generate_report
    analyze
    to_h
  end

  def to_h
    {:flog => {:pages => @pages.map {|page| page.to_h}}}
  end
  

  def flog_results
    Dir.glob("#{metric_directory}/**/*.txt")
  end
  
  class Operator
    attr_accessor :score, :operator

    def initialize(score, operator)
      @score = score.to_f
      @operator = operator
    end
    
    def to_h
      {:score => @score, :operator => @operator}
    end
  end  

  class ScannedMethod
    attr_accessor :name, :score, :operators

    def initialize(name, score, operators = [])
      @name = name
      @score = score.to_f
      @operators = operators
    end

    def to_h
      {:name => @name,
       :score => @score,
       :operators => @operators.map {|o| o.to_h}}
    end
  end  
  
end

class Flog::Page < MetricFu::Generator
  attr_accessor :path, :score, :scanned_methods

  def initialize(score, scanned_methods = [])
    @score = score.to_f
    @scanned_methods = scanned_methods
  end

  def filename 
    File.basename(path, ".txt") 
  end

  def to_h
    {:score => @score, 
     :scanned_methods => @scanned_methods.map {|sm| sm.to_h},
     :highest_score => highest_score,
     :average_score => average_score,
     :path => path}
  end

  def average_score
    return 0 if scanned_methods.length == 0
    sum = 0
    scanned_methods.each do |m|
      sum += m.score
    end
    sum / scanned_methods.length
  end

  def highest_score
    scanned_methods.inject(0) do |highest, m|
      m.score > highest ? m.score : highest
    end
  end

end  

end
