require 'erb'
require 'fileutils'

module MetricFu
  class Flay
  
    class << self
      def generate_report(options = {})
        puts Dir.pwd
        files_to_flay = MetricFu::CODE_DIRS.map{|dir| Dir[File.join(dir, "**/*.rb")] }
        output = `flay #{files_to_flay.join(" ")}`
        @matches = output.chomp.split("\n\n").map{|m| m.split("\n  ") }
        write_html_output("flay")
      end
    
    private
      def write_html_output(template_name)
        output_dir = File.join(MetricFu::BASE_DIRECTORY, template_name)
        FileUtils.mkdir_p(output_dir, :verbose => false)
        
        template_file = File.join(MetricFu::TEMPLATE_DIR, "#{template_name}.html.erb")
        html = ERB.new(File.read(template_file)).result(binding)
        
        File.open(File.join(output_dir, 'index.html'), "w"){|f| f << html }
        FileUtils.cp(File.join(MetricFu::TEMPLATE_DIR, "#{template_name}.css"), output_dir)
        `open #{output_dir}/index.html`
      end
      
      def link_to_filename(name, line = nil)
        filename = File.expand_path(name)
        if PLATFORM['darwin']
          %{<a href="txmt://open/?url=file://#{filename}&line=#{line}">#{name}</a>}
        else
          %{<a href="file://#{filename}">#{name}</a>}
        end
      end
    end
  
  end
end
