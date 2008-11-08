module MetricFu
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
  RAILS = File.exist?("config/environment.rb")
end

require File.join(File.dirname(__FILE__), 'metric_fu', 'md5_tracker')
require File.join(File.dirname(__FILE__), 'metric_fu', 'flog_reporter')
require File.join(File.dirname(__FILE__), 'tasks', 'metric_fu')