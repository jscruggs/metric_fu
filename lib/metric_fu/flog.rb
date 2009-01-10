module MetricFu
  FLOG_DIR = File.join(MetricFu::BASE_DIRECTORY, 'flog')
  
  def self.generate_flog_report
    MetricFu::Flog::Generator.generate_report(FLOG_DIR)
    system("open #{FLOG_DIR}/index.html") if open_in_browser?  
  end
  
  module Flog
    class Generator < Base::Generator
      def generate_report
        pages = []
        flog_results.each do |filename|
          page = Base.parse(open(filename, "r") { |f| f.read })
          if page
            page.filename = filename
            pages << page
          end
        end
        generate_pages(pages)
      end

      def generate_pages(pages)
        pages.each do |page|
          unless MetricFu::MD5Tracker.file_already_counted?(page.filename)
            generate_page(page)
          end
        end      
        save_html(ERB.new(File.read(template_file)).result(binding))
      end

      def generate_page(page)
        save_html(page.to_html, page.path)
      end

      def flog_results
        Dir.glob("#{@base_dir}/**/*.txt")
      end
      
      def template_name
        "flog"
      end
    end

    SCORE_FORMAT = "%0.2f"

    class Base
      MODULE_NAME = "([A-Za-z]+)+"
      METHOD_NAME = "#([a-z0-9]+_?)+\\??\\!?"
      SCORE = "\\d+\\.\\d+"

      METHOD_NAME_RE = Regexp.new("#{MODULE_NAME}#{METHOD_NAME}")
      SCORE_RE = Regexp.new(SCORE)

      METHOD_LINE_RE = Regexp.new("#{MODULE_NAME}#{METHOD_NAME}:\\s\\(#{SCORE}\\)")
      OPERATOR_LINE_RE = Regexp.new("\\s+(#{SCORE}):\\s(.*)$")

      class << self

        def parse(text)
          score = text[/\w+ = (\d+\.\d+)/, 1]
          return nil unless score
          page = Page.new(score)

          text.each_line do |method_line|
            if METHOD_LINE_RE =~ method_line and
               method_name = method_line[METHOD_NAME_RE] and
               score = method_line[SCORE_RE]
               page.scanned_methods << ScannedMethod.new(method_name, score)
            end

            if OPERATOR_LINE_RE =~ method_line and
               operator = method_line[OPERATOR_LINE_RE, 2] and
               score = method_line[SCORE_RE]
               return if page.scanned_methods.empty?
               page.scanned_methods.last.operators << Operator.new(score, operator)
            end
          end
          page
        end
      end
    end 
  
    class Page < MetricFu::Base::Generator
      attr_accessor :filename, :score, :scanned_methods

      def initialize(score, scanned_methods = [])
        @score = score.to_f
        @scanned_methods = scanned_methods
      end

      def path
        @path ||= File.basename(filename, ".txt") + '.html'
      end

      def to_html
        ERB.new(File.read(template_file)).result(binding)
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

      def template_name
        'flog_page'
      end
    end  
  
    class Operator
      attr_accessor :score, :operator

      def initialize(score, operator)
        @score = score.to_f
        @operator = operator
      end
    end  
  
    class ScannedMethod
      attr_accessor :name, :score, :operators

      def initialize(name, score, operators = [])
        @name = name
        @score = score.to_f
        @operators = operators
      end
    end  
  end
end