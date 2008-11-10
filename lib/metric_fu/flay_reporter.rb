module MetricFu
  module FlayReporter
    class Generator < Base::Generator
      
      def generate_report
        save_html(parse)
      end
      
      def parse
        content = ""
        File.open("#{@base_dir}/result.txt", "r").each_line do |file|
          content << file + "<br/>"
        end
        content     
      end
    end
  end
end