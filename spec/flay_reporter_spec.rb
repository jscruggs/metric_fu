require File.dirname(__FILE__) + '/spec_helper.rb'

describe MetricFu::FlayReporter do

  describe "generate_html" do
    it "should create a new Generator and call generate_report on it" do
      @generator = MetricFu::FlayReporter.new('other_dir')
      @generator.should_receive(:`).and_return("Matches found in :call (mass = 55)\n\tlib/metric_fu/flog_reporter.rb:2\n\tlib/metric_fu/flog_reporter.rb:3")
      @generator.generate_html
    end
  end
end