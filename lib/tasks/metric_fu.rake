require 'rake'
namespace :metrics do
  desc "Generate all metrics reports"
  task :all do
    MetricFu::Run.new.run
  end
end
