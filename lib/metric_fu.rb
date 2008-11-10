require File.join(File.dirname(__FILE__), 'tasks', 'metric_fu')
require File.join(File.dirname(__FILE__), 'metric_fu', 'base') #require first because of dependecies
Dir[File.join(File.dirname(__FILE__), 'metric_fu/*.rb')].each{|l| require l }