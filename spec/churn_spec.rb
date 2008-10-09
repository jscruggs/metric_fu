require 'spec'
require File.dirname(__FILE__) + '/../lib/metric_fu/churn'
include MetricFu

describe MetricFu::Churn do
  describe "generate_report" do
    after do
      load File.dirname(__FILE__) + '/../lib/metric_fu/churn.rb' #need to reload file to wipe out mock of private static
    end
    
    it "should strip out files that have less than the min count" do
      Churn.should_receive(:churn_options).and_return(["", 5, :git])
      Churn.should_receive(:parse_log_for_changes).with(:git, "").and_return({"reject" => 4, "accept" => 5})
      Churn.should_receive(:write_churn_file).with({"accept" => 5}, "output_dir")
      Churn.generate_report("output_dir", {})
    end
  end
  
  describe "parse_log_for_changes" do
    it "should count the changes with git" do
      logs = ["home_page/index.html", "README", "History.txt", "README", "History.txt", "README"]
      Churn.should_receive(:get_logs).with(:git, "").and_return(logs)
      changes = Churn.send(:parse_log_for_changes, :git, "")
      
      changes["home_page/index.html"].should == 1
      changes["History.txt"].should == 2
      changes["README"].should == 3
    end
    
    it "should count the changes with svn" do
      logs = ["home_page/index.html", "README", "History.txt", "README", "History.txt", "README"]
      Churn.should_receive(:get_logs).with(:svn, "").and_return(logs)
      changes = Churn.send(:parse_log_for_changes, :svn, "")
      
      changes["home_page/index.html"].should == 1
      changes["History.txt"].should == 2
      changes["README"].should == 3
    end    
  end
  
  describe "clean_up_svn_line" do
    it "should return nil for non matches" do
      Churn.send(:clean_up_svn_line, "Adding Google analytics").should be_nil
      Churn.send(:clean_up_svn_line, "A bunch of new files").should be_nil
    end
      
    it "should strip out all but the full path" do
      Churn.send(:clean_up_svn_line, "   A /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "A   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "   A   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "   A /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "A /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "A   /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
      
      Churn.send(:clean_up_svn_line, "   M /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "M   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "   M   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "   M /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "M /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
      Churn.send(:clean_up_svn_line, "M   /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
    end
  end
end
