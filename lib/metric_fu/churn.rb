module MetricFu
  class Churn < Base::Generator
    
    def initialize(base_dir, options={})
      @base_dir = base_dir
      case options[:scm]
      when :git
        @source_control = Git.new(options[:start_date])
      else
        @source_control = Svn.new(options[:start_date])
      end       
      @minimum_churn_count = options[:minimum_churn_count] || 5
      @changes = parse_log_for_changes.reject! {|file, change_count| change_count < @minimum_churn_count}
    end

    def generate_html
      content = CHURN_FILE_BEGINING
        @changes.to_a.sort {|x,y| y[1] <=> x[1]}.each do |change|
          content << "<tr><td>#{change[0]}</td><td class='warning'>#{change[1]}</td></tr>\n"
        end
      content << CHURN_FILE_END        
      content
    end 
  
    private
    
    def parse_log_for_changes
      changes = {}
      
      logs = @source_control.get_logs
      logs.each do |line|
        changes[line] ? changes[line] += 1 : changes[line] = 1 
      end    
      changes
    end    

    
    class SourceControl
      def initialize(start_date=nil)
        @start_date = start_date
      end
      
      private
      def require_rails_env
        require RAILS_ROOT + '/config/environment'
      end
    end
    
    class Git < SourceControl
      def get_logs
        `git log #{date_range} --name-only --pretty=format:`.split(/\n/).reject{|line| line == ""}          
      end      
      
      private      
      def date_range
        if @start_date
          require_rails_env
          "--after=#{@start_date.call.strftime('%Y-%m-%d')}"     
        end        
      end
      
    end
    
    class Svn < SourceControl
      def get_logs
        `svn log #{date_range} --verbose`.split(/\n/).map { |line| clean_up_svn_line(line) }.compact
      end    
        
      private      
      def date_range
        if @start_date
          require_rails_env        
          "--revision {#{@start_date.call.strftime('%Y-%m-%d')}}:{#{Time.now.strftime('%Y-%m-%d')}}"
        end
      end
      
      def clean_up_svn_line(line)
        m = line.match(/\W*[A,M]\W+(\/.*)\b/)
        m ? m[1] : nil
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
