module MetricFu
  module Io
    module FileSystem

      def self.artifact_dir
        (ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu')
      end

      module_function

      def directories
        @directories ||= {}
      end

      def directory(name)
        directories.fetch(name) { raise "No such directory configured: #{name}" }
      end
      def file_globs_to_ignore
        @file_globs_to_ignore ||= []
      end

      def set_directories(config)
        @directories = {}
        @directories['base_directory']    = MetricFu.artifact_dir
        @directories['scratch_directory'] = MetricFu.scratch_dir
        @directories['output_directory']  = MetricFu.output_dir
        @directories['data_directory']    = MetricFu.data_dir
        create_directories @directories.values

        @directories['root_directory']    = MetricFu.root_dir
        @directories['template_directory'] = File.join(@directories.fetch('root_directory'), 'lib', 'templates')
        @file_globs_to_ignore = []
        set_code_dirs(config)
      end

      def create_directories(*dirs)
        # due to behavior differences between ruby 1.8.7 and 1.9.3
        # this is good enough for now
        Array(*dirs).each do |dir|
          FileUtils.mkdir_p dir
        end
      end

      # Add the 'app' directory if we're running within rails.
      def set_code_dirs(config)
        if config.rails?
          @directories['code_dirs'] = %w(app lib)
        else
          @directories['code_dirs'] = %w(lib)
        end
      end

    end

    def io_for(path_or_io)
      return nil if path_or_io.nil?
      return path_or_io if path_or_io.respond_to?(:write)

      # Otherwise, we assume its a file path...
      file = File.open(path_relative_to_base(path_or_io), "w")
      at_exit do
        unless file.closed?
          file.flush
          file.close
        end
      end
      file
    end

    def dir_for(path)
      return nil if path.nil?
      pathname = path_relative_to_base(path)
      FileUtils.mkdir_p(pathname) unless File.directory?(pathname)
      pathname
    end

    def path_relative_to_base(path)
      pathname = Pathname.pwd.join(MetricFu::Io::FileSystem.directory('base_directory')) # make full path relative to base directory
      pathname.join(path)
    end
  end
end
