require 'rake'
require 'metric_fu/run'
namespace :metrics do
  desc "Generate all metrics reports"
  task :all do
    options = {}
    MetricFu.run(options)
  end
  MetricFu::Metric.enabled_metrics.each do |metric|
    name = metric.name
    desc "Generate report for #{name}"
    task metric.name do
      MetricFu.run_only(name)
    end
  end
end
