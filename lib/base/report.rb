module MetricFu

  def self.report
    @report ||= Report.new
  end

  class Report

    def to_yaml
      @report_hash.to_yaml
    end

    def report_hash
      @report_hash ||= {}
    end

    def save_templatized_report
      @template = MetricFu.template_class.new
      @template.report = report_hash
      @template.write
    end
    
    def add(report_type)
      clazz = MetricFu.const_get(report_type.to_s.capitalize)
      report_hash.merge!(clazz.generate_report)
    end

    def save_output(content, dir, file='index.html')
      open("#{dir}/#{file}", "w") do |f|
        f.puts content
      end
    end

    def open_in_browser?
      PLATFORM['darwin'] && !ENV['CC_BUILD_ARTIFACTS']
    end

    def show_in_browser(dir)
      system("open #{dir}/index.html") if open_in_browser?
    end
  end
end
