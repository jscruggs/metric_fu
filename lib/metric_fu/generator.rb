require 'erb'
require 'yaml'
module MetricFu

  class Generator
    attr_reader :report, :template

    def initialize(options={})
      create_metric_dir_if_missing
      create_output_dir_if_missing
    end

    def self.class_name
      self.to_s.split('::').last.downcase
    end
    
    def self.metric_directory
      File.join(MetricFu.scratch_directory, class_name) 
    end

    def create_metric_dir_if_missing
      unless File.directory?(metric_directory)
        FileUtils.mkdir_p(metric_directory, :verbose => false) 
      end
    end
    
    def create_output_dir_if_missing
      unless File.directory?(MetricFu.output_directory)
        FileUtils.mkdir_p(MetricFu.output_directory, :verbose => false) 
      end
    end

    def metric_directory
      self.class.metric_directory
    end

    def self.generate_report(options={})
      generator = self.new(options)
      generator.generate_report
    end

    def generate_report
      analyze
      to_yaml
    end

  end
end
