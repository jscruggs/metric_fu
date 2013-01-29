MetricFu::Configuration.run do |config|
  config.add_graph_engine(:bluff)
  config.add_graph_engine(:gchart)
  config.configure_graph_engine(:bluff) # can be :bluff or :gchart
end
