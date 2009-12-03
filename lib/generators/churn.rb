require 'chronic'
require 'sexp_processor'
require 'ruby_parser'
require 'json'

module MetricFu
  
  class ParseBreakDown < SexpProcessor

    attr_reader :klasses_collection, :methods_collection
    
    def initialize()
      super
      @klasses_collection  = {}
      @methods_collection  = {}
      @parser              = RubyParser.new
      self.auto_shift_type = true
    end
    
    def get_info(file)
      ast = @parser.process(File.read(file), file)
      process ast
    end
    
    def process_class(exp)
      name           = exp.shift
      start_line     = exp.line
      last_line      = exp.last.line
      @current_class = name
      @klasses_collection[name] = [] unless @klasses_collection.include?(name)
      @klasses_collection[name] << (start_line..last_line)
      analyze_list exp
      s()
    end
    
    def analyze_list exp
      process exp.shift until exp.empty?
    end
    
    def process_defn(exp)
      name        = exp.shift
      start_line  = exp.line
      last_line   = exp.last.line
      full_name   = "#{@current_class}##{name}"
      @methods_collection[full_name] = [] unless @methods_collection.include?(full_name)
      @methods_collection[full_name] << (start_line..last_line)
      return s(:defn, name, process(exp.shift), process(exp.shift))
    end

end

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
      @changes       = parse_log_for_changes.reject {|file, change_count| change_count < @minimum_churn_count}
      @revisions     = parse_log_for_revision_changes  
    end 

    def analyze
      @changes          = @changes.to_a.sort {|x,y| y[1] <=> x[1]}
      @changes          = @changes.map {|file_path, times_changed| {:file_path => file_path, :times_changed => times_changed }}
      @revision_changes = {}
      @revisions.each do |revision|
        if revision == @revisions.first
          #can't iterate through all the changes and tally them up as it only has the current files not the files at the time of the revision
          #parsing requires the files
          changed_files   = parse_logs_for_updated_files(revision, @revisions)
          changed_classes = changed_files.map { |change| get_classes(change) } 
          changed_methods = changed_files.map { |change| get_methods(change) } 
          changed_files   = changed_files.map { |file, lines| file }
        else
          #load revision data from scratch folder if it exists
          filename = "tmp/#{revision}.json"
          if File.exists?(filename)
            json_data = File.read(filename)
            data      = JSON.parse(json_data)
            changed_files   = data[:churn][:files]
            changed_classes = data[:churn][:classes]
            changed_methods = data[:churn][:methods]
          end
        end
        @revision_changes[revision] = { :files => changed_files, :classes => changed_classes, :methods => changed_methods }
      end
    end

    def to_h
      hash = {:churn => {:changes => @changes}}
      #detail the most recent changes made this revision
      if @revision_changes[@revisions.first]
        changes = @revision_changes[@revisions.first]
        hash[:churn][:changed_files]   = changes[:files]
        hash[:churn][:changed_classes] = changes[:classes]
        hash[:churn][:changed_methods] = changes[:methods]
      end
      puts hash[:churn].inspect
      #TODO crappy place to do this but save hash to revision file
      store_hash(hash)
      hash
    end

    private

    def store_hash(hash)
      revision = @revisions.first
      File.open("tmp/#{revision}.json", 'w') {|f| f.write(hash.to_json) }
    end

    #TODO get_classes and get_methods are to much dup. Also they both process everything so we do it twice, bad!
    def get_classes(file)
      begin
        breakdown = ParseBreakDown.new
        breakdown.get_info(file.first)
        klass_collection = breakdown.klasses_collection
        changed_klasses  = []
        changes = file.last
        klass_collection.each_pair do |klass, klass_lines|
          klass_lines = klass_lines[0].to_a
          changes.each do |change_range|
            klass_lines.each do |line|
              changed_klasses << klass if change_range.include?(line) && !changed_klasses.include?(klass)
            end
          end
        end
        changed_klasses
      rescue
        []
      end
    end

    def get_methods(file)
      begin
      breakdown = ParseBreakDown.new
      breakdown.get_info(file.first)
      method_collection = breakdown.methods_collection
      changed_methods   = []
      changes = file.last
      method_collection.each_pair do |method, method_lines|
        method_lines = method_lines[0].to_a
        changes.each do |change_range|
          method_lines.each do |line|
            changed_methods << method if change_range.include?(line) && !changed_methods.include?(method)
          end
        end
      end
        changed_methods
      rescue  
        []
      end
    end
  
    def parse_log_for_changes
      changes = {}
      
      logs = @source_control.get_logs
      logs.each do |line|
        changes[line] ? changes[line] += 1 : changes[line] = 1
      end
      changes
    end

    def parse_log_for_revision_changes
      @source_control.get_revisions
    end
    
    def parse_logs_for_updated_files(revision, revisions)
      updated     = {}
      recent_file = nil

     #TODO look up how to only call a method if it exists @source_control.supports(:parse_logs_for_updated_files) else return empty
     logs = @source_control.get_updated_files_from_log(revision, revisions)
     logs.each do |line|
       if line.match(/^---/) || line.match(/^\+\+\+/)
         line = line.gsub(/^--- /,'').gsub(/^\+\+\+ /,'').gsub(/^a\//,'').gsub(/^b\//,'')
         unless updated.include?(line)
           updated[line] = [] 
         end
         recent_file = line
       elsif line.match(/^@@/)
         #TODO cleanup / refactor
         #puts "#{recent_file}: #{line}"
         removed        = line.match(/-[0-9]+/)
         removed_length = line.match(/-[0-9]+,[0-9]+/)
         removed        = removed.to_s.gsub(/-/,'')
         removed_length = removed_length.to_s.gsub(/.*,/,'')
         added          = line.match(/\+[0-9]+/)
         added_length   = line.match(/\+[0-9]+,[0-9]+/)
         added          = added.to_s.gsub(/\+/,'')
         added_length   = added_length.to_s.gsub(/.*,/,'')
         removed_range  = if removed_length && removed_length!=''
                            (removed.to_i..(removed.to_i+removed_length.to_i))
                          else
                            (removed.to_i..removed.to_i)
                          end
         added_range    = if added_length && added_length!=''
                            (added.to_i..(added.to_i+added_length.to_i))
                          else
                            (added.to_i..added.to_i)
                          end
         updated[recent_file] << removed_range
         updated[recent_file] << added_range
       else
         raise "git diff lines that don't match the two patterns aren't expected"
       end
     end
     updated
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

      def get_revisions
        `git log #{date_range} --pretty=format:"%H"`.split(/\n/).reject{|line| line == ""}
      end

      def get_updated_files_from_log(revision, revisions)
        current_index = revisions.index(revision)
        previous_index = current_index+1
        previous_revision = revisions[previous_index] unless revisions.length < previous_index
        #require 'ruby-debug'; debugger
        if revision && previous_revision
          puts "git diff #{revision} #{previous_revision} --unified=0"
          `git diff #{revision} #{previous_revision} --unified=0`.split(/\n/).select{|line| line.match(/^@@/) || line.match(/^---/) || line.match(/^\+\+\+/) }
        else
          []
        end
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

#todo move to its own class
  #require 'rubygems'
  require 'ruby_parser'

  class Parser
    def parse(content, filename)
      silence_stream(STDERR) do 
        return silent_parse(content, filename)
      end
    end
    
    private
    
    def silence_stream(stream)
      old_stream = stream.dup
      stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
      stream.sync = true
      yield
    ensure
      stream.reopen(old_stream)
    end
    
    def silent_parse(content, filename)
      @parser ||= RubyParser.new
      @parser.parse(content, filename)
    end
  end

end
