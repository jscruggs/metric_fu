module MetricFu
  module Formatter
    class YAML
      include MetricFu::Io

      DEFAULT_PATH = "report.yml"

      def initialize(opts={})
        @options = opts
      end

      def finish
        self.write(MetricFu.result.as_yaml)
      end

      protected

      def write(output)
        io_for(@options[:output] || DEFAULT_PATH) do |io|
          io.write(output)
        end
      end

    end
  end
end
