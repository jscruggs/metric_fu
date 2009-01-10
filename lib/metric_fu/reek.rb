module MetricFu
  REEK_DIR = File.join(MetricFu::BASE_DIRECTORY, 'reek')
  
  def self.generate_reek_report
    MetricFu::Reek.generate_report(REEK_DIR)
    system("open #{REEK_DIR}/index.html") if open_in_browser?    
  end
    
  class Reek < Base::Generator

    def analyze
      files_to_reek = MetricFu.reek[:dirs_to_reek].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `reek #{files_to_reek.join(" ")}`
      @matches = output.chomp.split("\n\n").map{|m| m.split("\n") }
    end

  end
end