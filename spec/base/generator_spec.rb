require File.dirname(__FILE__) + "/../spec_helper.rb"

describe MetricFu::Generator do

  MetricFu::Configuration.run do |config|
  end

  class ConcreteClass < MetricFu::Generator
    def emit
    end

    def analyze
    end

    def to_h
    end
  end

  before(:each) do
    @concrete_class = ConcreteClass.new 
  end

  describe "ConcreteClass#class_name" do
    it "should be 'concreteclass'" do
      ConcreteClass.class_name.should == 'concreteclass'
    end
  end

  describe "ConcreteClass#metric_directory" do
    it "should be 'tmp/metric_fu/scratch/concreteclass'" do
      ConcreteClass.metric_directory.
                    should == "tmp/metric_fu/scratch/concreteclass"
    end
  end

  describe "#create_metric_dir_if_missing " do
    describe "when the metric_dir exists " do
      it 'should not call mkdir_p on FileUtils' do
        File.stub!(:directory?).and_return(true)
        FileUtils.should_not_receive(:mkdir_p)
        @concrete_class.create_metric_dir_if_missing
      end
    end

    describe "when the metric_dir does not exist " do
      it 'should call mkdir_p on FileUtils' do
        File.stub!(:directory?).and_return(false)
        FileUtils.should_receive(:mkdir_p)
        @concrete_class.create_metric_dir_if_missing
      end
    end
  end

  describe "#create_output_dir_if_missing" do
    describe "when the output_dir exists " do
      it 'should not call mkdir_p on FileUtils' do
        File.stub!(:directory?).and_return(true)
        FileUtils.should_not_receive(:mkdir_p)
        @concrete_class.create_output_dir_if_missing
      end
    end

    describe "when the output_dir does not exist " do
      it 'should call mkdir_p on FileUtils' do
        File.stub!(:directory?).and_return(false)
        FileUtils.should_receive(:mkdir_p)
        @concrete_class.create_output_dir_if_missing
      end
    end
  end

  describe '#metric_directory' do
    it 'should return the results of ConcreteClass#metric_directory' do
      ConcreteClass.stub!(:metric_directory).and_return('foo')
      @concrete_class.metric_directory.should == 'foo'
    end
  end

  describe 'ConcreteClass#generate_report' do
    it 'should create a new instance of ConcreteClass' do
      ConcreteClass.should_receive(:new).and_return(@concrete_class)
      @concrete_class.should_receive(:generate_report).and_return(true)
      ConcreteClass.generate_report
    end

    it 'should call #generate_report on the new ConcreteClass' do
      ConcreteClass.should_receive(:new).and_return(@concrete_class)
      @concrete_class.should_receive(:generate_report).and_return(true)
      ConcreteClass.generate_report
    end
  end
  
  describe '@concrete_class should have hook methods for '\
           +'[before|after]_[emit|analyze|to_h]' do

    %w[emit analyze to_h].each do |meth|

      it "should respond to #before_#{meth}" do
        @concrete_class.respond_to?("before_#{meth}".to_sym).should be_true
      end

      it "should respond to #after_#{meth}" do
        @concrete_class.respond_to?("after_#{meth}".to_sym).should be_true
      end
    end
  end

  describe "#generate_report" do
    it 'should  raise an error when calling #emit' do
      @abstract_class = MetricFu::Generator.new
      lambda { @abstract_class.generate_report }.should  raise_error
    end

    it 'should call #analyze' do
      @abstract_class = MetricFu::Generator.new
      lambda { @abstract_class.generate_report }.should  raise_error
    end

    it 'should call #to_h' do
      @abstract_class = MetricFu::Generator.new
      lambda { @abstract_class.generate_report }.should  raise_error
    end
  end

  describe "#generate_report (in a concrete class)" do
    
    %w[emit analyze to_h].each do |meth|
      it "should call #before_#{meth}" do
        @concrete_class.should_receive("before_#{meth}")
        @concrete_class.generate_report
      end

      it "should call ##{meth}" do
        @concrete_class.should_receive("#{meth}")
        @concrete_class.generate_report
      end

      it "should call #after_#{meth}" do
        @concrete_class.should_receive("after_#{meth}")
        @concrete_class.generate_report
      end
    end
  end
end
