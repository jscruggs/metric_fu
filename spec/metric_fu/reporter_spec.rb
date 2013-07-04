require "spec_helper"

describe MetricFu::Reporter do

  context 'given a single formatter' do
    before do
      @formatter = double('formatter')
      @reporter = Reporter.new(@formatter)
    end

    it 'notifies the formatter' do
      @formatter.should_receive(:start)
      @formatter.should_receive(:finish)
      @reporter.start
      @reporter.finish
    end
  end

  context 'given multiple formatters' do
    before do
      @formatters = [double('formatter'), double('formatter')]
      @reporter = Reporter.new(@formatters)
    end

    it 'notifies all formatters' do
      @formatters.each do |formatter|
        formatter.should_receive(:start)
        formatter.should_receive(:finish)
      end
      @reporter.start
      @reporter.finish
    end
  end
end
