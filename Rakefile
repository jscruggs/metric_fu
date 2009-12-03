require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'lib/metric_fu'

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
   t.rcov = true
   t.rcov_opts = ['--exclude', 'spec,config,Library,usr/lib/ruby']
   t.rcov_dir = File.join(File.dirname(__FILE__), "tmp")
end

#MetricFu::Configuration.run do |config|
#  config.template_class = AwesomeTemplate
#end

MetricFu::Configuration.run do |config|
  config.metrics  = [:churn]
  config.graphs   = []
  
  #config.churn    = { :start_date => "3 months ago", :minimum_churn_count => 10}
end

task :default => [:"metrics:all"]
