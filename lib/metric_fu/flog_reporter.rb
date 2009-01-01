module MetricFu::FlogReporter

  SCORE_FORMAT = "%0.2f"

  class InvalidFlog < RuntimeError
  end

  class Base
    MODULE_NAME = "([A-Za-z]+)+"
    METHOD_NAME = "#([a-z0-9]+_?)+\\??\\!?"
    SCORE = "\\d+\\.\\d+"

    METHOD_NAME_RE = Regexp.new("#{MODULE_NAME}#{METHOD_NAME}")
    SCORE_RE = Regexp.new(SCORE)

    METHOD_LINE_RE = Regexp.new("#{MODULE_NAME}#{METHOD_NAME}:\\s\\(#{SCORE}\\)")
    OPERATOR_LINE_RE = Regexp.new("\\s+(#{SCORE}):\\s(.*)$")

    class << self
      def cycle(first_value, second_value, iteration)
        return first_value if iteration % 2 == 0
        return second_value
      end

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
             raise InvalidFlog if page.scanned_methods.empty?
             page.scanned_methods.last.operators << Operator.new(score, operator)
          end
        end

        page
      end
    end
  end
  
  class Generator < MetricFu::Base::Generator
    def generate_report
      flog_hashes = []
      Dir.glob("#{@base_dir}/**/*.txt").each do |filename|
        begin
          page = Base.parse(open(filename, "r") { |f| f.read })
        rescue InvalidFlog
          puts "Invalid flog for #{filename}"
          next
        end

        next unless page

        unless MetricFu::MD5Tracker.file_already_counted?(filename)
          generate_page(filename, page)
        end
        flog_hashes << { :path => File.basename(filename, ".txt") + '.html',
                 :page => page }
      end

      generate_index(flog_hashes)
    end

    def generate_page(filename, page)
      save_html(page.to_html, File.basename(filename, ".txt"))
    end

    # should be dynamically read from the class
    def template_name
      'flog'
    end

    def generate_index(flog_hashes)
      save_html(ERB.new(File.read(template_file)).result(binding))
    end
  end  
  
  class Page < MetricFu::Base::Generator
    attr_accessor :score, :scanned_methods

    def initialize(score, scanned_methods = [])
      @score = score.to_f
      @scanned_methods = scanned_methods
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

    # should be dynamically read from the class
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

    def to_html
      output = "<p><strong>#{name} (#{score})</strong></p>\n"
      output << "<table>\n"
      output << "<tr><th>Score</th><th>Operator</th></tr>\n"
      count = 0
      operators.each do |operator|
        output << <<-EOF
                    <tr class='#{Base.cycle("light", "dark", count)}'>
                      <td class='score'>#{sprintf(SCORE_FORMAT, operator.score)}</td>
                      <td class='score'>#{operator.operator}</td>
                    </tr>
                  EOF
        count += 1
      end
      output << "</table>\n\n"
    end
  end  
end
