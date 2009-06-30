require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe MetricFu do
  
  describe "responding to #graph" do
    it "should return an instance of Graph" do
      MetricFu.graph.should be_a(Graph)
    end
  end
end

describe MetricFu::Graph do
  
  before(:each) do
    @graph = MetricFu::Graph.new
  end
  
  describe "responding to #add" do
    it 'should instantiate a grapher and push it to clazz' do
      @graph.clazz.should_receive(:push).with(an_instance_of(RcovGrapher))
      @graph.add("rcov")
    end
  end  
end
