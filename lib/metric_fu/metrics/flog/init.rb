module MetricFu
  class MetricFlog < Metric

    def metric_name
      :flog
    end

    def run_options
      { :dirs_to_flog => MetricFu.code_dirs  }
    end

    def has_graph?
      true
    end

    def enable
      if MetricFu.configuration.mri?
        require 'flog'
        super
      else
        MetricFu.configuration.mf_debug("Flog is only available in MRI due to flog tasks")
      end
    end

  end
end
