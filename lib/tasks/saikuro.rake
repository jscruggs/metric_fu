require 'fileutils'

namespace :metrics do

  desc "A cyclomatic complexity report using Saikuro"
  task :saikuro do
    SAIKURO_DIR = File.join(MetricFu.base_directory, 'saikuro')
    SAIKURO = File.expand_path(File.join(File.dirname(__FILE__), '..', 'metric_fu', 'saikuro', 'saikuro.rb'))

    raise "SAIKURO_OPTIONS is now MetricFu::SAIKURO_OPTIONS" if defined?(SAIKURO_OPTIONS)
    options = { :output_directory => SAIKURO_DIR,
                        :input_directory => MetricFu.code_dirs,
                        :cyclo => "",
                        :filter_cyclo => "0",
                        :warn_cyclo => "5",
                        :error_cyclo => "7",
                        :formater => "text"}
    

    options.merge!(MetricFu::SAIKURO_OPTIONS) if defined?(MetricFu::SAIKURO_OPTIONS)
    options_string = options.inject(""){ |o, h| o + "--#{h.join(' ')} " }

    puts options_string

    sh %{ruby "#{SAIKURO}" #{options_string}} do |ok, response|
      unless ok
        puts "Saikuro failed with exit status: #{response.exitstatus}"
        exit 1
      end
    end

    MetricFu.generate_saikuro_report
  end
end
