module MetricFu
  class Grapher
    attr_accessor :output_directory

    def initialize(opts = {})
      self.class.require_graphing_gem
      self.output_directory = opts[:output_directory]
    end

    def output_directory
      @output_directory || MetricFu::Io::FileSystem.directory('output_directory')
    end

    def self.require_graphing_gem
      # to be overridden by charting engines
    end

    def self.graph_engine
      MetricFu.configuration.graph_engine
    end

    def get_metrics(metrics, sortable_prefix)
      not_implemented
    end

    def graph!
      not_implemented
    end

    def title
      not_implemented
    end

    def date
      not_implemented
    end

    def output_filename
      not_implemented
    end

    private

    def not_implemented
      raise "#{__LINE__} in #{__FILE__} from #{caller[0]}"
    end

  end
end
