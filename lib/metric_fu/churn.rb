module MetricFu
  class Churn
    class << self
      def generate_report(output_dir, options)
        date_range, minimum_churn_count, source_control_type = churn_options(options)
        
        changes = parse_log_for_changes(source_control_type, date_range)
        changes.reject! {|file, change_count| change_count < minimum_churn_count}
        write_churn_file(changes, output_dir)
      end
      
      private
      
      def parse_log_for_changes(source_control_type, date_range)
        changes = {}
        
        logs = get_logs(source_control_type, date_range)
        logs.each do |line|
          changes[line] ? changes[line] += 1 : changes[line] = 1 
        end
        
        changes
      end
      
      def get_logs(source_control_type, date_range)
        if source_control_type == :git
          `git log #{date_range} --name-only --pretty=format:`.split(/\n/).reject{|line| line == ""}
        else
          `svn log #{date_range} --verbose`.split(/\n/).map { |line| clean_up_svn_line(line) }.compact
        end
      end
      
      def clean_up_svn_line(line)
        m = line.match(/\W*[A,M]\W+(\/.*)\b/)
        m ? m[1] : nil
      end
      
      def churn_options(options)
        if options[:start_date]
          require 'activesupport'
          if options[:scm] == :git
            date_range = "--after=#{options[:start_date].call.strftime('%Y-%m-%d')}"
          else
            date_range = "--revision {#{options[:start_date].call.strftime('%Y-%m-%d')}}:{#{Time.now.strftime('%Y-%m-%d')}}"
          end
        else
          date_range = ""
        end
        minimum_churn_count = options[:minimum_churn_count] ? options[:minimum_churn_count] : 5
        scm = options[:scm] == :git ? :git : :svn
        return date_range, minimum_churn_count, scm
      end
      
      def write_churn_file(changes, output_dir)
        FileUtils.mkdir_p(output_dir, :verbose => false) unless File.directory?(output_dir)
        File.open("#{output_dir}/index.html", "w+") do |file|
          file << CHURN_FILE_BEGINING
          changes.to_a.sort {|x,y| y[1] <=> x[1]}.each do |change|
            file << "<tr><td>#{change[0]}</td><td class='warning'>#{change[1]}</td></tr>\n"
          end
          file << CHURN_FILE_END
        end    
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
end
