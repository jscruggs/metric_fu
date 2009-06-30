require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
describe MetricFu::FlogGrapher do
  it "should not fall over when given empty results" do
    MetricFu::Configuration.run {}
    
    gruff_line = Gruff::Line.new(MetricFu.graph_size)
    gruff_line.stub!(:write)
    Gruff::Line.stub!(:new).and_return(gruff_line)
    
    grapher = FlogGrapher.new()
    metrics_hash = {:flog => {:average => 0, :pages => [], :total => 0}}
    grapher.get_metrics(metrics_hash ,"20090629")
    grapher.graph!
  end
end