# Load a few things to make our lives easier elsewhere.
module MetricFu
  LIB_ROOT = File.dirname(__FILE__)
end
metric_fu_dir = File.join(MetricFu::LIB_ROOT, 'metric_fu')
template_dir  = File.join(MetricFu::LIB_ROOT, 'templates')

# We need to require these two things first because our other classes
# depend on them.
require File.join(metric_fu_dir, 'report') 
require File.join(metric_fu_dir, 'generator')

# Now load everything else that's in the directory
Dir[File.join(metric_fu_dir, '*.rb')].each{|l| require l }
Dir[File.join(template_dir, 'standard/*.rb')].each {|l| require l}
