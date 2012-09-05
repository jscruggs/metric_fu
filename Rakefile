$LOAD_PATH << '.'
require 'rake'
require 'rdoc/task'
begin
  require 'spec/rake/spectask'
  desc "Run all specs in spec directory"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  require 'rspec/core/rake_task'
  desc "Run all specs in spec directory"
  RSpec::Core::RakeTask.new(:spec)
  # do |t|
  #   t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  #   # Put spec opts in a file named .rspec in root
  # end
end

end
require 'lib/metric_fu'

  # RSpec.configure do |config|

  # end
MetricFu::Configuration.run do |config|
  config.roodi    = config.roodi.merge(:roodi_config => 'config/roodi_config.yml')
  config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
  config.hotspots = { :start_date => "1 year ago", :minimum_churn_count => 10}
end

task :default => :spec
