# Encapsulates the configuration options for each metric
module MetricFu
  class Metric

    attr_accessor :enabled

    def initialize
      self.enabled = false
    end

    def enable
      self.enabled = true
    end

    # @return metric name [Symbol]
    def metric_name
      not_implemented
    end

    # @return metric run options [Hash]
    def run_options
      not_implemented
    end

    # @return metric_options [Hash]
    def has_graph?
      not_implemented
    end

    @metrics = []
    # @return all subclassed metrics [Array<MetricFu::Metric>]
    def self.metrics
      @metrics
    end

    def self.get_metric(metric_name)
      metrics.find{|metric|metric.metric_name.to_s == metric_name.to_s}
    end

    def self.inherited(subclass)
      @metrics << subclass.new
    end

    private

    def not_implemented
      raise "Required method #{caller[0]} not implemented in #{__FILE__}"
    end
  end
end
