module MetricFu
  class MetricRoodi < Metric

    def metric_name
      :roodi
    end

    def run_options
      { :dirs_to_roodi => MetricFu.code_dirs,
                    :roodi_config => "#{MetricFu.root_dir}/config/roodi_config.yml"}
    end

    def has_graph?
      true
    end

    def enable
      super
    end

  end
end
