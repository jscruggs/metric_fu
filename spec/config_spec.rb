require File.dirname(__FILE__) + '/spec_helper.rb'

describe MetricFu::Configuration do
  before do
    MetricFu.configuration.reset
  end
  describe "open_in_browser" do
    it "should be configurable" do
      MetricFu.open_in_browser?.should == !!PLATFORM['darwin']
      MetricFu::Configuration.run do |config|
        config.open_in_browser = false
      end
      MetricFu.configuration.open_in_browser.should == false
      MetricFu.open_in_browser?.should == false
    end
  end

  describe "metrics" do
    it "should be configurable" do
      MetricFu.metrics.should == [:coverage, :churn, :flog, :flay, :saikuro]
      MetricFu::Configuration.run do |config|
        config.metrics = [:coverage, :flog]
      end
      MetricFu.metrics.should == [:coverage, :flog]
    end
  end  
  
  describe "churn_options" do
    it "should be configurable" do
      now = Time.now
      MetricFu.churn_options.should == {}
      MetricFu::Configuration.run do |config|
        config.churn_options[:start_date] = now
      end
      MetricFu.churn_options.should == {:start_date => now }
    end
  end
  
  describe "coverage_options" do
    it "should be configurable" do
      MetricFu.coverage_options[:test_files].should == ['test/**/*_test.rb', 'spec/**/*_spec.rb']
      MetricFu::Configuration.run do |config|
        config.coverage_options[:test_files] = ['test/**/test_*.rb']
      end
      MetricFu.coverage_options[:test_files].should == ['test/**/test_*.rb']
    end
  end

  describe "flay_options" do
    it "should be configurable" do
      now = Time.now
      MetricFu.flay_options.should == { :dirs_to_flay =>  ['lib'] }
      MetricFu::Configuration.run do |config|
        config.flay_options[:dirs_to_flay] =  ['cms/app', 'cms/lib']
      end
      MetricFu.flay_options.should == { :dirs_to_flay =>  ['cms/app', 'cms/lib'] }
    end
  end

  describe "flog_options" do
    it "should be configurable" do
      now = Time.now
      MetricFu.flog_options.should == { :dirs_to_flog =>  ['lib'] }
      MetricFu::Configuration.run do |config|
        config.flog_options[:dirs_to_flog] =  ['cms/app', 'cms/lib']
      end
      MetricFu.flog_options.should == { :dirs_to_flog =>  ['cms/app', 'cms/lib'] }
    end
  end

  describe "saikuro_options" do
    it "should be configurable" do
      MetricFu.saikuro_options.should == {}
      MetricFu::Configuration.run do |config|
        config.saikuro_options = { "--warn_cyclo" => "3", "--error_cyclo" => "4" }
      end
      MetricFu.saikuro_options.should == { "--warn_cyclo" => "3", "--error_cyclo" => "4" }
    end
    
    it "should only accept a Hash" do
      MetricFu.saikuro_options.should == {}
      lambda {
        MetricFu::Configuration.run do |config|
          config.saikuro_options = ''
        end
      }.should raise_error
    end    
  end    
end