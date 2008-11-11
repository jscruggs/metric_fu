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
end
