module MetricFu

  class Flog < Generator
    attr_reader :pages

    def self.verify_dependencies!
      `flog --help`
      raise 'sudo gem install flog # if you want the flog tasks' unless $?.success?
    end

    SCORE_FORMAT = "%0.2f"
    METHOD_LINE_REGEX = /(\d+\.\d+):\s+([A-Za-z:]+#.*)/
    OPERATOR_LINE_REGEX = /\s*(\d+\.\d+):\s(.*)$/

    def emit
      metric_dir = MetricFu::Flog.metric_directory
      MetricFu.flog[:dirs_to_flog].each do |directory|
        Dir.glob("#{directory}/**/*.rb").each do |filename|
          output_dir = "#{metric_dir}/#{filename.split("/")[0..-2].join("/")}"
          mkdir_p(output_dir, :verbose => false) unless File.directory?(output_dir)
          if MetricFu::MD5Tracker.file_changed?(filename, metric_dir)
            `flog -ad #{filename} > #{metric_dir}/#{filename.split('.')[0]}.txt`
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

    def parse(text)
      summary, methods_summary = text.split "\n\n"
      return unless summary
      score, average = summary.split("\n").map {|line| line[OPERATOR_LINE_REGEX, 1]}
      return nil unless score && methods_summary
      page = Flog::Page.new(score, average)
      methods_summary.each_line do |method_line|
        if match = method_line.match(METHOD_LINE_REGEX)
         page.scanned_methods << ScannedMethod.new(match[2], match[1])
        elsif match = method_line.match(OPERATOR_LINE_REGEX)
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
          page.path = path.sub(metric_directory, "").sub(".txt", ".rb") 
          @pages << page
        end
      end
    end

    def to_h
      number_of_methods = @pages.inject(0) {|count, page| count += page.scanned_methods.size}
      total_flog_score = @pages.inject(0) {|total, page| total += page.score}
      sorted_pages = @pages.sort_by {|page| page.highest_score }.reverse 
      {:flog => { :total => total_flog_score,
                  :average => average_score(total_flog_score, number_of_methods),
                  :pages => sorted_pages.map {|page| page.to_h}}}
    end
    
    private
    
    def average_score(total_flog_score, number_of_methods)
      return 0 if total_flog_score == 0
      round_to_tenths(total_flog_score/number_of_methods)
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
    attr_accessor :path, :score, :scanned_methods, :average_score

    def initialize(score, average_score, scanned_methods = [])
      @score = score.to_f
      @scanned_methods = scanned_methods
      @average_score = average_score.to_f
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

    def highest_score
      scanned_methods.inject(0) do |highest, m|
        m.score > highest ? m.score : highest
      end
    end
  end  
end
