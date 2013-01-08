MetricFu::Configuration.run do |config|
  config.add_metric(:roodi)
  config.add_graph(:roodi)
  config.configure_metric(:roodi,
      { :dirs_to_roodi => MetricFu.code_dirs,
                    :roodi_config => "#{MetricFu.root_dir}/config/roodi_config.yml"})
end
