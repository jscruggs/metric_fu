require 'spec_helper'

describe MetricFu::Metric do
  before do
    @metric = MetricFu::Metric.get_metric(:flog)
    @original_options = @metric.run_options.dup
  end

  it 'can have its run_options over-written' do
    new_options = {:foo => 'bar'}
    @metric.run_options = new_options
    expect(@original_options).to_not eq(new_options)
    expect(@metric.run_options).to eq(new_options)
  end

  it 'can have its run_options modified' do
    new_options = {:foo => 'bar'}
    @metric.run_options.merge!(new_options)
    expect(@metric.run_options).to eq(@original_options.merge(new_options))
  end

  after do
    @metric.run_options = @original_options
  end
end
