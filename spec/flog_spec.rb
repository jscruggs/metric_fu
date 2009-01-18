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
      generator.should_receive(:save_html).at_least(3).times.and_return('')
      generator.should_receive(:open).any_number_of_times.and_return(['Total Flog = 1273.9 (9.3 +/- 259.2 flog / method)', 'TokenCounter#list_tokens_per_line: (15.2)', '9.0: assignment'].join("\n"))
      generator.generate_report
    end
    
    it "should be able to handle InvalidFlogs" do
      generator = Flog::Generator.new('other_dir')
      generator.should_receive(:flog_results).and_return(['A', 'B'])
      generator.should_receive(:inline_css).any_number_of_times.and_return('')
      generator.should_receive(:save_html).once
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