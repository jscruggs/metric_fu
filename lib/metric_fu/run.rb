MetricFu.configure
module MetricFu
  class Run
    def initialize
      STDOUT.sync = true
      load_user_configuration
    end
    def run(options={})
      disable_metrics(options)
      measure
      save_reports
      save_graphs
      display_results if options[:open]
    end

    # ensure :hotspots runs last
    def report_metrics(metrics=MetricFu.metrics)
      MetricFu.configuration.metrics.sort_by! {|x| x == :hotspots ? 1 : 0 }
      MetricFu.configuration.metrics
    end
    def measure
      reporter.start
      report_metrics.each {|metric|
        reporter.start_metric(metric)
        MetricFu.result.add(metric)
        reporter.finish_metric(metric)
      }
      reporter.finish
    end
    def display_results
      reporter.display_results
    end
    private
    def load_user_configuration
      file = File.join(Dir.pwd, '.metrics')
      load file if File.exist?(file)
    end
    def disable_metrics(options)
      return if options.size == 0
      report_metrics.each do |metric|
        if options[metric.to_sym]
          mf_debug "using metric #{metric}"
        else
          mf_debug "disabling metric #{metric}"
          MetricFu.configuration.metrics -= [ metric ]
          MetricFu.configuration.graphs -= [ metric ]
          mf_debug "active metrics are #{MetricFu.configuration.metrics.inspect}"
        end
      end
    end
    def reporter
      # TODO: load formatters from configured formatters.
      Reporter.new(
        MetricFu::Formatter::HTMLFormatter.new(
          MetricFu.result,
          dir: MetricFu.output_directory
        )
      )
    end
  end
end
