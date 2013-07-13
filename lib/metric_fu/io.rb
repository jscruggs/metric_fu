module MetricFu
  module Io
      def file_for(path)
        return nil if path.nil?
        return path if path.respond_to?(:write)
        file = File.open(path, "w")
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
        pathname = Pathname.new(MetricFu.base_directory) # make it relative to base directory
        pathname = pathname.join(path)
        FileUtils.mkdir_p(pathname) unless File.directory?(pathname)
        pathname
      end
  end
end
