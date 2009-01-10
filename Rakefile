require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require File.join(File.dirname(__FILE__), 'lib', 'metric_fu')

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

MetricFu::Configuration.run do |config|
  config.metrics = [:flog]
end
task :default => [:"metrics:all"]