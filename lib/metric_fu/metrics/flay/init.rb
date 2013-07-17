module MetricFu
  class MetricFlay < Metric

    def metric_name
      :flay
    end

    def run_options
      { :dirs_to_flay => MetricFu.code_dirs, # was @code_dirs
      :minimum_score => 100,
      :filetypes => ['rb'] }
    end

    def has_graph?
      true
    end

    def enable
      require 'flay'
      super
    end

  end
end
