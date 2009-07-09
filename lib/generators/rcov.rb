require 'enumerator'

module MetricFu

  class Rcov < Generator
    NEW_FILE_MARKER =  ("=" * 80) + "\n"

    def self.verify_dependencies!
      `rcov --help`
      unless $?.success?
        if RUBY_PLATFORM =~ /java/
          raise 'running in jruby - rcov tasks not available'
        else
          raise 'sudo gem install rcov # if you want the rcov tasks'
        end
      end
    end

    class Line
      attr_accessor :content, :was_run

      def initialize(content, was_run)
        @content = content
        @was_run = was_run
      end

      def to_h
        {:content => @content, :was_run => @was_run}
      end
    end

    def emit
      begin
        FileUtils.rm_rf(MetricFu::Rcov.metric_directory, :verbose => false)
        Dir.mkdir(MetricFu::Rcov.metric_directory)
        test_files = FileList[*MetricFu.rcov[:test_files]].join(' ')
        rcov_opts = MetricFu.rcov[:rcov_opts].join(' ')
        output = ">> #{MetricFu::Rcov.metric_directory}/rcov.txt"
        `rcov #{test_files} #{rcov_opts} #{output}`
      rescue LoadError
        if RUBY_PLATFORM =~ /java/
          puts 'running in jruby - rcov tasks not available'
        else
          puts 'sudo gem install rcov # if you want the rcov tasks'
        end
      end
    end


    def analyze
      output = File.open(MetricFu::Rcov.metric_directory + '/rcov.txt').read
      output = output.split(NEW_FILE_MARKER)
      # Throw away the first entry - it's the execution time etc.
      output.shift
      files = {}
      output.each_slice(2) {|out| files[out.first.strip] = out.last}
      files.each_pair {|fname, content| files[fname] = content.split("\n") }
      files.each_pair do |fname, content|
        content.map! do |raw_line|
          if raw_line.match(/^!!/)
            line = Line.new(raw_line.gsub('!!', '  '), false).to_h
          else
            line = Line.new(raw_line, true).to_h
          end
        end
        files[fname] = {:lines => content}
      end

      # Calculate the percentage of lines run in each file
      @global_total_lines = 0
      @global_total_lines_run = 0
      files.each_pair do |fname, content|
        lines = content[:lines]
        @global_total_lines_run += lines_run = lines.find_all {|line| line[:was_run] == true }.length
        @global_total_lines += total_lines = lines.length
        percent_run = ((lines_run.to_f / total_lines.to_f) * 100).round
        files[fname][:percent_run] = percent_run 
      end
      @rcov = files
    end

    def to_h
      global_percent_run = ((@global_total_lines_run.to_f / @global_total_lines.to_f) * 100)
      {:rcov => @rcov.merge({:global_percent_run => round_to_tenths(global_percent_run) })}   
    end
  end
end
