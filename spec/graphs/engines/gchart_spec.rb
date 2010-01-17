require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Gchart graphers responding to #graph!" do
  MetricFu::AVAILABLE_GRAPHS.each do |metric|
    it "should write chart file for #{metric}" do
      MetricFu.configuration
      grapher = MetricFu.const_get("#{metric.to_s.capitalize}GchartGrapher").new
      grapher.flog_average, grapher.top_five_percent_average = [7.0],[20.0] if metric == :flog #googlecharts gem has problems with [[],[]] as data
      grapher.graph!
      lambda{ File.open(File.join(MetricFu.output_directory, "#{metric.to_s.downcase}.png")) }.should_not raise_error
    end
  end
end