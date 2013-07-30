module MetricFu

  class Stats < Generator

    require 'code_metrics/statistics'
    DIRS = CodeMetrics::StatsDirectories.new.directories
    def self.add_dirs(dirs)
      dirs.each do |type, dir|
        DIRS << [type, dir]
        CodeMetrics::Statistics::TEST_TYPES << type
      end
      DIRS
    end

    # [ 'Acceptance specs', 'spec/acceptance' ]
    def self.spec_dirs
      build_dirs('./spec/**/*_spec.rb', 'spec')
    end

    def self.build_dirs(glob_pattern, suffix)
      dirs = Dir[glob_pattern].
        map { |f| f.sub(/^\.\/(#{suffix}\/\w+)\/.*/, '\\1') }.
        uniq.
        select { |f| File.directory?(f) }

      Hash[dirs.map { |dir|
            type = dir.split('/').last
            type = "#{type[0..0].upcase}#{type[1..-1]} #{suffix}s"
            [type, dir]
            }
          ]
    end

    add_dirs(self.spec_dirs)

    def emit
      @output = MfDebugger::Logger.capture_output do
        CodeMetrics::Statistics.new(*DIRS).to_s
      end
    end

    def analyze
      lines = remove_noise(@output).compact

      @stats = {}

      set_global_stats(lines.pop)
      set_granular_stats(lines)

      @stats
    end

    def to_h
      {:stats => @stats}
    end

    private

    def remove_noise(output)
      lines = output.split("\n")
      lines = lines.find_all {|line| line =~ /^\s*[C|]/ }
      lines.shift
      lines
    end

    def set_global_stats(totals)
      return if totals.nil?
      totals = totals.split("  ").find_all {|el| ! el.empty? }
      @stats[:codeLOC] = totals[0].match(/\d.*/)[0].to_i
      @stats[:testLOC] = totals[1].match(/\d.*/)[0].to_i
      @stats[:code_to_test_ratio] = totals[2].match(/1\:(\d.*)/)[1].to_f
    end

    def set_granular_stats(lines)
      @stats[:lines] = lines.map do |line|
        elements = line.split("|")
        elements.map! {|el| el.strip }
        elements = elements.find_all {|el| ! el.empty? }
        info_line = {}
        info_line[:name] = elements.shift
        elements.map! {|el| el.to_i }
        [:lines, :loc, :classes, :methods,
         :methods_per_class, :loc_per_method].each do |sym|
          info_line[sym] = elements.shift
        end
        info_line
      end
    end

  end
end
