require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Churn do
  describe "initialize" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
    end
    
    it "should setup git if .git exits" do
      MetricFu::Churn.should_receive(:system).and_return(true)
      Churn::Git.should_receive(:new)
      MetricFu::Churn.new
    end
    
    it "should setup git if .svn exits" do
      MetricFu::Churn.should_receive(:system).and_return(false)
      File.should_receive(:exist?).with(".svn").and_return(true)
      Churn::Svn.should_receive(:new)
      MetricFu::Churn.new()
    end
    
    it "should raise an error if not .svn or .git" do
      MetricFu::Churn.should_receive(:system).and_return(false)
      lambda{MetricFu::Churn.new()}.should raise_error(Exception)
    end
  end
  
  describe "emit method with git" do
    before :each do
      MetricFu::Configuration.run {|config| config.churn = {:minimum_churn_count => 2} }
      File.stub!(:directory?).and_return(true)
      MetricFu::Churn.should_receive(:system).and_return(true)
      @git = Churn::Git.new
      Churn::Git.should_receive(:new).and_return(@git)
      @lines = <<-HERE.gsub(/^\s*/, "")
      
      lib/generators/flog.rb
      spec/generators/flog_spec.rb


      lib/generators/flog.rb
      spec/generators/flay_spec.rb


      lib/metric_fu.rb


      lib/generators/saikuro.rb
      lib/metric_fu.rb
      tasks/metric_fu.rake


      spec/churn_spec.rb
      spec/config_spec.rb
      spec/flay_spec.rb
      spec/flog_spec.rb
      lib/metric_fu.rb
      spec/reek_spec.rb
      HERE
    end
    
    it "should read the logs" do
      churn = MetricFu::Churn.new
      @git.should_receive(:`).with("git log  --name-only --pretty=format:").and_return(@lines)
      changes = churn.emit
      changes["lib/generators/flog.rb"].should == 2
      changes["lib/metric_fu.rb"].should == 3
    end
  end
  
  describe "emit method with svn" do
    before :each do
      MetricFu::Configuration.run{|config| config.churn = {:minimum_churn_count => 2} }
      File.stub!(:directory?).and_return(true)
      MetricFu::Churn.should_receive(:system).and_return(false)
      File.should_receive(:exist?).with(".svn").and_return(true)
      @svn = Churn::Svn.new
      Churn::Svn.should_receive(:new).and_return(@svn)
      @lines = <<-HERE.gsub(/^\s*/, "")
      ------------------------------------------------------------------------
      r3183 | dave | 2009-04-28 07:23:37 -0500 (Tue, 28 Apr 2009) | 1 line
      Changed paths:
         M /trunk/app/views/promotions/index.erb
         M /trunk/app/models/email_personalizer.rb

      making custom macros case-insensitive
      ------------------------------------------------------------------------
      r3182 | marc | 2009-04-28 03:59:32 -0500 (Tue, 28 Apr 2009) | 1 line
      Changed paths:
         M /trunk/app/models/file_extraction.rb
         M /trunk/app/views/promotions/index.erb
         M /trunk/config/environment.rb

      Demo of the drop out effect for uploading promotions.
      ------------------------------------------------------------------------
      r3181 | dave | 2009-04-27 21:40:04 -0500 (Mon, 27 Apr 2009) | 1 line
      Changed paths:
         M /trunk/app/views/promotions/index.erb
         A /trunk/app/models/file_extraction.rb
         A /trunk/app/models/url_file_extraction.rb
         M /trunk/app/models/zip_file_extraction.rb
         M /trunk/test/data/zip_test.zip
         M /trunk/test/unit/zip_file_extraction_test.rb

      URL imports
      HERE
    end
    
    it "should read the logs" do
      churn = MetricFu::Churn.new
      @svn.should_receive(:`).with("svn log  --verbose").and_return(@lines)
      changes = churn.emit
      changes["/trunk/app/views/promotions/index.erb"].should == 3
      changes["/trunk/app/models/file_extraction.rb"].should == 2
    end
  end
  
  describe "analyze method" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      MetricFu::Churn.should_receive(:system).and_return(true)
      @changes = {"lib/generators/flog.rb"=>2, "lib/metric_fu.rb"=>3}
    end
    
    it "should organize and format" do
      churn = MetricFu::Churn.new
      churn.instance_variable_set(:@changes, @changes)
      changes = churn.analyze
      changes.first[:file_path].should == "lib/metric_fu.rb"
      changes.first[:times_changed].should == 3
      changes[1][:file_path].should == "lib/generators/flog.rb"
      changes[1][:times_changed].should == 2
    end
  end
  
  describe "to_h method" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      MetricFu::Churn.should_receive(:system).and_return(true)
    end
    
    it "should put the changes into a hash" do
      churn = MetricFu::Churn.new
      churn.instance_variable_set(:@changes, "churn_info")
      churn.to_h[:churn][:changes].should == "churn_info"
    end
  end
end

