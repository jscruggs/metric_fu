MetricFu::Configuration.run do |config|
  if config.rails?
    config.add_metric(:rails_best_practices)
    config.add_graph(:rails_best_practices)
    config.configure_metric(:rails_best_practices, {})
  end
end
