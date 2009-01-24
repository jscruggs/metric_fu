require File.dirname(__FILE__) + '/spec_helper.rb'
include MetricFu::Flog

describe "Flog::Base" do
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

    @invalid_method = <<-IM
    Total flog = 7.08378429936994

         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
IM

    @assignment_method = <<-MTHD
    Total Flog = 21.6 (5.4 +/- 3.3 flog / method)

    ActivityReport#existing_measure_attributes=: (8.5)
         4.1: assignment
         1.8: id
         1.6: to_s
         1.4: []
         1.4: activity_report_measures
         1.2: each
         1.2: branch
    MTHD

    @class_methods_grouped_together = <<-MTHD
    Total Flog = 61.8 (7.7 +/- 95.3 flog / method)

    User#none: (32.8)
         7.2: include
         3.6: validates_length_of
         3.6: validates_format_of
         2.4: validates_presence_of
         2.4: validates_uniqueness_of
         1.4: bad_login_message
         1.4: name_regex
         1.4: bad_email_message
         1.4: bad_name_message
         1.4: login_regex
         1.4: email_regex
         1.2: private
         1.2: has_and_belongs_to_many
         1.2: before_create
         1.2: attr_accessible
         0.4: lit_fixnum
    MTHD
  end
  
  it "should be able to parse class_methods_grouped_together" do
    page = Base.parse(@class_methods_grouped_together)
    page.should_not be_nil
    page.score.should == 61.8
    page.scanned_methods.size.should == 1
    sm = page.scanned_methods.first
    sm.name.should == 'User#none'
    sm.score.should == 32.8
    
    sm.operators.size.should == 16
    sm.operators.first.score.should == 7.2
    sm.operators.first.operator.should == "include"
    
    sm.operators.last.score.should == 0.4
    sm.operators.last.operator.should == "lit_fixnum"
  end
  
  it "should be able to parse an assignment method" do
    page = Base.parse(@assignment_method)
    page.should_not be_nil
    page.score.should == 21.6
    page.scanned_methods.size.should == 1
    sm = page.scanned_methods.first
    sm.name.should == 'ActivityReport#existing_measure_attributes='
    sm.score.should == 8.5
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
  
  it "should return nil when parsing invalid method" do
    page = Base.parse(@invalid_method)
    page.should be_nil
  end  
end

IM = <<-IM
    Total flog = 7.08378429936994

         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
IM
describe MetricFu::Flog do

  describe "generate_report" do
    it "should generate reports" do
      generator = Flog::Generator.new('other_dir')
      generator.should_receive(:flog_results).and_return(['A', 'B'])
      generator.should_receive(:save_output).at_least(3).times.and_return('')
      generator.should_receive(:open).any_number_of_times.and_return(['Total Flog = 1273.9 (9.3 +/- 259.2 flog / method)', 'TokenCounter#list_tokens_per_line: (15.2)', '9.0: assignment'].join("\n"))
      generator.generate_report
    end
    
    it "should be able to handle InvalidFlogs" do
      generator = Flog::Generator.new('other_dir')
      generator.should_receive(:flog_results).and_return(['A', 'B'])
      generator.should_receive(:inline_css).any_number_of_times.and_return('')
      generator.should_receive(:save_output).once
      generator.should_receive(:open).any_number_of_times.and_return(IM)      
      generator.generate_report
    end      
  end
  
  describe "template_name" do
    it "should return the class name in lowercase" do
      flog = Flog::Generator.new('base_dir')      
      Flog::Generator.template_name.should == 'flog'
    end
  end  
end

describe MetricFu::Flog::Page do

  describe "average_score" do
    it "should calculate the average score" do
      page = Page.new(10)
      page.should_receive(:scanned_methods).any_number_of_times.and_return([ScannedMethod.new(:test, 10), ScannedMethod.new(:test, 20)])      
      page.average_score.should == 15
    end
    
    it "should be able to handle divide by zero" do
      page = Page.new(10)
      page.should_receive(:scanned_methods).any_number_of_times.and_return([])
      page.average_score.should == 0
    end    
  end
  
  describe "highest_score" do
    it "should calculate the average score" do
      page = Page.new(10)
      page.should_receive(:scanned_methods).any_number_of_times.and_return([ScannedMethod.new(:test, 10), ScannedMethod.new(:test, 20)])
      page.highest_score.should == 20
    end   
  end  
end
