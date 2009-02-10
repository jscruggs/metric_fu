require 'fileutils'

namespace :metrics do

  desc "A cyclomatic complexity report using Saikuro"
  task :saikuro do
    relative_path = [File.dirname(__FILE__), '..', 
                     'metric_fu', 'saikuro', 'saikuro.rb']
    SAIKURO = File.expand_path(File.join(relative_path))
    options_string = MetricFu.saikuro.inject("") do |o, h|
      o + "--#{h.join(' ')} " 
    end  
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
