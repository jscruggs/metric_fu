require 'rubygems'
require 'spec'
require 'date'

require File.join(File.dirname(__FILE__), '/../lib/metric_fu/base')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/flay')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/flog')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/md5_tracker')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/churn')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/reek')
include MetricFu