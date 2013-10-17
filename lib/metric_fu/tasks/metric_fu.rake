require 'rake'
require 'metric_fu/run'
namespace :metrics do
  desc "Generate all metrics reports"
  task :all do
    options = {}
    run(options)
  end
  MetricFu::Metric.enabled_metrics.each do |metric|
    name = metric.name
    desc "Generate report for #{name}"
    task metric.name do
      run_only(name)
    end
  end
  def run(options)
    MetricFu::Run.new.run(options)
  end
  def run_only(metric_name)
    MetricFu::Configuration.run do |config|
      config.configure_metrics.each do |metric|
        if metric.name.to_s == metric_name.to_s
          p "Enabling #{metric}"
          metric.enabled = true
        else
          p "Disabling #{metric}"
          metric.enabled = false
        end
      end
    end
    run({})
  end
end
