module MetricFu::FlogReporter
  class Generator < MetricFu::Base::Generator
    def generate_report
      flog_hashes = []
      Dir.glob("#{@base_dir}/**/*.txt").each do |filename|
        content = ""
        File.open(filename, "r").each_line do |file|
          content << file
        end

        begin
          page = Base.parse(content)
        rescue InvalidFlog
          puts "Invalid flog for #{filename}"
          next
        end

        next unless page

        if MetricFu::MD5Tracker.file_already_counted?(filename)            
          flog_hashes << {
            :page => page,
            :path => filename.sub('.txt', '').sub("#{@base_dir}/", "")
          }
        else  
          flog_hashes << generate_page(filename, page)
        end
      end
      
      generate_index(flog_hashes)
    end

    def generate_page(filename, page)
      html_file = save_html(page.to_html, File.basename(filename, ".txt"))
      return { :path => File.basename(filename, ".txt") + '.html',
               :page => page }
    end

    def generate_index(flog_hashes)
      html = "<html><head><title>Flog Reporter</title><style>"
      html << Base.load_css
      html << "</style></head><body>"
      html << "<p><strong>Flogged files</strong></p>\n"
      html << "<p>Generated on #{Time.now.localtime} with <a href='http://ruby.sadi.st/Flog.html'>flog</a></p>\n"
      html << "<table class='report'>\n"
      html << "<tr><th>File</th><th>Total score</th><th>Methods</th><th>Average score</th><th>Highest score</th></tr>"
      count = 0
      flog_hashes.sort {|x,y| y[:page].highest_score <=> x[:page].highest_score }.each do |flog_hash|
        html << <<-EOF
                  <tr class='#{Base.cycle("light", "dark", count)}'>
                    <td><a href='#{flog_hash[:path]}'>#{flog_hash[:path].sub('.html', '.rb')}</a></td>
                    <td class='score'>#{sprintf(SCORE_FORMAT, flog_hash[:page].score)}</td>
                    <td class='score'>#{flog_hash[:page].scanned_methods.length}</td>
                    <td class='score'>#{sprintf(SCORE_FORMAT, flog_hash[:page].average_score)}</td>
                    <td class='score'>#{sprintf(SCORE_FORMAT, flog_hash[:page].highest_score)}</td>
                  </tr>
                EOF
        count += 1
      end
      html << "</table>\n"
      html << "</body></html>\n"
      save_html(html)
    end
  end
end