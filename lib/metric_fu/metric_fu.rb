module MetricFu
 

  HTML_EXTENSION = '.html.erb'
  YML_EXTENSION  = '.yml.erb'

 

  def self.generate_roodi_report
    @roodi_report = Roodi.generate_report
    template = MetricFu::Template.new('roodi')
    html = ERB.new(File.read(template.file), nil,'-').result(binding)
    save_output(html, Roodi.metric_dir)
    show_in_browser(Roodi.metric_dir)
  end

  def self.generate_reek_report
    @reek_report = Reek.generate_report
    template = MetricFu::Template.new('reek')
    html = ERB.new(File.read(template.file),nil,'-').result(binding)
    save_output(html, Reek.metric_dir)
    show_in_browser(Reek.metric_dir)
  end

  def self.generate_flay_report
    @flay_report = Flay.generate_report
    template = MetricFu::Template.new('flay')
    html = ERB.new(File.read(template.file),nil,'-').result(binding)
    save_output(html, Flay.metric_dir)
    show_in_browser(Flay.metric_dir)
  end

  def self.generate_churn_report
    @churn_report = Churn.generate_report
    template = MetricFu::Template.new('churn')
    html = ERB.new(File.read(template.file),nil,'-').result(binding)
    save_output(html, Churn.metric_dir)
    show_in_browser(Churn.metric_dir)
  end

  def self.generate_saikuro_report
    @saikuro_report = Saikuro.generate_report
    @saikuro_report[:saikuro][:units].each do |unit|
      template = MetricFu::Template.new('saikuro_unit')
      html = ERB.new(File.read(template.file),nil,'-').result(binding)
      fname = File.basename(unit[:filename], '.html') + '.saikuro'
      save_output(html, Saikuro.metric_dir, fname)
    end
  end

  def self.generate_flog_report
    @flog_report = Flog.generate_report
    @flog_report[:flog][:pages].each do |page|
      template = MetricFu::Template.new('flog_page')
      html = ERB.new(File.read(template.file),nil,'-').result(binding)
      fname =  File.basename(page.filename, ".txt") + ".html"
      save_output(html, Flog.metric_dir, fname)
    end
    template = MetricFu::Template.new('flog')
    html = ERB.new(File.read(template.file),nil,'-').result(binding)
    pages = @flog_report[:flog][:pages]
    save_output(html, Flog.metric_dir, 'index.html')
    show_in_browser(Flog.metric_dir)
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
