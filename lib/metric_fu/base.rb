require 'erb'
require 'yaml'
module MetricFu


  def self.configuration
    @@configuration ||= Configuration.new
  end
 
  methods = %w(output churn coverage flay flog saikuro reek roodi metrics)
  methods.each do |meth|
    method = <<-EOF
    def self.#{meth}
      configuration.send(:#{meth})
    end
    EOF
    class_eval(method)
  end

  def self.open_in_browser?
    PLATFORM['darwin'] && !ENV['CC_BUILD_ARTIFACTS']
  end


end



module MetricFu::TemplateHelpers
    
  def inline_css(css)
    open(File.join(MetricFu::TEMPLATE_DIR, css)) { |f| f.read }      
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
      File.join(MetricFu::TEMPLATE_DIR, @name + extension)
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
      File.join(MetricFu::BASE_DIRECTORY, class_name) 
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
  attr_accessor :churn, :coverage, :flay, 
                :flog, :metrics, :reek, 
                :roodi, :saikuro, :output

  def initialize
    warn_about_deprecated_config_options
    reset      
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
    @churn    =  {}
    @coverage = { :test_files => ['test/**/*_test.rb', 
                                  'spec/**/*_spec.rb'],
                  :rcov_opts => ["--sort coverage", 
                                 "--html", 
                                 "--rails", 
                                 "--exclude /gems/,/Library/,spec"] }
    @flay     = { :dirs_to_flay => MetricFu::CODE_DIRS}
    @flog     = { :dirs_to_flog => MetricFu::CODE_DIRS}
    @reek     = { :dirs_to_reek => MetricFu::CODE_DIRS}
    @roodi    = { :dirs_to_roodi => MetricFu::CODE_DIRS}
    @metrics          = MetricFu::DEFAULT_METRICS
    @saikuro  = {}
  end
  
  def saikuro=(options)
    raise "saikuro need to be a Hash" unless options.is_a?(Hash)
    @saikuro = options
  end
end
