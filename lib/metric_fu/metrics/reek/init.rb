MetricFu::Configuration.run do |config|
  config.add_metric(:reek)
  config.add_graph(:reek)
  config.configure_metric(:reek,
      { :dirs_to_reek => MetricFu.code_dirs,
                    :config_file_pattern => nil})
end
