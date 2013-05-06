# TODO remove explicit Churn dependency
MetricFu::Configuration.run do |config|
  config.add_metric(:hotspots)
  config.configure_metric(:hotspots,
      { :start_date => "1 year ago", :minimum_churn_count => 10})
end
