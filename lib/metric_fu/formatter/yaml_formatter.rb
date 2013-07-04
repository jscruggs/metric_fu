module MetricFu
  module Formatter
    class YAMLFormatter < Base

      def finish
        save_output(@result.as_yaml)
      end
    end
  end
end
