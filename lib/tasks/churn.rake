namespace :metrics do
  CHURN_DIR = File.join(MetricFu::BASE_DIRECTORY, 'churn')
  
  desc "Which files change the most"
  task :churn do
    date_range, minimum_churn_count = churn_options()
    svn_logs = `svn log #{date_range} --verbose`.split(/\n/).select {|line| line.strip =~ /^[A,M]/}    
  
    changes = {}
    svn_logs.each do |line|
      line.strip =~ /^[A,M] (.*)/
      changes[$1] ? changes[$1] += 1 : changes[$1] = 1 
    end
    write_churn_file(changes.reject {|file, change_count| change_count < minimum_churn_count})
    system("open #{CHURN_DIR}/index.html") if PLATFORM['darwin']
  end

  def churn_options
    options = defined?(CHURN_OPTIONS) ? CHURN_OPTIONS : {} 
    if options[:start_date]
      require File.dirname(__FILE__) + '/../../../../config/environment'
      date_range = "--revision {#{options[:start_date].call.strftime('%Y-%m-%d')}}:{#{Time.now.strftime('%Y-%m-%d')}}"
    else
      date_range = ""
    end
    minimum_churn_count = options[:minimum_churn_count] ? options[:minimum_churn_count] : 5
    return date_range, minimum_churn_count
  end

  def write_churn_file changes
    FileUtils.mkdir_p(CHURN_DIR, :verbose => false) unless File.directory?(CHURN_DIR)
    File.open("#{CHURN_DIR}/index.html", "w+") do |file|
      file << CHURN_FILE_BEGINING
      changes.to_a.sort {|x,y| y[1] <=> x[1]}.each do |change|
        file << "<tr><td>#{change[0]}</td><td class='warning'>#{change[1]}</td></tr>\n"
      end
      file << CHURN_FILE_END
    end    
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