module MetricFu


  def self.configuration
    @@configuration ||= Configuration.new
  end

  class Configuration

    def initialize
      warn_about_deprecated_config_options
      reset
      add_attr_accessors_to_self
      add_class_methods_to_metric_fu
    end
   
    def add_class_methods_to_metric_fu
      instance_variables.each do |name|
        method_name = name[1..-1].to_sym
        method = <<-EOF
                  def self.#{method_name}
                    configuration.send(:#{method_name})
                  end
        EOF
        MetricFu.module_eval(method)
      end
    end
   
    def add_attr_accessors_to_self
      instance_variables.each do |name|
        method_name = name[1..-1].to_sym
        MetricFu::Configuration.send(:attr_accessor, method_name)
      end
    end

    def warn_about_deprecated_config_options
      if defined?(::MetricFu::CHURN_OPTIONS)
        raise("Use config.churn instead of MetricFu::CHURN_OPTIONS")
      end
      if defined?(::MetricFu::DIRECTORIES_TO_FLOG)
        raise("Use config.flog[:dirs_to_flog] "+
              "instead of MetricFu::DIRECTORIES_TO_FLOG") 
      end
      if defined?(::MetricFu::SAIKURO_OPTIONS)
        raise("Use config.saikuro instead of MetricFu::SAIKURO_OPTIONS")
      end
      if defined?(SAIKURO_OPTIONS)
        raise("Use config.saikuro instead of SAIKURO_OPTIONS")
      end
    end

    def self.run()  
      yield MetricFu.configuration
    end
    
    def reset
      @base_directory = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu'
      @template_directory =  File.join(File.dirname(__FILE__), '..', 'templates')
      @scratch_directory = File.join(@base_directory, 'scratch')
      @output_directory = File.join(@base_directory, 'output')
      @template_class = StandardTemplate
      @rails = File.exist?("config/environment.rb") 
      @available_metrics =[:churn, :flog,  :flay,
                          :reek, :roodi, :saikuro, :rcov]
      if @rails
        @code_dirs = ['app', 'lib']
        @metrics = @available_metrics + [:stats]
      else
        @code_dirs = ['lib']
        @metrics = @available_metrics
      end
      @flay     = { :dirs_to_flay => @code_dirs  } 
      @flog     = { :dirs_to_flog => @code_dirs  }
      @reek     = { :dirs_to_reek => @code_dirs  }
      @roodi    = { :dirs_to_roodi => @code_dirs }
      @saikuro  = { :output_directory => @scratch_directory + '/saikuro', 
                    :input_directory => @code_dirs,
                    :cyclo => "",
                    :filter_cyclo => "0",
                    :warn_cyclo => "5",
                    :error_cyclo => "7",
                    :formater => "text"}
      @churn    = {}
      @stats    = {}
      @coverage = { :test_files => ['test/**/*_test.rb', 
                                    'spec/**/*_spec.rb'],
                    :rcov_opts => ["--sort coverage", 
                                   "--no-html", 
                                   "--text-coverage",
                                   "--no-color",
                                   "--profile",
                                   "--rails",
                                   "--exclude /gems/,/Library/,spec"]}
    end

  end
end
