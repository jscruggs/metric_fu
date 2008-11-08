require 'fileutils'

namespace :metrics do

  desc "A cyclomatic complexity report using Saikuro"
  task :saikuro do
    SAIKURO_DIR = File.join(MetricFu::BASE_DIRECTORY, 'saikuro')
    SAIKURO = File.expand_path(File.join(File.dirname(__FILE__), '..', 'metric_fu', 'saikuro', 'saikuro.rb'))

    raise "SAIKURO_OPTIONS is now MetricFu::SAIKURO_OPTIONS" if defined?(SAIKURO_OPTIONS)
    options = { :output_directory => SAIKURO_DIR,
                        :input_directory => ,
                        :cyclo => MetricFu::CODE_DIRS,
                        :filter_cyclo => "0",
                        :warn_cyclo => "5",
                        :error_cyclo => "7"}
  
    options.merge!(MetricFu::SAIKURO_OPTIONS) if defined?(MetricFu::SAIKURO_OPTIONS)
    options_string = default_options.inject(""){ |o, h| o + "--#{h.join(' ')} " }  
     
    sh %{ruby "#{SAIKURO}" #{options_string}} do |ok, response|
      unless ok
        puts "Saikuro failed with exit status: #{response.exitstatus}"
        exit 1
      end
    end

    if File.exist? "#{SAIKURO_DIR}/index_cyclo.html"
      mv "#{SAIKURO_DIR}/index_cyclo.html", 
         "#{SAIKURO_DIR}/index.html"
    end
    
    system("open #{SAIKURO_DIR}/index.html") if PLATFORM['darwin']
  end
end