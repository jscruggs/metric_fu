# require these first because others depend on them
MetricFu.reporting_require { 'report' }
MetricFu.metrics_require   { 'generator' }
MetricFu.metrics_require   { 'graph' }
MetricFu.reporting_require { 'graphs/grapher' }
MetricFu.metrics_require   { 'hotspots/analysis/scoring_strategies' }

# Now load everything else that's in the directory
Dir.glob(File.join(MetricFu.lib_dir, '*.rb')).each do |file|
  require file
end
# prevent the task from being run multiple times.
unless Rake::Task.task_defined? "metrics:all"
  # Load the rakefile so users of the gem get the default metric_fu task
  MetricFu.tasks_load 'metric_fu.rake'
end
Dir.glob(File.join(MetricFu.data_structures_dir, '**/*.rb')).each do |file|
  require file
end
Dir.glob(File.join(MetricFu.logging_dir, '**/*.rb')).each do |file|
  require file
end
Dir.glob(File.join(MetricFu.errors_dir, '**/*.rb')).each do |file|
  require file
end
Dir.glob(File.join(MetricFu.metrics_dir, '**/*.rb')).each do |file|
  require file
end
Dir.glob(File.join(MetricFu.reporting_dir, '**/*.rb')).each do |file|
  require file
end
# Dir[File.expand_path File.join(base_dir, '*.rb')].each{|l| require l }
# Dir[File.expand_path File.join(generator_dir, '*.rb')].each {|l| require l }
# Dir[File.expand_path File.join(template_dir, 'standard/*.rb')].each {|l| require l}
# Dir[File.expand_path File.join(template_dir, 'awesome/*.rb')].each {|l| require l}
# require graph_dir + "/grapher"
# Dir[File.expand_path File.join(graph_dir, '*.rb')].each {|l| require l}
# Dir[File.expand_path File.join(graph_dir, 'engines', '*.rb')].each {|l| require l}
