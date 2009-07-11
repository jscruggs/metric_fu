require 'chronic'
module MetricFu
  
  class Churn < Generator

    
    def initialize(options={})
      super
      if self.class.git?
        @source_control = Git.new(MetricFu.churn[:start_date])
      elsif File.exist?(".svn")
        @source_control = Svn.new(MetricFu.churn[:start_date])
      else
        raise "Churning requires a subversion or git repo"
      end
      @minimum_churn_count = MetricFu.churn[:minimum_churn_count] || 5
    end

    def self.git?
      system("git branch")
    end
    
    def emit
      @changes = parse_log_for_changes.reject {|file, change_count| change_count < @minimum_churn_count}
    end

    def analyze
      @changes = @changes.to_a.sort {|x,y| y[1] <=> x[1]}
      @changes = @changes.map {|change| {:file_path => change[0], :times_changed => change[1] }}
    end

    def to_h
      {:churn => {:changes => @changes}}
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
    end

    class Git < SourceControl
      def get_logs
        `git log #{date_range} --name-only --pretty=format:`.split(/\n/).reject{|line| line == ""}
      end

      private
      def date_range
        if @start_date
          date = Chronic.parse(@start_date)
          "--after=#{date.strftime('%Y-%m-%d')}"
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
          date = Chronic.parse(@start_date)
          "--revision {#{date.strftime('%Y-%m-%d')}}:{#{Time.now.strftime('%Y-%m-%d')}}"
        end
      end

      def clean_up_svn_line(line)
        m = line.match(/\W*[A,M]\W+(\/.*)\b/)
        m ? m[1] : nil
      end
    end

  end
end
