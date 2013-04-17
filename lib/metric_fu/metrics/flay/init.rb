MetricFu::Configuration.run do |config|
  require 'flay'
  config.add_metric(:flay)
  config.add_graph(:flay)
  config.configure_metric(:flay,
                    { :dirs_to_flay => MetricFu.code_dirs, # was @code_dirs
                    :minimum_score => 100,
                    :filetypes => ['rb'] }
                          )
end
