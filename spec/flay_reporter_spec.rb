require File.dirname(__FILE__) + '/spec_helper.rb'

describe MetricFu::FlayReporter::Generator do

  describe "generate_html" do
    it "should create a new Generator and call generate_report on it" do
      # lines = mock(:lines)
      # lines.should_receive(:each_line)
      # File.should_receive(:open).with("other_dir/result.txt", "r").and_return(lines)
      @generator = MetricFu::FlayReporter::Generator.new('other_dir')
      @generator.should_receive(:`).and_return("Matches found in :call (mass = 55)\n\tlib/metric_fu/flog_reporter.rb:2\n\tlib/metric_fu/flog_reporter.rb:3")
      @generator.generate_html
    end
  end
end