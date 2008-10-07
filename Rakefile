require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'test/unit'
require File.join(File.dirname(__FILE__), 'lib', 'metric_fu')

task :test do
  runner = Test::Unit::AutoRunner.new(true)
  runner.to_run << 'test'
  runner.run
end

task :default => [:test, :"metrics:churn", :"metrics:flog:custom"] do
end

MetricFu::CHURN_OPTIONS = {:scm => :git}
MetricFu::DIRECTORIES_TO_FLOG = ["lib"]