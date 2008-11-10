module MetricFu::FlogReporter
  class Generator < MetricFu::Base::Generator
    def generate_report
      flog_hashes = []
      Dir.glob("#{@base_dir}/**/*.txt").each do |filename|
        begin
          page = Base.parse(open(filename, "r") { |f| f.read })
        rescue InvalidFlog
          puts "Invalid flog for #{filename}"
          next
        end

        next unless page

        unless MetricFu::MD5Tracker.file_already_counted?(filename)
          generate_page(filename, page)
        end
        flog_hashes << { :path => File.basename(filename, ".txt") + '.html',
                 :page => page }        
      end
      
      generate_index(flog_hashes)
    end

    def generate_page(filename, page)
      save_html(page.to_html, File.basename(filename, ".txt"))
    end

    # should be dynamically read from the class
    def template_name
      'flog'      
    end

    def generate_index(flog_hashes)
      html = ERB.new(File.read(template_file)).result(binding)
      save_html(html)
    end
  end
end