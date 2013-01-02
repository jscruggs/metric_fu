require 'fileutils'
MetricFu.reporting_require { 'templates/awesome/awesome_template' }
module MetricFu

  # A list of metrics which are available in the MetricFu system.
  #
  # These are metrics which have been developed for the system.  Of
  # course, in order to use these metrics, their respective gems must
  # be installed on the system.
  AVAILABLE_METRICS = [:churn,
                      :flog,
                      :flay,
                      :reek,
                      :roodi,
                      :rcov,
                      :hotspots,
                      :saikuro
  ]

  AVAILABLE_GRAPHS = [
    :flog,
    :flay,
    :reek,
    :roodi,
    :rcov,
    :rails_best_practices
  ]
  AVAILABLE_GRAPH_ENGINES = [:gchart, :bluff]

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
  # == Deprications
  #
  # The Configuration class checks for several deprecated constants
  # that were previously used to configure MetricFu.  These include
  # CHURN_OPTIONS, DIRECTORIES_TO_FLOG, SAIKURO_OPTIONS,
  # and MetricFu::SAIKURO_OPTIONS.
  #
  # These have been replaced by config.churn, config.flog and
  # config.saikuro respectively.
  class Configuration

    def initialize #:nodoc:#
      reset
      add_attr_accessors_to_self
      add_class_methods_to_metric_fu
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

    # This does the real work of the Configuration class, by setting
    # up a bunch of instance variables to represent the configuration
    # of the MetricFu app.
    # TODO review if these code is functionally duplicated in the
    # base generator initialize
    def reset
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
      @template_class = AwesomeTemplate
      set_metrics
      set_graphs
      set_code_dirs
      @flay     = { :dirs_to_flay => @code_dirs,
                    :minimum_score => 100,
                    :filetypes => ['rb'] }
      @flog     = { :dirs_to_flog => @code_dirs  }
      @reek     = { :dirs_to_reek => @code_dirs,
                    :config_file_pattern => nil}
      @roodi    = { :dirs_to_roodi => @code_dirs,
                    :roodi_config => nil }
      @saikuro  = { :output_directory => "#{@scratch_directory}/saikuro",
                    :input_directory => @code_dirs,
                    :cyclo => "",
                    :filter_cyclo => "0",
                    :warn_cyclo => "5",
                    :error_cyclo => "7",
                    :formater => "text"}
      @churn    = {}
      @stats    = {}
      @rcov     = { :environment => 'test',
                    :test_files => ['test/**/*_test.rb',
                                    'spec/spec_helper.rb', # NOTE: ensure it is loaded before the specs
                                    'spec/**/*_spec.rb'],
                    :rcov_opts => ["--sort coverage",
                                   "--no-html",
                                   "--text-coverage",
                                   "--no-color",
                                   "--profile",
                                   "--rails",
                                   "--exclude /gems/,/Library/,/usr/,spec"],
                    :external => nil
                  }
      @rails_best_practices = {}
      @hotspots = {}
      @file_globs_to_ignore = []
      @link_prefix = nil


      @verbose = false

      @graph_engine = :bluff # can be :bluff or :gchart

      @darwin_txmt_protocol_no_thanks = true
      # uses the CodeRay gem (was syntax gem)
      @syntax_highlighting = true #Can be set to false to avoid UTF-8 issues with Ruby 1.9.2 and Syntax 1.0
    end

    # Perform a simple check to try and guess if we're running
    # against a rails app.
    #
    # @todo  This should probably be made a bit more robust.
    def rails?
      @rails = File.exist?("config/environment.rb")
    end

    # Add the :stats task to the AVAILABLE_METRICS constant if we're
    # running within rails.
    def set_metrics
      if rails?
        @metrics = MetricFu::AVAILABLE_METRICS + [
          :stats,
          :rails_best_practices
        ]
      else
        @metrics = MetricFu::AVAILABLE_METRICS
      end
    end

    def set_graphs
      if rails?
        @graphs = MetricFu::AVAILABLE_GRAPHS + [
          :stats
        ]
      else
        @graphs = MetricFu::AVAILABLE_GRAPHS
      end
    end

    # Add the 'app' directory if we're running within rails.
    def set_code_dirs
      if rails?
        @code_dirs = ['app', 'lib']
      else
        @code_dirs = ['lib']
      end
    end

    def platform #:nodoc:
      return RUBY_PLATFORM
    end

    def is_cruise_control_rb?
      !!ENV['CC_BUILD_ARTIFACTS']
    end
  end
end
