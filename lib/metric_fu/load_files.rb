# require these first because others depend on them
MetricFu.reporting_require { 'result' }
MetricFu.metrics_require   { 'hotspots/hotspot' }
MetricFu.metrics_require   { 'generator' }
MetricFu.metrics_require   { 'graph' }
MetricFu.reporting_require { 'graphs/grapher' }
MetricFu.metrics_require   { 'hotspots/analysis/scoring_strategies' }

Dir.glob(File.join(MetricFu.lib_dir, '*.rb')).
  reject{|file| file =~ /#{__FILE__}|ext.rb/}.
  each do |file|
    require file
end

MetricFu.load_tasks('metric_fu.rake', task_name: 'metrics:all')

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
  require(file) unless file =~ /init.rb/
end
Dir.glob(File.join(MetricFu.reporting_dir, '**/*.rb')).each do |file|
  require file
end
Dir.glob(File.join(MetricFu.formatter_dir, '**/*.rb')).each do |file|
  require file
end
