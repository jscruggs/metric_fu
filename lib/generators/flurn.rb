class Flurn
  def analyze
    report_hash = YAML::load(File.open('report.yml'))
    flurn_hash = {}
    report_hash[:churn][:changes].each do |churn_file|
      flurn_hash[churn_file[:file_path]] = churn_file[:times_changed]
    end
    
    report_hash[:flog][:pages].each do |flog_file|
      flurn_hash[standarize_file_path(flog_file[:path])] += flog_file[:average_score]
    end
    
    flurn_hash
  end
  
  def standarize_file_path(file_path)
    file_path.sub(/^\//, '')
  end
end