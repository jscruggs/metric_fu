require 'fileutils'
MetricFu.logging_require { 'mf_debugger' }
module MetricFu


  # The @configuration class variable holds a global type configuration
  # object for any parts of the system to use.
  # TODO Configuration should probably be a singleton class
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    Dir.glob(File.join(MetricFu.metrics_dir, '**/init.rb')).each{|init_file|require(init_file)}
    reconfigure
  end

  def self.reconfigure
    MetricFu::Configuration.run do |config|
      MetricFu::Metric.metrics.each do |metric|
        if block_given?
          yield metric
        elsif !metric_manually_configured?(metric)
          metric.enabled = false
          metric.enable
        end
        next unless metric.enabled
        next unless metric.activated || metric.activate
        config.add_metric(metric.metric_name)
        config.add_graph(metric.metric_name) if metric.has_graph?
        config.configure_metric(metric.metric_name, metric.run_options)
      end
    end
    MetricFu.configuration
  end

  def self.metric_manually_configured?(metric)
    [:rcov].include?(metric.metric_name)
  end

  def self.run_rcov
    MetricFu::Metric.get_metric(:rcov).enabled = true
  end
  def self.skip_rcov
    MetricFu::Metric.get_metric(:rcov).enabled = false
    MetricFu.metrics -= [:rcov]
    MetricFu.graphs  -= [:rcov]
  end
  def self.mri_only_metrics
    if MetricFu.configuration.mri?
      []
    else
      [:cane, :flog, :rails_best_practices]
    end
  end

  # = Configuration
  #
  # The Configuration class, as it sounds, provides methods for
  # configuring the behaviour of MetricFu.
  #
  # == Customization for CruiseControl.rb
  #
  # The Configuration class checks for the presence of a
  # 'CC_BUILD_ARTIFACTS' environment variable.  If it's found
  # it will change the default output directory from the default
  # "tmp/metric_fu to the directory represented by 'CC_BUILD_ARTIFACTS'
  #
  # == Metric Configuration
  #
  # Each metric can be configured by e.g. config.get_metric(:churn)
  class Configuration
    require_relative 'environment'
    require_relative 'io'
    require_relative 'formatter'
    include MetricFu::Environment

    def initialize #:nodoc:#
      reset
    end

    def mf_debug(msg)
      MfDebugger.mf_debug msg
    end

    # TODO review if these code is functionally duplicated in the
    # base generator initialize
    def reset
      MetricFu::Io::FileSystem.set_directories(self)
      MetricFu::Formatter::Templates.configure_template(self)
      add_promiscuous_instance_variable(:metrics, [])
      add_promiscuous_instance_variable(:formatters, [])
      add_promiscuous_instance_variable(:graphs, [])
      add_promiscuous_instance_variable(:graph_engines, [])
      add_promiscuous_method(:graph_engine)
    end

    # This allows us to have a nice syntax like:
    #
    #   MetricFu.run do |config|
    #     config.base_directory = 'tmp/metric_fu'
    #   end
    #
    # See the README for more information on configuration options.
    def self.run
      yield MetricFu.configuration
    end

    attr_accessor :metrics
    # e.g. :churn
    def add_metric(metric)
      add_promiscuous_method(metric)
      self.metrics = (metrics << metric).uniq
    end

    # e.g. :reek
    def add_graph(metric)
      add_promiscuous_method(metric)
      self.graphs = (graphs << metric).uniq
    end

    def add_formatter(format, output = nil)
      @formatters << MetricFu::Formatter.class_for(format).new(output: output)
    end

    # e.g. :reek, {}
    def configure_metric(metric, metric_configuration)
      add_promiscuous_instance_variable(metric, metric_configuration)
    end

    # e.g. :bluff
    def add_graph_engine(graph_engine)
      add_promiscuous_method(graph_engine)
      self.graph_engines = (graph_engines << graph_engine).uniq
    end

    # e.g. :bluff
    def configure_graph_engine(graph_engine)
      add_promiscuous_instance_variable(:graph_engine, graph_engine)
    end

    protected unless ruby_strangely_makes_accessors_private?

    def add_promiscuous_instance_variable(name,value)
      instance_variable_set("@#{name}", value)
      add_promiscuous_method(name)
      value
    end

    def add_promiscuous_method(method_name)
        add_promiscuous_class_method_to_metric_fu(method_name)
        add_accessor_to_config(method_name)
    end

    def add_promiscuous_class_method_to_metric_fu(method_name)
        metric_fu_method = <<-EOF
                  def self.#{method_name}
                    configuration.send(:#{method_name})
                  end
        EOF
      MetricFu.module_eval(metric_fu_method)
    end


    def add_accessor_to_config(method_name)
      self.class.send(:attr_accessor, method_name)
    end

  end
end
