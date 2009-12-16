require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
describe Flog do
  before :each do
    @text = <<-HERE
    157.9: flog total
     11.3: flog/method average

     34.8: UsersController#create
      9.2: branch
      6.8: current_user
      5.2: assignment
      3.4: role
      3.0: render
      3.0: ==
      2.8: flash
      1.6: after_create_page
      1.6: params
      1.5: activate!
      1.5: errors
      1.4: login
      1.4: redirect_to
      1.4: []
      1.3: empty?
      1.3: save
      1.2: new
     24.2: UsersController#authorize_user
      4.8: branch
      4.7: current_user
      3.6: params
      3.2: []
      2.6: ==
      1.5: role
      1.5: to_i
      1.5: id
      1.4: new_session_path
      1.3: include?
      1.2: assignment
      1.2: flash
      1.2: redirect_to
     16.4: UsersController#thank_you
      4.0: assignment
      3.3: params
      2.9: []
      2.7: redirect_to
      2.4: branch
      1.5: new_session_path
      1.4: flash
      1.4: activate!
      1.3: can_activate?
      1.2: find_by_id
     14.2: UsersController#update
      3.2: params
      2.8: []
      2.6: assignment
      1.4: login
      1.4: flash
      1.4: redirect_to
      1.3: render
      1.2: branch
      1.2: update_attributes
      1.2: find_by_id
     12.5: UsersController#sanitize_params
      3.9: assignment
      3.6: branch
      3.0: current_user
      1.6: params
      1.5: role
      1.4: []
      1.3: include?
      1.3: ==
      1.2: reject!
     10.6: UsersController#users_have_changed
      3.9: assignment
      2.6: branch
      1.6: params
      1.5: refresh_from_external
      1.4: find_by_id
      1.4: []
      1.2: split
      1.2: each
      1.2: head
     10.0: UsersController#after_create_page
      3.0: current_user
      2.6: id
      2.4: branch
      1.5: role
      1.3: login
      1.3: ==
      8.4: UsersController#add_primary_site
      2.4: assignment
      1.6: params
      1.4: []
      1.4: new
      1.2: find_by_id
      1.2: all
      1.2: render
      7.7: UsersController#none
      3.3: before_filter
      1.1: private
      1.1: caches_page
      1.1: after_filter
      1.1: skip_before_filter
      7.2: UsersController#destroy
      1.8: params
      1.6: []
      1.4: find_by_id
      1.2: destroy
      1.2: redirect_to
      5.9: UsersController#edit
      2.4: assignment
      1.6: params
      1.4: []
      1.2: all
      1.2: find_by_id
      2.7: UsersController#signup
      1.2: render
      1.2: assignment
      1.2: new
      1.7: UsersController#new
      1.2: assignment
      1.2: new
      1.7: UsersController#index
      1.2: assignment
      1.2: all
    HERE
    MetricFu::Flog.stub!(:verify_dependencies!).and_return(true)
  end
  
  describe "parse method" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      flog = MetricFu::Flog.new('base_dir')
      @flog_page = flog.parse(@text)
    end
    
    it "should find the total score" do
      @flog_page.score.should == 157.9
    end
    
    it "should find the average score" do
      @flog_page.average_score.should == 11.3
    end
    
    it "should find the scanned method score" do
      @flog_page.scanned_methods.first.score.should == 34.8
    end
    
    it "should find the scanned method name" do
      @flog_page.scanned_methods.first.name.should == "UsersController#create"
    end
    
    it "should find the scanned method opperators names" do
      @flog_page.scanned_methods.first.operators.first.operator.should == "branch"
    end
    
    it "should find the scanned method opperators scores" do
      @flog_page.scanned_methods.first.operators.first.score.should == 9.2
    end
    
    it "should find the name of the method even if namespaced" do
      text = <<-HERE
      157.9: flog total
       11.3: flog/method average

       34.8: SomeNamespace::UsersController#create
      HERE
        flog = MetricFu::Flog.new('base_dir')
        flog_page = flog.parse(text)
        flog_page.scanned_methods.first.name.should == "SomeNamespace::UsersController#create"
    end

    it "should parse empty flog files" do
      text = ""
      flog = MetricFu::Flog.new('base_dir')
      flog_page = flog.parse(text)
      flog_page.should be_nil
    end
  end
  
  describe "to_h function with results" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      flog = MetricFu::Flog.new('base_dir')
      flog.should_receive(:open).and_return(@text)
      flog.stub!(:is_file_current?).and_return(true)
      Dir.should_receive(:glob).and_return(["tmp/metric_fu/scratch/flog/app/controllers/user_controller.txt"])
      flog.analyze
      @flog_hash = flog.to_h
    end
    
    it "should put the total in the hash" do
      @flog_hash[:flog][:total].should == 157.9
    end
    
    it "should put the average in the hash" do
      @flog_hash[:flog][:average].should == 11.3
    end
    
    it "should put pages into the hash" do
      @flog_hash[:flog][:pages].first[:scanned_methods].first[:score].should == 34.8
    end
    
    it "should put the filename into the hash" do
      @flog_hash[:flog][:pages].first[:path].should == "/app/controllers/user_controller.rb"
    end
  end
  
  describe "to_h function ignore files not current" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      flog = MetricFu::Flog.new('base_dir')
      flog.should_receive(:open).and_return(@text)
      flog.stub!(:is_file_current?).and_return(false)
      Dir.should_receive(:glob).and_return(["tmp/metric_fu/scratch/flog/app/controllers/user_controller.txt"])
      flog.analyze
      @flog_hash = flog.to_h
    end
    
    it "should put the total in the hash" do
      @flog_hash.should == {:flog=>{:total=>0, :pages=>[], :average=>0}}
    end
  
  end
  
  describe "to_h function with zero total" do
    it "should not blow up" do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      flog = MetricFu::Flog.new('base_dir')
      flog.should_receive(:open).and_return("") # some sort of empty or unparsable file
      Dir.should_receive(:glob).and_return(["empty_file.txt"])
      flog.analyze
    end
  end
end
