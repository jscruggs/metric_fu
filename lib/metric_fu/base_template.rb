module MetricFu
class Template
  attr_accessor :report
  
  private

  def erbify(section)
    erb_doc = File.read(template(section))
    ERB.new(erb_doc).result(binding)
  end

  def template_exists?(section)
    File.exist?(template(section))
  end

  def create_instance_var(section, contents)
    instance_variable_set("@#{section}", contents)        
  end

  def template(section)
    File.join(this_directory,  section.to_s + ".html.erb")
  end

  def output_filename(section)
    section.to_s + ".html"
  end

  def inline_css(css)
    open(File.join(this_directory, css)) { |f| f.read }      
  end
 
  def link_to_filename(name, line = nil)
    filename = File.expand_path(name)
    if PLATFORM['darwin']
      %{<a href="txmt://open/?url=file://#{filename}&line=#{line}">#{name}:#{line}</a>}
    else
      %{<a href="file://#{filename}">#{name}:#{line}</a>}
    end
  end
  
  def cycle(first_value, second_value, iteration)
    return first_value if iteration % 2 == 0
    return second_value
  end      

end
end
