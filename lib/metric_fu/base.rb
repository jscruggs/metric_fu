require 'erb'
module MetricFu

  TEMPLATE_DIR = File.join(File.dirname(__FILE__), '..', 'templates')
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
  RAILS = File.exist?("config/environment.rb")

  if RAILS
    CODE_DIRS = ['app', 'lib']
    DEFAULT_METRICS = [:coverage, :churn, :flog, :flay, :railroad, :reek, :roodi, :stats, :saikuro ]
  else
    CODE_DIRS = ['lib']
    DEFAULT_METRICS = [:coverage, :churn, :flog, :flay, :saikuro ]
  end 

  module Base
    
    ######################################################################
    # Base class for report Generators
    #
    class Generator

      def initialize(base_dir, options={})
        @base_dir = base_dir
      end

      # generates a report for base_dir
      def self.generate_report(base_dir, options={})
        FileUtils.mkdir_p(base_dir, :verbose => false) unless File.directory?(base_dir)
        self.new(base_dir, options).generate_report
      end

      def save_html(content, file='index')
        open("#{@base_dir}/#{file}.html", "w") do |f|
          f.puts content
        end
      end

      def generate_report
        save_html(generate_html)
      end

      def generate_html
        analyze
        html = ERB.new(File.read(template_file)).result(binding)
      end
      
      def template_name
        self.class.to_s.split('::').last.downcase
      end

      def template_file
        File.join(MetricFu::TEMPLATE_DIR, "#{template_name}.html.erb")
      end
      
      ########################
      # Template methods
      
      def inline_css(css)
	      open(File.join(MetricFu::TEMPLATE_DIR, css)) { |f| f.read }      
      end
      
      def link_to_filename(name, line = nil)
        filename = File.expand_path(name)
        if PLATFORM['darwin']
          %{<a href="txmt://open/?url=file://#{filename}&line=#{line}">#{name}</a>}
        else
          %{<a href="file://#{filename}">#{name}</a>}
        end
      end
      
      def cycle(first_value, second_value, iteration)
        return first_value if iteration % 2 == 0
        return second_value
      end      
    end
  end
  
  class << self
    # The Configuration instance used to configure the Rails environment
    def configuration
      @@configuration ||= Configuration.new
    end

    def churn_options
      configuration.churn_options
    end

    def coverage_options
      configuration.coverage_options
    end

    def flay_options
      configuration.flay_options
    end

    def flog_options
      configuration.flog_options
    end

    def metrics
      configuration.metrics
    end

    def open_in_browser?
      PLATFORM['darwin'] && configuration.open_in_browser
    end
    
    def saikuro_options
      configuration.saikuro_options
    end
    
  end
  
  class Configuration
    attr_accessor :churn_options, :coverage_options, :flay_options, :flog_options, :metrics, :open_in_browser, :saikuro_options
    def initialize
      raise "Use config.churn_options instead of MetricFu::CHURN_OPTIONS" if defined? ::MetricFu::CHURN_OPTIONS
      raise "Use config.flog_options[:dirs_to_flog] instead of MetricFu::DIRECTORIES_TO_FLOG" if defined? ::MetricFu::DIRECTORIES_TO_FLOG
      raise "Use config.saikuro_options instead of MetricFu::SAIKURO_OPTIONS" if defined? ::MetricFu::SAIKURO_OPTIONS      
      reset      
    end
    
    def self.run()  
      yield MetricFu.configuration
    end
    
    def reset
      @churn_options    =  {}
      @coverage_options = { :test_files => ['test/**/*_test.rb', 'spec/**/*_spec.rb'] }
      @flay_options     = { :dirs_to_flay => CODE_DIRS}
      @flog_options     = { :dirs_to_flog => CODE_DIRS}
      @metrics          = DEFAULT_METRICS
      @open_in_browser  = true
      @saikuro_options  = {}
    end
    
    def saikuro_options=(options)
      raise "saikuro_options need to be a Hash" unless options.is_a?(Hash)
      @saikuro_options = options
    end
  end
end