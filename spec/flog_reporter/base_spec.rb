require File.dirname(__FILE__) + '/../spec_helper.rb'
include MetricFu::FlogReporter

describe "FlogReporter::Base" do
  before do
    @alpha_only_method = <<-AOM
    Total flog = 13.6283678106927

    ErrorMailer#errormail: (12.5)
        12.0: assignment
         1.2: []
         1.2: now
         1.2: content_type
AOM

    @method_that_has_digits = <<-MTHD
    Total flog = 7.08378429936994

    NoImmunizationReason#to_c32: (7.1)
         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
MTHD

    @bang_method = <<-BM
    Total flog = 7.08378429936994

    NoImmunizationReason#to_c32!: (7.1)
         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
BM
  end

  it "should be able to parse an alpha only method" do
    page = Base.parse(@alpha_only_method)
    page.should_not be_nil
    page.score.should == 13.6283678106927
    page.scanned_methods.size.should == 1
    sm = page.scanned_methods.first
    sm.name.should == 'ErrorMailer#errormail'
    sm.score.should == 12.5
  end

  it "should be able to parse method that has digits" do
    page = Base.parse(@method_that_has_digits)
    page.should_not be_nil
    page.score.should == 7.08378429936994
    page.scanned_methods.size.should == 1
    sm = page.scanned_methods.first
    sm.name.should == 'NoImmunizationReason#to_c32'
    sm.score.should == 7.1
  end

  it "should be able to parse bang method" do
    page = Base.parse(@bang_method)
    page.should_not be_nil
    page.score.should == 7.08378429936994
    page.scanned_methods.size.should == 1
    sm = page.scanned_methods.first
    sm.name.should == 'NoImmunizationReason#to_c32!'
    sm.score.should == 7.1
  end
end


describe MetricFu::FlogReporter::Page do

  describe "average_score" do
    it "should calculate the average score" do
      page = MetricFu::FlayReporter::Page.new('other_dir')
      page.should_receive(:scanned_methods).any_number_of_times.and_return([ScannedMethod.new(:test, 10), ScannedMethod.new(:test, 20)])
      page.average_score.should == 15
    end
    
    it "should be able to handle divide by zero" do
      page = MetricFu::FlayReporter::Page.new('other_dir')
      page.should_receive(:scanned_methods).any_number_of_times.and_return([])
      page.average_score.should == 0
    end    
  end
end