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

  loader.create_dirs(self) do
    %w(metrics formatter reporting logging errors data_structures tasks)
  end

  # @note artifact_dir is relative to where the task is being run,
  #   not to the metric_fu library
  require 'metric_fu/io'
  def artifact_dir
    MetricFu::Io::FileSystem.artifact_dir
  end

  loader.create_artifact_subdirs(self) do
    %w(scratch output _data)
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
end
