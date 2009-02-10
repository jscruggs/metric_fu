require File.join(File.dirname(__FILE__), 'metric_fu', 'metric_fu')
require File.join(File.dirname(__FILE__), 'metric_fu', 'generator')
require File.join(File.dirname(__FILE__), 'tasks', 'metric_fu')
Dir[File.join(File.dirname(__FILE__), 'metric_fu/*.rb')].each{|l| require l }
Dir[File.join(File.dirname(__FILE__), 'templates', 'standard/*.rb')].each {|l| require l}
