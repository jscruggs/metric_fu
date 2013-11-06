def metric_not_activated?(metric_name)
  MetricFu.configuration.configure_metrics
  if MetricFu::Metric.get_metric(metric_name.intern).activate
    false
  else
    p "Skipping #{metric_name} tests, not activated"
    true
  end
end

def breaks_when?(bool)
  p "Skipping tests in #{caller[0]}. They unnecessarily break the build." if bool
  bool
end

def compare_paths(path1, path2)
  File.join(MetricFu.root_dir, path1).should == File.join(MetricFu.root_dir, path2)
end
