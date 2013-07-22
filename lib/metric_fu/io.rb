module MetricFu
  module Io
    module FileSystem

      module_function

      def set_directories(config)
        base_directory    = MetricFu.artifact_dir
        scratch_directory = MetricFu.scratch_dir
        output_directory  = MetricFu.output_dir
        data_directory    = MetricFu.data_dir
        root_directory    = MetricFu.root_dir
        config.add_promiscuous_instance_variable(:base_directory,base_directory)
        config.add_promiscuous_instance_variable(:scratch_directory,scratch_directory)
        config.add_promiscuous_instance_variable(:output_directory,output_directory)
        config.add_promiscuous_instance_variable(:data_directory,data_directory)
        # due to behavior differences between ruby 1.8.7 and 1.9.3
        # this is good enough for now
        create_directories [base_directory, scratch_directory, output_directory]

        config.add_promiscuous_instance_variable(:metric_fu_root_directory,root_directory)
        config.add_promiscuous_instance_variable(:template_directory,
                  File.join(root_directory, 'lib', 'templates'))
        config.add_promiscuous_instance_variable(:file_globs_to_ignore,[])
        set_code_dirs(config)
      end

      def create_directories(*dirs)
        Array(*dirs).each do |dir|
          FileUtils.mkdir_p dir
        end
      end

      # Add the 'app' directory if we're running within rails.
      def set_code_dirs(config)
        if config.rails?
          config.add_promiscuous_instance_variable(:code_dirs,['app', 'lib'])
        else
          config.add_promiscuous_instance_variable(:code_dirs,['lib'])
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
      pathname = Pathname.pwd.join(MetricFu.base_directory) # make full path relative to base directory
      pathname.join(path)
    end
  end
end
