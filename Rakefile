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

MetricFu::Configuration.run do |config|
  config.template_class = AwesomeTemplate
end

namespace :metrics do
  desc "Generate all reports"
  task :all do
    MetricFu.metrics.each {|metric| MetricFu.report.add(metric) }
    MetricFu.report.save_output(MetricFu.report.to_yaml,
                                MetricFu.data_directory, 
                                "#{Time.now.strftime("%Y%m%d")}.yml")
    MetricFu.report.save_templatized_report
    if MetricFu.report.open_in_browser?
      MetricFu.report.show_in_browser(MetricFu.output_directory)
    end
  end

  MetricFu.metrics.each do |metric|
    desc "Generate report for #{metric}"
    task metric do

      MetricFu.report.add(metric)
      MetricFu.report.save_output(MetricFu.report.to_yaml,
                                  MetricFu.data_directory,
                                  "#{Time.now.strftime("%Y%m%d")}.yml")
      MetricFu.report.save_templatized_report
      if MetricFu.report.open_in_browser?
        MetricFu.report.show_in_browser(MetricFu.output_directory)
      end
    end
  end
end

task :default => [:"metrics:all"]
