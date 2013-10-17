require 'metric_fu/version'
require 'forwardable'
module MetricFu
  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
  LIB_ROOT = File.join(APP_ROOT,'lib/metric_fu')

  module_function

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

  def run_only(metric_name)
    MetricFu::Configuration.run do |config|
      config.configure_metrics.each do |metric|
        if metric.name.to_s == metric_name.to_s
          p "Enabling #{metric.name}"
          metric.enabled = true
        else
          p "Disabling #{metric.name}"
          metric.enabled = false
        end
      end
    end
    run({})
  end
end
