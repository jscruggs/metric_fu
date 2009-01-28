module MetricFu
 

  HTML_EXTENSION = '.html.erb'
  YML_EXTENSION  = '.yml.erb'

  def self.report
    @report ||= {}
  end

  def self.generate_roodi_report
    report.merge!(Roodi.generate_report)
  end

  def self.generate_reek_report
    report.merge!(Reek.generate_report)
  end

  def self.generate_flay_report
    report.merge!(Flay.generate_report)
  end

  def self.generate_churn_report
    report.merge!(Churn.generate_report)
  end

  def self.generate_saikuro_report
    report.merge!(Saikuro.generate_report)
  end

  def self.generate_flog_report
    report.merge!(Flog.generate_report)
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
