require "spec_helper"
require 'fakefs/spec_helpers'

describe MetricFu::Formatter::HTML do
  include FakeFS::SpecHelpers

  before do
    setup_fs
  end

  context "In general" do

    before do
      MetricFu.result.add(:cane)
      MetricFu.result.add(:hotspots)
    end

    it "creates a report yaml file" do
      # For backward compatibility.
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("tmp/metric_fu/report.yml")
    end

    it "creates a data yaml file" do
      # For use with graphs.
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("tmp/metric_fu/_data/*.yml")
    end

    it "creates a report index html file" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("tmp/metric_fu/output/index.html")
    end

    it "creates templatized html files for each metric" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_files([
        "tmp/metric_fu/output/cane.html",
        "tmp/metric_fu/output/hotspots.html"
      ])
    end

    it "copies common javascripts to the output directory" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("tmp/metric_fu/output/bluff*.js")
    end

    it "creates graphs for appropriate metrics" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_files([
        "tmp/metric_fu/output/cane.js",
      ])
    end

    it "can open the results in the browser" do
      formatter = MetricFu::Formatter::HTML.new
      formatter.should_receive(:system).with("open #{Pathname.pwd.join('tmp/metric_fu/output/index.html')}")
      formatter.finish
      formatter.display_results
    end

    after do
      FakeFS::FileSystem.clear
    end

  end

  context "given a custom output directory" do

    before do
      MetricFu.result.add(:cane)
      MetricFu.result.add(:hotspots)
      @output = 'customdir'
    end

    it "creates the report index html file in the custom output directory" do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file("tmp/metric_fu/#{@output}/index.html")
    end

    it "creates templatized html files for each metric in the custom output directory" do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_files([
        "tmp/metric_fu/#{@output}/cane.html",
        "tmp/metric_fu/#{@output}/hotspots.html"
      ])
    end

    it "copies common javascripts to the custom output directory" do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file("tmp/metric_fu/#{@output}/bluff*.js")
    end

    it "creates graphs for appropriate metrics in the custom output directory " do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file(
        "tmp/metric_fu/#{@output}/cane.js",
      )
    end

    it "can open the results in the browser from the custom output directory" do
      formatter = MetricFu::Formatter::HTML.new(output: @output)
      path = Pathname.pwd.join("tmp/metric_fu/#{@output}/index.html")
      formatter.should_receive(:system).with("open #{path}")
      formatter.finish
      formatter.display_results
    end

    after do
      FakeFS::FileSystem.clear
    end

  end

end
