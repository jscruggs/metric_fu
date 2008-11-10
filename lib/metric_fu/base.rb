module MetricFu
  TEMPLATE_DIR = File.join(File.dirname(__FILE__), "templates")
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
  RAILS = File.exist?("config/environment.rb")

  if RAILS
    CODE_DIRS = ['app', 'lib']
  else
    CODE_DIRS = ['lib']
  end
  
  module Base
    class Generator
      
      def initialize(base_dir, options={})
        @base_dir = base_dir
      end      
      
      def self.generate_report(base_dir, options={})
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
    end
  end
end