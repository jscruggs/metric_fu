require 'erb'
module MetricFu

  TEMPLATE_DIR = File.join(File.dirname(__FILE__), '..', 'templates')
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
  RAILS = File.exist?("config/environment.rb")

  if RAILS
    CODE_DIRS = ['app', 'lib']
  else
    CODE_DIRS = ['lib']
  end

  def self.open_in_browser?
    if defined?(MetricFu::OPEN_IN_BROWSER)
      PLATFORM['darwin'] && MetricFu::OPEN_IN_BROWSER
    else
      PLATFORM['darwin']
    end
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
end