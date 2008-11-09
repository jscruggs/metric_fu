module MetricFu
  TEMPLATE_DIR = File.join(File.dirname(__FILE__), "templates")
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
  RAILS = File.exist?("config/environment.rb")
  
  if RAILS
    CODE_DIRS = ['app', 'lib']
  else
    CODE_DIRS = ['lib']
  end
end

require File.join(File.dirname(__FILE__), 'tasks', 'metric_fu')
Dir[File.join(File.dirname(__FILE__), 'metric_fu/*.rb')].each{|l| require l }