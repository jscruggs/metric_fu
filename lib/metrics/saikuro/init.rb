MetricFu::Configuration.run do |config|
  config.add_metric(:saikuro)
  config.configure_metric(:saikuro,
      { :output_directory => "#{MetricFu.scratch_directory}/saikuro",
                    :input_directory =>MetricFu.code_dirs,
                    :cyclo => "",
                    :filter_cyclo => "0",
                    :warn_cyclo => "5",
                    :error_cyclo => "7",
                    :formater => "text"})
end
