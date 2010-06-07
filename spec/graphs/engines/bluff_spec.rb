require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Bluff graphers responding to #graph!" do
  it "should write chart file" do
    MetricFu.configuration
    graphs = {}
    available_graphs = MetricFu::AVAILABLE_GRAPHS + [:stats]
    available_graphs.each do |graph|
      graphs[graph] = MetricFu.const_get("#{graph.to_s.capitalize}BluffGrapher").new
    end
    graphs.each do |key, val|
      val.graph!
      output_dir = File.expand_path(File.join(MetricFu.output_directory))
      lambda{ File.open(File.join(output_dir, "#{key.to_s.downcase}.js")) }.should_not raise_error
    end
  end
end
