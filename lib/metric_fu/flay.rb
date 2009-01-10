module MetricFu
  FLAY_DIR = File.join(MetricFu::BASE_DIRECTORY, 'flay')
  
  def self.generate_flay_report
    MetricFu::Flay.generate_report(FLAY_DIR)
    system("open #{FLAY_DIR}/index.html") if open_in_browser?    
  end
    
  class Flay < Base::Generator

    def analyze
      files_to_flay = MetricFu.flay_options[:dirs_to_flay].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `flay #{files_to_flay.join(" ")}`
      @matches = output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

  end
end