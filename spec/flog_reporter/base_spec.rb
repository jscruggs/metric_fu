require 'spec'
require File.dirname(__FILE__) + '/../../lib/metric_fu/flog_reporter'
include MetricFu::FlogReporter

describe "FlogReporter::Base" do
  before do
    @alpha_only_method = <<-AOM
    Total score = 13.6283678106927

    ErrorMailer#errormail: (12.5)
        12.0: assignment
         1.2: []
         1.2: now
         1.2: content_type
AOM

    @method_that_has_digits = <<-MTHD
    Total score = 7.08378429936994

    NoImmunizationReason#to_c32: (7.1)
         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
MTHD

    @bang_method = <<-BM
    Total score = 7.08378429936994

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
