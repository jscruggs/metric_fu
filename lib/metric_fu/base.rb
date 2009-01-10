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
    DEFAULT_METRICS = [:coverage, :churn, :flog, :flay, :reek, :roodi, :saikuro ]
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

      def save_html(content, file='index.html')
        open("#{@base_dir}/#{file}", "w") do |f|
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

    def churn
      configuration.churn
    end

    def coverage
      configuration.coverage
    end

    def flay
      configuration.flay
    end

    def flog
      configuration.flog
    end

    def metrics
      configuration.metrics
    end

    def open_in_browser?
      PLATFORM['darwin'] && !ENV['CC_BUILD_ARTIFACTS']
    end
    
    def saikuro
      configuration.saikuro
    end

    def reek
      configuration.reek
    end    

    def roodi
      configuration.roodi
    end

  end
  
  class Configuration
    attr_accessor :churn, :coverage, :flay, :flog, :metrics, :reek, :roodi, :saikuro
    def initialize
      raise "Use config.churn instead of MetricFu::CHURN_OPTIONS" if defined? ::MetricFu::CHURN_OPTIONS
      raise "Use config.flog[:dirs_to_flog] instead of MetricFu::DIRECTORIES_TO_FLOG" if defined? ::MetricFu::DIRECTORIES_TO_FLOG
      raise "Use config.saikuro instead of MetricFu::SAIKURO_OPTIONS" if defined? ::MetricFu::SAIKURO_OPTIONS      
      reset      
    end
    
    def self.run()  
      yield MetricFu.configuration
    end
    
    def reset
      @churn    =  {}
      @coverage = { :test_files => ['test/**/*_test.rb', 'spec/**/*_spec.rb'] }
      @flay     = { :dirs_to_flay => CODE_DIRS}
      @flog     = { :dirs_to_flog => CODE_DIRS}
      @reek     = { :dirs_to_reek => CODE_DIRS}
      @roodi    = { :dirs_to_roodi => CODE_DIRS}
      @metrics          = DEFAULT_METRICS
      @saikuro  = {}
    end
    
    def saikuro=(options)
      raise "saikuro need to be a Hash" unless options.is_a?(Hash)
      @saikuro = options
    end
  end
end