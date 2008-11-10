require 'erb'

module MetricFu
  module FlayReporter
    class Generator < Base::Generator    
      
      def analyze
        files_to_flay = MetricFu::CODE_DIRS.map{|dir| Dir[File.join(dir, "**/*.rb")] }
        output = `flay #{files_to_flay.join(" ")}`
        @matches = output.chomp.split("\n\n").map{|m| m.split("\n  ") }
      end
      
      # should be dynamically read from the class      
      def template_name
        'flay'      
      end
         
    end        
  end
end