require 'spec'

require File.dirname(__FILE__) + '/../lib/metric_fu/base'
require File.dirname(__FILE__) + '/../lib/metric_fu/flay_reporter'

include MetricFu

describe MetricFu::FlayReporter::Generator do        
  
  describe "generate_html" do
    it "should create a new Generator and call generate_report on it" do
      lines = mock(:lines)
      lines.should_receive(:each_line)
      File.should_receive(:open).with("other_dir/result.txt", "r").and_return(lines)
      @generator = MetricFu::FlayReporter::Generator.new('other_dir')
      @generator.generate_html
    end                  
  end   
end