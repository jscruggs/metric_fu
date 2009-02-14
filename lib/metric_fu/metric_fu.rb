module MetricFu
 
  def self.report
    @report ||= {}
  end

  def self.save_templatized_report
    @template = MetricFu.template_class.new
    @template.report = report
    @template.write
  end
  
  def self.add_report(report_type)
    clazz = MetricFu.const_get(report_type.to_s.capitalize)
    report.merge!(clazz.generate_report)
  end

  def self.save_output(content, dir, file='index.html')
    open("#{dir}/#{file}", "w") do |f|
      f.puts content
    end
  end

  def self.open_in_browser?
    PLATFORM['darwin'] && !ENV['CC_BUILD_ARTIFACTS']
  end

  def self.show_in_browser(dir)
    system("open #{dir}/index.html") if open_in_browser?
  end

end
