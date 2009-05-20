class AwesomeTemplate < MetricFu::Template

  def write
    @name = File.basename(Dir.pwd)
    report.each_pair do |section, contents|
      if template_exists?(section)
        create_instance_var(section, contents)
        @html = erbify(section)
        html = erbify('layout')
        fn = output_filename(section)
        MetricFu.report.save_output(html, MetricFu.output_directory, fn)
      end
    end

    # Instance variables we need should already be created from above
    if template_exists?('index')
      @html = erbify('index')
      html = erbify('layout')
      fn = output_filename('index')
      MetricFu.report.save_output(html, MetricFu.output_directory, fn)
    end
  end

  def this_directory
    File.dirname(__FILE__)
  end
end

