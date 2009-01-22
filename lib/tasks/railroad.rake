namespace :metrics do
  
  RAILROAD_DIR = File.join(MetricFu::BASE_DIRECTORY, 'railroad')
  RAILROAD_FILE = File.join(RAILROAD_DIR, 'index.html')
  
  task :railroad => ['railroad:all'] do
  end
  
  namespace :railroad do
  
    desc "Create all railroad reports"
    task :all => [:models, :controllers, :aasm] do
      #system("open #{RAILROAD_INDEX}") if PLATFORM['darwin']
    end
  
    desc "Create a railroad models report"
    task :models do
      #mkdir_p(RAILROAD_DIR) unless File.directory?(RAILROAD_DIR)
      `railroad -M -a -m -l -v | neato -Tpng > #{File.join(MetricFu::BASE_DIRECTORY,'model-diagram.png')}`
      #`echo "<a href=\"railroad/models.png\">Model diagram</a><br />" >> #{RAILROAD_FILE}`
    end
  
    desc "Create a railroad controllers report"
    task :controllers do
      #mkdir_p(RAILROAD_DIR) unless File.directory?(RAILROAD_DIR)
      `railroad -C -l -v | neato -Tpng > #{File.join(MetricFu::BASE_DIRECTORY,'controller-diagram.png')}`
      #`echo "<a href=\"railroad/controllers.png\">Controller diagram</a><br />" >> #{RAILROAD_FILE}`
    end
  
    desc "Create a railroad acts_as_state_machine report"
    task :aasm do
      #mkdir_p(RAILROAD_DIR) unless File.directory?(RAILROAD_DIR)
      `railroad -A -l -v | neato -Tpng > #{File.join(MetricFu::BASE_DIRECTORY,'aasm-diagram.png')}`
      #`echo "<a href=\"railroad/aasm.png\">State machine diagram</a><br />" >> #{RAILROAD_FILE}`
    end
    
  end

end