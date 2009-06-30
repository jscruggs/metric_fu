require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe RcovGrapher do 
  before :each do
    @rcov_grapher = MetricFu::RcovGrapher.new
    MetricFu.configuration
  end
  
  it "should respond to rcov_percent and labels" do
    @rcov_grapher.should respond_to(:rcov_percent)
    @rcov_grapher.should respond_to(:labels)
  end
  
  describe "responding to #initialize" do
    it "should initialise rcov_percent and labels" do
      @rcov_grapher.rcov_percent.should == []
      @rcov_grapher.labels.should == {}
    end
  end
  
  describe "responding to #get_metrics" do
    before(:each) do
      @metrics = YAML::load(File.open(File.join(File.dirname(__FILE__), "..", "resources", "yml", "20090630.yml")))
      @date = "01022003"
    end
    
    it "should push 49.6 to rcov_percent" do
      @rcov_grapher.rcov_percent.should_receive(:push).with(49.6)      
      @rcov_grapher.get_metrics(@metrics, @date)
    end
    
    it "should update labels with the date" do
      @rcov_grapher.labels.should_receive(:update).with({ 0 => "01022003" })
      @rcov_grapher.get_metrics(@metrics, @date)
    end
  end
  
  describe "responding to #graph!" do
    it "should write rcov.png" do
      @rcov_grapher.graph!
      lambda{ File.open(File.join(MetricFu.output_directory, 'rcov.png')) }.should_not raise_error
    end
  end
end
