require File.dirname(__FILE__) + '/spec_helper.rb'

# REEK_RESULT = %("lib/metric_fu/base.rb" -- 5 warnings:
# [Utility Function] #configuration doesn't depend on instance state
# [Utility Function] #open_in_browser? doesn't depend on instance state
# [Long Method] Configuration#reset has approx 6 statements
# [Utility Function] Generator#cycle doesn't depend on instance state
# [Utility Function] Generator#link_to_filename doesn't depend on instance state)
# 
describe Reek do

  # describe "generate_output" do
  #   it "should create a new Generator and call generate_report on it" do
  #     @generator = MetricFu::Reek.new('other_dir')
  #     @generator.should_receive(:`).and_return(REEK_RESULT)
  #     @generator.generate_output
  #   end
  # end
  # 
  # describe "template_name" do
  #   it "should return the class name in lowercase" do
  #     flay = MetricFu::Reek.new('base_dir')      
  #     flay.template_name.should == 'reek'
  #   end
  # end  
end
