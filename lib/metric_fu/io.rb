module MetricFu
  module Io
      def file_for(path)
        return nil if path.nil?
        return path if path.respond_to?(:write)
        file = File.open(path_relative_to_base(path), "w")
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
        pathname = Pathname.new(MetricFu.base_directory) # make it relative to base directory
        pathname.join(path)
      end
  end
end
