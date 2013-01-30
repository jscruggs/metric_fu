MetricFu::Configuration.run do |config|
  if RUBY_VERSION < '1.9'
    config.mf_debug "rails_best_practices is not compatible with #{RUBY_VERSION}"
  elsif config.rails?
    config.add_metric(:rails_best_practices)
    config.add_graph(:rails_best_practices)
    config.configure_metric(:rails_best_practices, {})
  end
end
