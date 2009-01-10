module MetricFu
  ROODI_DIR = File.join(MetricFu::BASE_DIRECTORY, 'roodi')
  
  def self.generate_roodi_report
    MetricFu::Roodi.generate_report(ROODI_DIR)
    system("open #{ROODI_DIR}/index.html") if open_in_browser?    
  end
    
  class Roodi < Base::Generator

    def analyze
      files_to_analyze = MetricFu.roodi[:dirs_to_roodi].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `roodi #{files_to_analyze.join(" ")}`
      @matches = output.chomp.split("\n").map{|m| m.split(" - ") }
    end

  end
end