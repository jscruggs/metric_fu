module MetricFu
  
  def self.generate_flay_report
    Flay.generate_report
    system("open #{Flay.metric_dir}/index.html") if open_in_browser?    
  end
    
  class Flay < Base::Generator

    def analyze
      files_to_flay = MetricFu.flay[:dirs_to_flay].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `flay #{files_to_flay.join(" ")}`
      @matches = output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

  end
end