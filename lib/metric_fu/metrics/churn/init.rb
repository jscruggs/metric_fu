MetricFu::Configuration.run do |config|
  config.add_metric(:churn)
  config.configure_metric(:churn,
        { :start_date => %q("1 year ago"), :minimum_churn_count => 10})
end
