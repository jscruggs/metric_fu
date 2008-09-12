namespace :metrics do
  
  SAIKURO_DIR = File.join(MetricFu::BASE_DIRECTORY, 'saikuro')
  
  desc "A cyclomatic complexity report using Saikuro"
  task :saikuro do
    default_options = {"--output_directory" => SAIKURO_DIR,
                        "--input_directory" => "app",
                        "--cyclo" => "",
                        "--filter_cyclo" => "0",
                        "--warn_cyclo" => "5",
                        "--error_cyclo" => "7"}
  
    default_options.merge!(SAIKURO_OPTIONS) if defined?(SAIKURO_OPTIONS)
    options = ""
    default_options.each_pair { |key, value| options << "#{key} #{value} " }  
     
    sh "ruby \"#{File.expand_path(File.join(File.dirname(__FILE__), '..', 'metric_fu', 'saikuro'))}/saikuro.rb\" " +
                "#{options}" do |ok, response|
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