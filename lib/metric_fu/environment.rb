require 'redcard'
require 'rbconfig'
MetricFu.logging_require { 'mf_debugger' }
module MetricFu
  module Environment

    # TODO: Set log_level here, instead
    def verbose
      MfDebugger::Logger.debug_on
    end

    def verbose=(toggle)
      MfDebugger::Logger.debug_on = toggle
    end

    # Perform a simple check to try and guess if we're running
    # against a rails app.
    #
    # TODO This should probably be made a bit more robust.
    def rails?
      @rails ||= begin
                   exists = File.exist?("config/environment.rb")
                   def MetricFu.rails?
                     exists
                   end
                   exists
                 end
    end

    def is_cruise_control_rb?
      !!ENV['CC_BUILD_ARTIFACTS']
    end

    def jruby?
      @jruby ||= !!RedCard.check(:jruby)
    end

    def mri?
      @mri ||= !!RedCard.check(:ruby)
    end

    def ruby_flavor
      @ruby_flavor ||= RedCard.engine
    end

    def ruby_version
      @ruby_version ||= RedCard.engine_version
    end

    def ruby18?
      @ruby18 ||= mri? && !!RedCard.check('1.8'...'1.9')
    end

    def ruby192?
      @ruby192 ||= mri? && ruby_version == '1.9.2'
    end

    def rubinius?
      @rubinius ||= !!RedCard.check(:rubinius)
    end

    def supports_ripper?
      @supports_ripper ||= begin
                             require 'ripper'
                             true
                           rescue LoadError
                             false
                           end
    end

    def platform #:nodoc:
      return RUBY_PLATFORM
    end

    def version
      MetricFu::VERSION
    end

    def environment_details
      @environment_details ||= {
        'VERBOSE' => $VERBOSE.inspect,
        'External Encoding' => Encoding.default_external.to_s,
        'Internal Encoding' => Encoding.default_internal.to_s,
        'Host Architecture' => RbConfig::CONFIG['build'],
        'Ruby Prefix'       => RbConfig::CONFIG['prefix'],
        'Ruby Options'      => ENV.keys.grep(/RUBYOPT/).map{|key| "#{key}=#{ENV[key]}" }.join(', '),
      }
    end

    # To consider
    # $LOADED_FEATURES
    # $LOAD_PATH
    def ruby_details
      @ruby_details ||= {
        'Engine' => ruby_flavor,
        'Version' => ruby_version,
        'Patchlevel' => (defined?(RUBY_PATCHLEVEL) && RUBY_PATCHLEVEL),
        'Ripper Support' => supports_ripper?,
        'Rubygems Version' => Gem::VERSION,
        'Long Description' => (defined?(RUBY_DESCRIPTION) ? RUBY_DESCRIPTION : platform),
      }
    end

    def library_details
      @library_details ||= {
        'Version' =>  version,
        'Verbose Mode' => verbose,
        'Enabled Metrics' => MetricFu::Metric.enabled_metrics.map(&:name),
        # 'Dependencies' => `gem dependency metric_fu`, # TODO how should we handle this?
      }
    end

    def debug_info
      @debug_info ||= {
        'Ruby' => ruby_details,
        'Environment' => environment_details,
        'MetricFu' => library_details,
      }
    end

    def osx?
      @osx ||= platform.include?('darwin')
    end

    def ruby_strangely_makes_accessors_private?
       ruby192? || jruby?
    end

    # HACK: for using this module via inclusion in Configuration
    def self.included(host_class)
      def host_class.ruby_strangely_makes_accessors_private?
        @private_accessors ||= allocate.ruby_strangely_makes_accessors_private?
      end
    end
  end
end
