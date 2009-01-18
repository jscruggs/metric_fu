module MetricFu
  
  def self.generate_roodi_report
    MetricFu::Roodi.generate_report
    system("open #{Roodi.metric_dir}/index.html") if open_in_browser?    
  end
    
  class Roodi < Base::Generator

    def analyze
      files_to_analyze = MetricFu.roodi[:dirs_to_roodi].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `roodi #{files_to_analyze.join(" ")}`
      @matches = output.chomp.split("\n").map{|m| m.split(" - ") }
    end

  end
end