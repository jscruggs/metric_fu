require 'erb'
require 'yaml'
module MetricFu

  def self.configuration
    @@configuration ||= Configuration.new
  end

end

module MetricFu::TemplateHelpers
    
  def inline_css(css)
    open(File.join(MetricFu.template_directory, css)) { |f| f.read }      
  end
 
  def link_to_filename(name, line = nil)
    filename = File.expand_path(name)
    if PLATFORM['darwin']
      %{<a href="txmt://open/?url=file://#{filename}&line=#{line}">#{name}:#{line}</a>}
    else
      %{<a href="file://#{filename}">#{name}:#{line}</a>}
    end
  end
  
  def cycle(first_value, second_value, iteration)
    return first_value if iteration % 2 == 0
    return second_value
  end      

end

class MetricFu::Template

  attr_reader :name, :file

  def initialize(name)
    @name = name
    @file = template_file
  end

  def template_file
    case MetricFu.output[:type]
    when :yml
      extension = MetricFu::YML_EXTENSION
    when :html
      extension = MetricFu::HTML_EXTENSION
    else
      extension = MetricFu::HTML_EXTENSION
    end
      File.join(MetricFu.template_directory, @name + extension)
  end      

end



module MetricFu::Base
  class Generator
    include MetricFu::TemplateHelpers

    attr_reader :report, :template

    def initialize(options={})
      @template = MetricFu::Template.new(self.class.class_name)
      create_metric_dir_if_missing
    end

    def self.class_name
      self.to_s.split('::').last.downcase
    end
    
    def self.metric_dir
      File.join(MetricFu.base_directory, class_name) 
    end

    def create_metric_dir_if_missing
      unless File.directory?(metric_dir)
        FileUtils.mkdir_p(metric_dir, :verbose => false) 
      end
    end

    def metric_dir
      self.class.metric_dir
    end

    def self.generate_report(options={})
      generator = self.new(options)
      generator.generate_report
    end

    def generate_report
      analyze
      to_yaml
    end

  end
end
  
class MetricFu::Configuration

  def initialize
    warn_about_deprecated_config_options
    reset
    add_attr_accessors_to_self
    add_class_methods_to_metric_fu
  end
 
  def add_class_methods_to_metric_fu
    instance_variables.each do |name|
      method_name = name[1..-1].to_sym
      method = "def self.#{method_name}; configuration.send(:#{method_name}); end"
      MetricFu.module_eval(method)
    end
  end
 
  def add_attr_accessors_to_self
    instance_variables.each do |name|
      method_name = name[1..-1].to_sym
      MetricFu::Configuration.send(:attr_accessor, method_name)
    end
  end

  def warn_about_deprecated_config_options
    if defined?(::MetricFu::CHURN_OPTIONS)
      raise("Use config.churn instead of MetricFu::CHURN_OPTIONS")
    end
    if defined?(::MetricFu::DIRECTORIES_TO_FLOG)
      raise("Use config.flog[:dirs_to_flog] "+
            "instead of MetricFu::DIRECTORIES_TO_FLOG") 
    end
    if defined?(::MetricFu::SAIKURO_OPTIONS)
      raise("Use config.saikuro instead of MetricFu::SAIKURO_OPTIONS")
    end
  end

  def self.run()  
    yield MetricFu.configuration
  end
  
  def reset
    @output   = { :type => MetricFu::HTML_EXTENSION }
    @base_directory = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
    @template_directory =  File.join(File.dirname(__FILE__), '..', 'templates')
    @rails = File.exist?("config/environment.rb") 
    @available_metrics =[:coverage, :churn, :flog,  :flay,
                        :reek, :roodi, :saikuro]
    if @rails
      @code_dirs = ['app', 'lib']
      @metrics = @available_metrics + :stats
    else
      @code_dirs = ['lib']
      @metrics = @available_metrics
    end
    @flay     = { :dirs_to_flay => @code_dirs  } 
    @flog     = { :dirs_to_flog => @code_dirs  }
    @reek     = { :dirs_to_reek => @code_dirs  }
    @roodi    = { :dirs_to_roodi => @code_dirs }
    @saikuro  = {}
    @churn    =  {}
    @coverage = { :test_files => ['test/**/*_test.rb', 
                                  'spec/**/*_spec.rb'],
                  :rcov_opts => ["--sort coverage", 
                                 "--html", 
                                 "--rails", 
                                 "--exclude /gems/,/Library/,spec"] }
  end

end
