module MetricFu
  class MetricCane < Metric

    def metric_name
      :cane
    end

    def run_options
      {
        :dirs_to_cane => MetricFu.code_dirs,
        :abc_max => 15,
        :line_length => 80,
        :no_doc => 'n',
        :no_readme => 'n',
        :filetypes => ['rb']
      }
    end

    def has_graph?
      true
    end

    def enable
      if MetricFu.configuration.supports_ripper?
        super
      else
        MetricFu.configuration.mf_debug("Cane is only available in MRI. It requires ripper")
      end
    end

  end
end
