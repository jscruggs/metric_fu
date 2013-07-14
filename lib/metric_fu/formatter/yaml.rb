module MetricFu
  module Formatter
    class YAML
      include MetricFu::Io

      DEFAULT_PATH = "report.yml"

      def initialize(opts={})
        @options = opts
      end

      def finish
        self.output.write(MetricFu.result.as_yaml)
      end

      protected

      def output
        @output ||= (file_for(@options[:output]) || file_for(DEFAULT_PATH))
      end

    end
  end
end
