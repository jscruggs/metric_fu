require File.dirname(__FILE__) + '/spec_helper.rb'

describe Churn do
#   describe "generate_report" do
#     after do
#       load File.dirname(__FILE__) + '/../lib/metric_fu/churn.rb' #need to reload file to wipe out mock of private static
#     end
# 
#     it "should strip out files that have less than the min count" do
#       logs = ["accept", "accept", "accept", "reject", "reject"]
#       git_mock = mock('git')
#       git_mock.should_receive(:get_logs).and_return(logs)
#       Churn::Git.should_receive(:new).and_return(git_mock)
#       churn = Churn.new(:scm => :git, :minimum_churn_count => 3)
#       churn.analyze
#       churn.instance_variable_get(:@changes).should == {"accept"=>3}
#     end
# 
#     it "should have a default min count of 5" do
#       churn = Churn.new('base_dir')
#       churn.instance_variable_get(:@minimum_churn_count).should == 5
#     end
# 
#   end
#   
#   describe "template_name" do
#     it "should return the class name in lowercase" do
#       churn = Churn.new
#       churn.template_name.should == 'churn'
#     end
#   end  
# 
#   describe "parse_log_for_changes" do
#     it "should count the changes with git" do
#       logs = ["home_page/index.html", "README", "History.txt", "README", "History.txt", "README"]
#       git_mock = mock('git')
#       git_mock.should_receive(:get_logs).and_return(logs)
#       Churn::Git.should_receive(:new).and_return(git_mock)
#       File.should_receive(:exist?).with(".git").and_return(true)
#       changes = Churn.new.send(:parse_log_for_changes)
#       changes["home_page/index.html"].should == 1
#       changes["History.txt"].should == 2
#       changes["README"].should == 3
#     end
# 
#     it "should count the changes with svn" do
#       logs = ["home_page/index.html", "README", "History.txt", "README", "History.txt", "README"]
#       svn_mock = mock('svn')
#       svn_mock.should_receive(:get_logs).and_return(logs)
#       Churn::Svn.should_receive(:new).and_return(svn_mock)
#       File.should_receive(:exist?).with(".git").and_return(false)
#       File.should_receive(:exist?).with(".svn").and_return(true)
#       changes = Churn.new.send(:parse_log_for_changes)
#       changes["home_page/index.html"].should == 1
#       changes["History.txt"].should == 2
#       changes["README"].should == 3
#     end
#   end
# end
# 
# describe MetricFu::Churn::Svn do
# 
#   describe "get_logs" do
#     it "should use the start date if supplied" do
#       @churn = Churn::Svn.new
#       @churn.should_receive(:`).with('svn log  --verbose').and_return("")
#       @churn.get_logs
#     end
#     it "should use the start date if supplied" do
#       Time.should_receive(:now).and_return(Date.new(2001, 1, 2))
#       @churn = Churn::Svn.new(lambda{Date.new(2000, 1, 1)})
#       @churn.should_receive(:require_rails_env)
#       @churn.should_receive(:`).with("svn log --revision {2000-01-01}:{2001-01-02} --verbose").and_return("")
#       @churn.get_logs
#     end
#   end
# 
#   describe "clean_up_svn_line" do
#     it "should return nil for non matches" do
#       Churn::Svn.new.send(:clean_up_svn_line, "Adding Google analytics").should be_nil
#       Churn::Svn.new.send(:clean_up_svn_line, "A bunch of new files").should be_nil
#     end
# 
#     it "should strip out all but the full path" do
#       Churn::Svn.new.send(:clean_up_svn_line, "   A /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "A   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "   A   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "   A /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "A /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "A   /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
# 
#       Churn::Svn.new.send(:clean_up_svn_line, "   M /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "M   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "   M   /trunk/lib/server.rb   ").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "   M /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "M /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
#       Churn::Svn.new.send(:clean_up_svn_line, "M   /trunk/lib/server.rb").should == "/trunk/lib/server.rb"
#     end
#   end
# end
# 
# describe MetricFu::Churn::Git do
# 
#   describe "get_logs" do
#     it "should use the start date if supplied" do
#       @churn = Churn::Git.new
#       @churn.should_receive(:`).with('git log  --name-only --pretty=format:').and_return("")
#       @churn.get_logs
#     end
#     it "should use the start date if supplied" do
#       @churn = Churn::Git.new(lambda{Date.new(2000, 1, 1)})
#       @churn.should_receive(:require_rails_env)
#       @churn.should_receive(:`).with("git log --after=2000-01-01 --name-only --pretty=format:").and_return("")
#       @churn.get_logs
#     end
#   end
end
