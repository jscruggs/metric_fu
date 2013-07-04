module MetricFu
  module Formatter
    class YAML < MetricFu::Formatter::Base

      def initialize(opts={})
        @file = opts[:file] || 'report.yml'
        @dir = opts[:dir] || MetricFu.base_directory
      end

      def finish
        save_output(MetricFu.result.as_yaml)
      end
    end
  end
end
