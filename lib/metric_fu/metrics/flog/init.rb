MetricFu::Configuration.run do |config|
  require 'flog'
  config.add_metric(:flog)
  config.add_graph(:flog)
  config.configure_metric(:flog,
                          { :dirs_to_flog => MetricFu.code_dirs  }
                          )
end
