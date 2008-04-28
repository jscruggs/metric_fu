require "fileutils"

namespace :metrics do
  desc "Generate coverage, cyclomatic complexity, flog, and stats reports"
  task :all => [:coverage, :cyclomatic_complexity, :flog, :stats]
  
  desc "Generate a coverage report using rcov"
  task :coverage do
    rm_f "coverage.data"
    paths = defined?(TEST_PATHS_FOR_RCOV) ? TEST_PATHS_FOR_RCOV : ['test/**/*_test.rb']
    paths.each { |path| execute_rcov(path) }
  end
  
  def execute_rcov(test_list)
    default_options = {"--rails" => "",
                       "--aggregate" => "coverage.data",
                       "--sort" => "coverage",
                       "--exclude" => '"gems/*,rcov*,spec/*,test/*"',
                       "--output" => %["#{File.join(base_directory, 'coverage')}"]}
                       
    default_options.merge!(RCOV_OPTIONS) if defined?(RCOV_OPTIONS)
    options = ""
    default_options.each_pair { |key, value| options << "#{key} #{value} " }
    
    sh "rcov #{options} #{test_list}" do |ok, response|
      unless ok
        puts "Rcov failed with exit status: #{response.exitstatus}"
        exit 1
      end
    end
  end  
  
  desc "Generate a cyclomatic complexity report using Saikuro"
  task :cyclomatic_complexity do
    default_options = {"--output_directory" => "#{base_directory}/cyclomatic_complexity",
                        "--input_directory" => "app",
                        "--cyclo" => "",
                        "--filter_cyclo" => "0",
                        "--warn_cyclo" => "5",
                        "--error_cyclo" => "7"}
    
    default_options.merge!(SAIKURO_OPTIONS) if defined?(SAIKURO_OPTIONS)
    options = ""
    default_options.each_pair { |key, value| options << "#{key} #{value} " } 
       
    sh "ruby #{File.expand_path(File.join( File.dirname(__FILE__), '../lib' ))}/saikuro "+
                "#{options}" do |ok, response|
      unless ok
        puts "Saikuro failed with exit status: #{response.exitstatus}"
        exit 1
      end
    end
    if File.exist? "#{base_directory}/cyclomatic_complexity/index_cyclo.html"
      mv "#{base_directory}/cyclomatic_complexity/index_cyclo.html", 
         "#{base_directory}/cyclomatic_complexity/index.html"
    end
  end
  
  desc "Generate a Flog report"
  task :flog do
    FileUtils.mkpath "#{base_directory}/flog"
    sh "echo '<pre>' > #{base_directory}/flog/index.html"
    sh "flog -a app/ >> #{base_directory}/flog/index.html" do |ok, response|
      unless ok
        puts "Flog failed with exit status: #{response.exitstatus}"
        exit 1
      end
    end
    flog_output = File.read("#{base_directory}/flog/index.html")
    total_score = flog_output.split("\n")[1].split("=").last.strip.to_f
    total_methods = flog_output.split("\n").select {|line| line =~ /#/ }.length    
    sh "echo 'Average Score Per Method: #{total_score / total_methods}' >> #{base_directory}/flog/index.html"
    sh "echo '</pre>' >> #{base_directory}/flog/index.html"
  end
  
  desc "Generate a stats report"
  task :stats do
    sh "rake stats > #{File.join(base_directory, 'stats.log')}"
  end
  
  desc "See which files change the most"
  task :churn do
    svn_logs = `svn log --verbose`.split(/\n/).select {|line| line.strip =~ /^[A,M]/}

    changes = {}
    svn_logs.each do |line|
      line.strip =~ /^[A,M] (.*)/
      changes[$1] ? changes[$1] += 1 : changes[$1] = 1 
    end
    write_churn_file(changes.reject {|file, change_count| change_count < 3})
  end

  def write_churn_file changes
    FileUtils.mkpath "#{base_directory}/churn"
    File.open("#{base_directory}/churn/index.html", "w+") do |file|
      file << CHURN_FILE_BEGINING
      changes.to_a.sort {|x,y| y[1] <=> x[1]}.each do |change|
        file << "<tr><td>#{change[0]}</td><td class='warning'>#{change[1]}</td></tr>\n"
      end
      file << CHURN_FILE_END
    end    
  end

  def base_directory
    ENV['CC_BUILD_ARTIFACTS'] ? ENV['CC_BUILD_ARTIFACTS']  : "metrics"
  end

  CHURN_FILE_BEGINING = <<-EOS
  <html><head><title>Source Control Churn Results</title></head>
  <style>
  body {
    margin: 20px;
    padding: 0;
    font-size: 12px;
    font-family: bitstream vera sans, verdana, arial, sans serif;
    background-color: #efefef;
  }

  table { 
    border-collapse: collapse;
    /*border-spacing: 0;*/
    border: 1px solid #666;
    background-color: #fff;
    margin-bottom: 20px;
  }

  table, th, th+th, td, td+td  {
    border: 1px solid #ccc;
  }

  table th {
    font-size: 12px;
    color: #fc0;
    padding: 4px 0;
    background-color: #336;
  }

  th, td {
    padding: 4px 10px;
  }

  td {  
    font-size: 13px;
  }

  .warning {
    background-color: yellow;
  }
  </style>

  <body>
  <h1>Source Control Churn Results</h1>
    <table width="100%" border="1">
      <tr><th>File Path</th><th>Times Changed</th></tr>
  EOS

  CHURN_FILE_END = <<-EOS
    </table>
  </body>
  </html>
  EOS
end