require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe MetricFu::FlogGrapher do
  before :each do
    @flog_grapher = MetricFu::FlogGrapher.new
    MetricFu.configuration
  end
  
  it "should respond to flog_total, flog_average and labels" do
    @flog_grapher.should respond_to(:flog_average)
    @flog_grapher.should respond_to(:labels)
    @flog_grapher.should respond_to(:top_five_percent_average)
  end
  
  describe "responding to #initialize" do
    it "should initialize top_five_percent_average, flog_average and labels" do
      @flog_grapher.flog_average.should == []
      @flog_grapher.labels.should == {}
      @flog_grapher.top_five_percent_average.should == []
    end
  end
  
  describe "responding to #get_metrics" do
    before(:each) do
      @metrics = YAML::load(File.open(File.join(File.dirname(__FILE__), "..", "resources", "yml", "20090630.yml")))
      @date = "01022003"
    end
    
    it "should push to top_five_percent_average" do
      average = (73.6 + 68.5 + 66.1 + 46.6 + 44.8 + 44.1 + 41.2 + 36.0) / 8.0
      @flog_grapher.top_five_percent_average.should_receive(:push).with(average)      
      @flog_grapher.get_metrics(@metrics, @date)
    end
    
    it "should push 9.9 to flog_average" do
      @flog_grapher.flog_average.should_receive(:push).with(9.9)
      @flog_grapher.get_metrics(@metrics, @date)
    end
    
    it "should update labels with the date" do
      @flog_grapher.labels.should_receive(:update).with({ 0 => "01022003" })
      @flog_grapher.get_metrics(@metrics, @date)
    end
  end
  
  describe "responding to #graph!" do
    it "should write flog.png" do
      @flog_grapher.graph!
      lambda{ File.open(File.join(MetricFu.output_directory, 'flog.png')) }.should_not raise_error
    end
  
    it "should not fall over when given empty results" do    
      gruff_line = Gruff::Line.new(MetricFu.graph_size)
      gruff_line.stub!(:write)
      Gruff::Line.stub!(:new).and_return(gruff_line)
      metrics_hash = { :flog => {:average => 0, :pages => [], :total => 0} }
      @flog_grapher.get_metrics(metrics_hash ,"20090629")
      @flog_grapher.graph!
    end
  end  
end
