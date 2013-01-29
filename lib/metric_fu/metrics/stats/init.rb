MetricFu::Configuration.run do |config|
  if config.rails?
    config.add_metric(:stats)
    config.add_graph(:stats)
    config.configure_metric(:stats,{})
  end
end
