FLAY_DIR = File.join(MetricFu::BASE_DIRECTORY, 'flay')

module MetricFu
  
  def generate_flay_report
    MetricFu::Flay.generate_report(FLAY_DIR)
  end
    
  class Flay < Base::Generator

    def analyze
      files_to_flay = MetricFu::CODE_DIRS.map{|dir| Dir[File.join(dir, "**/*.rb")] }
      output = `flay #{files_to_flay.join(" ")}`
      @matches = output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

  end
end