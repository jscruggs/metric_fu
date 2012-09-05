require 'rake'
namespace :metrics do
  desc "Generate all metrics reports"
  task :all do
    STDOUT.sync = true
    MetricFu::Configuration.run {}
    MetricFu.metrics.each {|metric| 
      mf_debug "** STARTING METRIC #{metric}"
      MetricFu.report.add(metric) 
      mf_debug "** ENDING METRIC #{metric}"
    }
    mf_debug "** SAVING REPORT YAML OUTPUT TO #{MetricFu.base_directory}"
    MetricFu.report.save_output(MetricFu.report.to_yaml,
                                MetricFu.base_directory,
                                "report.yml")
    mf_debug "** SAVING REPORT DATA OUTPUT TO #{MetricFu.data_directory}"
    MetricFu.report.save_output(MetricFu.report.to_yaml,
                                MetricFu.data_directory,
                                "#{Time.now.strftime("%Y%m%d")}.yml")
    mf_debug "** SAVING TEMPLATIZED REPORT"
    MetricFu.report.save_templatized_report

    mf_debug "** PREPARING TO GRAPH"
    MetricFu.graphs.each {|graph| 
      mf_debug "** Graphing #{graph} with #{MetricFu.graph_engine}"
      MetricFu.graph.add(graph, MetricFu.graph_engine) 
    }
    mf_debug "** GENERATING GRAPH"
    MetricFu.graph.generate

    if MetricFu.report.open_in_browser?
      mf_debug "** OPENING IN BROWSER FROM #{MetricFu.output_directory}"
      MetricFu.report.show_in_browser(MetricFu.output_directory)
    end
  end
end
