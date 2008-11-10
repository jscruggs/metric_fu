module MetricFu
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
  
  module Base
    class Generator
      
      def initialize(base_dir, options)
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
    end
  end
end

require File.join(File.dirname(__FILE__), 'metric_fu', 'md5_tracker')
require File.join(File.dirname(__FILE__), 'metric_fu', 'flog_reporter')
require File.join(File.dirname(__FILE__), 'metric_fu', 'flay_reporter')
require File.join(File.dirname(__FILE__), 'tasks', 'metric_fu')