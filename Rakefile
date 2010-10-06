$LOAD_PATH << '.'
require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'lib/metric_fu'
 
desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

 MetricFu::Configuration.run do |config|
        #define which metrics you want to use
        # 
	config.metrics  = [:churn, :saikuro, :flog, :flay, :reek, :roodi, :hotspots]
	#config.metrics  = [:churn, :hotspots]
        #config.graphs   = [:flog, :flay, :reek, :roodi]
        config.graphs   = []
        config.flay     = { :dirs_to_flay => ['app', 'lib']  } 
        config.flog     = { :dirs_to_flog => ['app', 'lib']  }
        config.reek     = { :dirs_to_reek => ['app', 'lib']  }
        config.roodi    = { :dirs_to_roodi => ['app', 'lib'],
                            :roodi_config => 'config/roodi_config.yml' }
        config.saikuro  = { :output_directory => 'scratch_directory/saikuro', 
                            :input_directory => ['app', 'lib'],
                            :cyclo => "",
                            :filter_cyclo => "0",
                            :warn_cyclo => "5",
                            :error_cyclo => "7",
                            :formater => "text"} #this needs to be set to "text"
        config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
	config.hotspots    = { :start_date => "1 year ago", :minimum_churn_count => 10}
        # config.rcov     = { :test_files => ['spec/**/*_spec.rb'],
#                             :rcov_opts => ["--sort coverage", 
#                                            "--no-html", 
#                                            "--text-coverage",
#                                            "--no-color",
#                                            "--profile",
#                                            "--rails",
#                                            "--exclude /gems/,/Library/,spec"]}
    end
 
task :default => :spec
