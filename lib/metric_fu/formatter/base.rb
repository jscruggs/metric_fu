module MetricFu
  module Formatter
    class Base

      def initialize(result, opts={})
        @result = result
        @dir = opts[:dir] || MetricFu.base_directory
        @file = opts[:file] || 'index.html'
      end

      def start
      end

      def finish
      end

      def start_metric(metric)
      end

      def finish_metric(metric)
      end

      def display_results
      end


      protected

      # Saves the passed in content to the passed in directory.  If
      # a filename is passed in it will be used as the name of the
      # file, otherwise it will default to 'index.html'
      #
      # @param content String
      #   A string containing the content (usually html) to be written
      #   to the file.
      #
      # @param dir String
      #   A dir containing the path to the directory to write the file in.
      #
      # @param file String
      #   A filename to save the path as.  Defaults to 'index.html'.
      #
      def save_output(content, file=@file)
        # TODO: Convert formatters to use more generic output streams.
        open("#{@dir}/#{file}", "w") do |f|
          f.puts content
        end
      end

    end
  end
end
