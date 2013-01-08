require 'fileutils'
MetricFu.reporting_require { 'templates/awesome/awesome_template' }
module MetricFu


  # The @@configuration class variable holds a global type configuration
  # object for any parts of the system to use.
  def self.configuration
    @@configuration ||= Configuration.new
  end

  # = Configuration
  #
  # The Configuration class, as it sounds, provides methods for
  # configuring the behaviour of MetricFu.
  #
  # == Customization for Rails
  #
  # The Configuration class checks for the presence of a
  # 'config/environment.rb' file.  If the file is present, it assumes
  # it is running in a Rails project.  If it is, it will:
  #
  # * Add 'app' to the @code_dirs directory to include the
  #   code in the app directory in the processing
  # * Add :stats to the list of metrics to run to get the Rails stats
  #   task
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
  # Each metric can be configured by e.g. config.churn, config.flog, config.saikuro
  class Configuration

    def initialize #:nodoc:#
      @verbose = false
      set_directories
      configure_template
      add_instance_variable(:metrics, [])
      add_instance_variable(:graphs, [])
      add_instance_variable(:graph_engines, [])
      add_promiscuous_method(:graph_engine)
      # TODO this needs to go
      # we should use attr_accessors instead
      # TODO review if these code is functionally duplicated in the
      # base generator initialize
      add_attr_accessors_to_self
      add_class_methods_to_metric_fu
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
      @metrics = (@metrics << metric).uniq
    end

    # e.g. :reek
    def add_graph(metric)
      add_promiscuous_method(metric)
      @graphs = (@graphs << metric).uniq
    end

    # e.g. :reek, {}
    def configure_metric(metric, metric_configuration)
      add_instance_variable(metric, metric_configuration)
    end

    # e.g. :bluff
    def add_graph_engine(graph_engine)
      add_promiscuous_method(graph_engine)
      @graph_engines = (@graph_engines << graph_engine).uniq
    end

    # e.g. :bluff
    def configure_graph_engine(graph_engine)
      add_instance_variable(:graph_engine, graph_engine)
    end

    # Perform a simple check to try and guess if we're running
    # against a rails app.
    #
    # @todo  This should probably be made a bit more robust.
    def rails?
      @rails = File.exist?("config/environment.rb")
    end

    def is_cruise_control_rb?
      !!ENV['CC_BUILD_ARTIFACTS']
    end

    def platform #:nodoc:
      return RUBY_PLATFORM
    end

    private

    def configure_template
      @template_class = AwesomeTemplate
      @link_prefix = nil
      @darwin_txmt_protocol_no_thanks = true
      # uses the CodeRay gem (was syntax gem)
      @syntax_highlighting = true #Can be set to false to avoid UTF-8 issues with Ruby 1.9.2 and Syntax 1.0
    end

    def set_directories
      @base_directory    = MetricFu.artifact_dir
      @scratch_directory = MetricFu.scratch_dir
      @output_directory  = MetricFu.output_dir
      @data_directory    = MetricFu.data_dir
      # due to behavior differences between ruby 1.8.7 and 1.9.3
      # this is good enough for now
      [@base_directory, @scratch_directory, @output_directory].each do |dir|
        FileUtils.mkdir_p dir
      end
      @metric_fu_root_directory = MetricFu.root_dir
      @template_directory =  File.join(@metric_fu_root_directory,
                                       'lib', 'templates')
      @file_globs_to_ignore = []
      set_code_dirs
    end

    # Add the 'app' directory if we're running within rails.
    def set_code_dirs
      if rails?
        @code_dirs = ['app', 'lib']
      else
        @code_dirs = ['lib']
      end
    end

    def add_instance_variable(name,value)
      instance_variable_set("@#{name}", value)
      method_name = name.to_s[1..-1].to_sym
      add_promiscuous_method(method_name)
    end
    def add_promiscuous_method(method_name)
      # def add_class_methods_to_metric_fu
        metric_fu_method = <<-EOF
                  def self.#{method_name}
                    configuration.send(:#{method_name})
                  end
        EOF
      # def add_attr_accessors_to_self
        MetricFu.module_eval(metric_fu_method)
        self.class.send(:attr_accessor, method_name.to_sym)
    end

    # Searches through the instance variables of the class and
    # creates a class method on the MetricFu module to read the value
    # of the instance variable from the Configuration class.
    def add_class_methods_to_metric_fu
      instance_variables.each do |name|
        method_name = name[1..-1].to_sym
        method = <<-EOF
                  def self.#{method_name}
                    configuration.send(:#{method_name})
                  end
        EOF
        MetricFu.module_eval(method)
      end
    end

    # Searches through the instance variables of the class and creates
    # an attribute accessor on this instance of the Configuration
    # class for each instance variable.
    def add_attr_accessors_to_self
      instance_variables.each do |name|
        method_name = name[1..-1].to_sym
        MetricFu::Configuration.send(:attr_accessor, method_name)
      end
    end

  end
end
