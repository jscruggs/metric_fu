require 'rubygems'
require 'spec'
require 'date'

require File.join(File.dirname(__FILE__), '/../lib/metric_fu/base')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/flay_reporter')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/md5_tracker')
require File.join(File.dirname(__FILE__), '/../lib/metric_fu/churn')
include MetricFu