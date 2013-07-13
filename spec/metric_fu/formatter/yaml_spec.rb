require "spec_helper"

describe MetricFu::Formatter::YAML do

  before(:all) do
    FileUtils.rm_rf("#{MetricFu.base_directory}/report.yml")
  end

  context "In general" do

    before do
      MetricFu.result.add(:cane)
      MetricFu.result.add(:hotspots)
    end

    it "creates a report yaml file" do
      expect {
      MetricFu::Formatter::YAML.new.finish
      }.to create_file("tmp/metric_fu/report.yml")
    end

    after do
      # TODO: Use fakefs
      FileUtils.rm_rf("#{MetricFu.base_directory}/report.yml")
    end

  end

  context "given a custom output file" do

    before do
      MetricFu.result.add(:cane)
      MetricFu.result.add(:hotspots)
      @output = "tmp/metric_fu/customreport.yml"
    end

    it "creates a report yaml file to the custom output path" do
      expect {
      MetricFu::Formatter::YAML.new(output: @output).finish
      }.to create_file("tmp/metric_fu/customreport.yml")
    end

    after do
      FileUtils.rm_rf("#{MetricFu.base_directory}/customreport.yml")
    end

  end

  context "given a custom output stream" do

    before do
      MetricFu.result.add(:cane)
      MetricFu.result.add(:hotspots)
      @output = $stdout
    end

    it "creates a report yaml in the custom stream" do
      out = MfDebugger::Logger.capture_output {
        MetricFu::Formatter::YAML.new(output: @output).finish
      }
      out.should include ':cane:'
      out.should include ':hotspots:'
    end

  end

end
