require File.dirname(__FILE__) + '/spec_helper.rb'

describe MetricFu::Configuration do
  # before do
  #   MetricFu.configuration.reset
  # end
  # after do
  #   ENV['CC_BUILD_ARTIFACTS'] = nil
  # end
  # describe "open_in_browser" do
  #   it "should return false if running in cruise" do
  #     unless ENV['CC_BUILD_ARTIFACTS']
  #       MetricFu.open_in_browser?.should == !!PLATFORM['darwin']
  #       ENV['CC_BUILD_ARTIFACTS'] = ''
  #       MetricFu.open_in_browser?.should == false
  #     end
  #   end    
  # end

  # describe "metrics" do
  #   it "should be configurable" do
  #     MetricFu.metrics.should == [:coverage, :churn, :flog, :flay, :reek, :roodi, :saikuro]
  #     MetricFu::Configuration.run do |config|
  #       config.metrics = [:coverage, :flog]
  #     end
  #     MetricFu.metrics.should == [:coverage, :flog]
  #   end
  # end  
  # 
  # describe "churn" do
  #   it "should be configurable" do
  #     now = Time.now
  #     MetricFu.churn.should == {}
  #     MetricFu::Configuration.run do |config|
  #       config.churn[:start_date] = now
  #     end
  #     MetricFu.churn.should == {:start_date => now }
  #   end
  # end
  # 
  # describe "coverage" do
  #   it "should be configurable" do
  #     MetricFu.coverage[:test_files].should == ['test/**/*_test.rb', 'spec/**/*_spec.rb']
  #     MetricFu::Configuration.run do |config|
  #       config.coverage[:test_files] = ['test/**/test_*.rb']
  #     end
  #     MetricFu.coverage[:test_files].should == ['test/**/test_*.rb']
  #   end
  # end

  # describe "flay" do
  #   it "should be configurable" do
  #     now = Time.now
  #     MetricFu.flay.should == { :dirs_to_flay =>  ['lib'] }
  #     MetricFu::Configuration.run do |config|
  #       config.flay[:dirs_to_flay] =  ['cms/app', 'cms/lib']
  #     end
  #     MetricFu.flay.should == { :dirs_to_flay =>  ['cms/app', 'cms/lib'] }
  #   end
  # end

  # describe "flog" do
  #   it "should be configurable" do
  #     MetricFu.flog.should == { :dirs_to_flog =>  ['lib'] }
  #     MetricFu::Configuration.run do |config|
  #       config.flog[:dirs_to_flog] =  ['cms/app', 'cms/lib']
  #     end
  #     MetricFu.flog.should == { :dirs_to_flog =>  ['cms/app', 'cms/lib'] }
  #   end
  # end

  # describe "saikuro" do
  #   it "should be configurable" do
  #     MetricFu.saikuro.should == {}
  #     MetricFu::Configuration.run do |config|
  #       config.saikuro = { "--warn_cyclo" => "3", "--error_cyclo" => "4" }
  #     end
  #     MetricFu.saikuro.should == { "--warn_cyclo" => "3", "--error_cyclo" => "4" }
  #   end
  #   
  #   it "should only accept a Hash" do
  #     MetricFu.saikuro.should == {}
  #     lambda {
  #       MetricFu::Configuration.run do |config|
  #         config.saikuro = ''
  #       end
  #     }.should raise_error
  #   end    
  # end
  # 
  # describe "reek" do
  #   it "should be configurable" do
  #     MetricFu.reek.should == { :dirs_to_reek =>  ['lib'] }
  #     MetricFu::Configuration.run do |config|
  #       config.reek[:dirs_to_reek] =  ['cms/app', 'cms/lib']
  #     end
  #     MetricFu.reek.should == { :dirs_to_reek =>  ['cms/app', 'cms/lib'] }
  #   end
  # end
  # 
  # describe "roodi" do
  #   it "should be configurable" do
  #     MetricFu.roodi.should == { :dirs_to_roodi =>  ['lib'] }
  #     MetricFu::Configuration.run do |config|
  #       config.roodi[:dirs_to_roodi] =  ['cms/app', 'cms/lib']
  #     end
  #     MetricFu.roodi.should == { :dirs_to_roodi =>  ['cms/app', 'cms/lib'] }
  #   end
  # end   
end
