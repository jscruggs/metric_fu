require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require File.join(File.dirname(__FILE__), 'lib', 'metric_fu')

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end
MetricFu::Configuration.run do |config|
  config.output     = { :type => :yml }
  config.metrics    = [ :roodi ]
  #define which metrics you want to use
  # config.metrics          = [:coverage, :flog]
  # config.churn    = { :start_date => lambda{ 3.months.ago } }  
  # config.coverage = { :test_files => ['test/**/test_*.rb'] }
  # config.flog     = { :dirs_to_flog => ['cms/app', 'cms/lib']  }
  # config.flay     = { :dirs_to_flay => ['cms/app', 'cms/lib']  }  
  # config.saikuro  = { "--warn_cyclo" => "3", "--error_cyclo" => "4" }
end

task :default => [:"metrics:all"]
