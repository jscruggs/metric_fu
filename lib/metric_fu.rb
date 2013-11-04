require 'metric_fu/version'
require 'forwardable'
require 'pathname'
module MetricFu
  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
  LIB_ROOT = File.join(APP_ROOT,'lib/metric_fu')

  module_function

  def run_dir
    @run_dir ||= Dir.pwd
  end

  def run_path
    Pathname(run_dir)
  end

  def run_dir=(run_dir)
    @run_dir = run_dir
  end

  def root_dir
    APP_ROOT
  end
  def lib_dir
    LIB_ROOT
  end

  require 'metric_fu/loader'
  LOADER = MetricFu::Loader.new(LIB_ROOT)
  def loader
    LOADER
  end
  extend SingleForwardable

  def_delegators :loader, :lib_require, :load_tasks

  def library_dirs
    %w(metrics formatter reporting logging errors data_structures tasks)
  end

  loader.create_dirs(self) do
    library_dirs
  end

  # @note artifact_dir is relative to where the task is being run,
  #   not to the metric_fu library
  require 'metric_fu/io'
  def artifact_dir
    MetricFu::Io::FileSystem.artifact_dir
  end

  def artifact_subdirs
    %w(scratch output _data)
  end

  loader.create_artifact_subdirs(self) do
    artifact_subdirs
  end

  loader.setup

  def reset
    # TODO Don't like how this method needs to know
    # all of these class variables that are defined
    # in separate classes.
    @configuration = nil
    @graph = nil
    @result = nil
  end

  def run(options)
    MetricFu::Run.new.run(options)
  end
  def run_only(metrics_to_run_names, options)
    metrics_to_run_names = Array(metrics_to_run_names).map(&:to_s)
    MetricFu::Configuration.run do |config|
      config.configure_metrics.each do |metric|
        metric_name = metric.name.to_s
        if metrics_to_run_names.include?(metric_name)
          p "Enabling #{metric_name}"
          metric.enabled = true
        else
          p "Disabling #{metric_name}"
          metric.enabled = false
        end
      end
    end
    run(options)
  end
end
