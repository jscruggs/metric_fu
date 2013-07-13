module MetricFu
  module Formatter
    class YAML
      include MetricFu::Io

      DEFAULT_PATH = "report.yml"

      def initialize(opts={})
        @output = file_for(opts[:output]) || file_for(DEFAULT_PATH)
      end

      def finish
        @output.write(MetricFu.result.as_yaml)
      end

    end
  end
end
