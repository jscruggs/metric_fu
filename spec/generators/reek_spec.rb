require File.dirname(__FILE__) + '/../spec_helper'

describe Reek do
  describe "analyze method" do
    before :each do
      @lines = <<-HERE
"app/controllers/activity_reports_controller.rb" -- 4 warnings:
ActivityReportsController#authorize_user calls current_user.primary_site_ids multiple times (Duplication)
ActivityReportsController#authorize_user calls params[id] multiple times (Duplication)
ActivityReportsController#authorize_user calls params[primary_site_id] multiple times (Duplication)
ActivityReportsController#authorize_user has approx 6 statements (Long Method)

"app/controllers/application.rb" -- 1 warnings:
ApplicationController#start_background_task/block/block is nested (Nested Iterators)

"app/controllers/link_targets_controller.rb" -- 1 warnings:
LinkTargetsController#authorize_user calls current_user.role multiple times (Duplication)
      HERE
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      reek = MetricFu::Reek.new
      reek.instance_variable_set(:@output, @lines)
      @matches = reek.analyze
    end
      
    it "should find the code smell's method name" do
      first_smell = @matches.first[:code_smells].first
      first_smell[:method].should == "ActivityReportsController#authorize_user"
    end
    
    it "should find the code smell's type" do
      first_smell = @matches[1][:code_smells].first
      first_smell[:type].should == "Nested Iterators"
    end
    
    it "should find the code smell's message" do
      first_smell = @matches[1][:code_smells].first
      first_smell[:message].should == "is nested"
    end
    
    it "should find the code smell's type" do
      first_smell = @matches.first
      first_smell[:file_path].should == "app/controllers/activity_reports_controller.rb"
    end
  end
  
end
