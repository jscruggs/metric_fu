module MetricFu
  module FlayReporter
    class Generator < Base::Generator    
      
      def generate_html
        content = ""
        File.open("#{@base_dir}/result.txt", "r").each_line do |file|
          content << file + "<br/>"
        end
        content     
      end
    end
  end
end