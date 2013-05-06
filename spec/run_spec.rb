require 'spec_helper'
require 'metric_fu/cli/helper'

describe MetricFu, "running" do

  let(:helper)  { MetricFu::Cli::Helper.new }

  it "all these tests should not rely on shelling out to the command line" do
    pending("shelling to bundler is very slow")
  end

  xit "loads the .metrics file" do
    out = metric_fu
    out.should include "Metrics config loaded"
  end

  xit "creates a report yaml file" do
    expect { metric_fu }.to create_file("tmp/metric_fu/report.yml")
  end

  xit "creates a report html file" do
    expect { metric_fu }.to create_file("tmp/metric_fu/output/index.html")
  end

  xit "displays help" do
    out = metric_fu("bundle exec metric_fu --help")
    out.should include helper.banner
  end

  xit "displays version" do
    out = metric_fu("bundle exec metric_fu --version")
    out.should == "#{MetricFu::VERSION}"
  end

  xit "errors on unknown flags" do
    expect { metric_fu "--asdasdasda" }.to raise_error
  end

  def metric_fu(command = "--no-open")
    results = `metric_fu #{command} 2>&1`
    $?.to_i.should eq(0), "The command 'metric_fu #{command}' failed!\n\n#{results}"
    results.strip
  end

end
