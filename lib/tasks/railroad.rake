namespace :metrics do
  
  RAILROAD_DIR = File.join(MetricFu::BASE_DIRECTORY, 'railroad')
  RAILROAD_INDEX = File.join(RAILROAD_DIR, 'index.html')
  
  task :railroad => ['railroad:all'] do
  end
  
  namespace :railroad do
  
    desc "Create all railroad reports"
    task :all => [:models, :controllers, :aasm] do
      #system("open #{RAILROAD_INDEX}") if PLATFORM['darwin']
    end
  
    desc "Create a railroad models report"
    task :models do
      mkdir_p(RAILROAD_DIR) unless File.directory?(RAILROAD_DIR)
      `railroad -M -a -m -l -v | neato -Tpng > #{File.join(RAILROAD_DIR,models.png)}`
    end
  
    desc "Create a railroad controllers report"
    task :controllers do
      mkdir_p(RAILROAD_DIR) unless File.directory?(RAILROAD_DIR)
      `railroad -C -l -v | neato -Tpng > #{File.join(RAILROAD_DIR,controllers.png)}`
    end
  
    desc "Create a railroad acts_as_state_machine report"
    task :aasm do
      mkdir_p(RAILROAD_DIR) unless File.directory?(RAILROAD_DIR)
      `railroad -A -l -v | neato -Tpng > #{File.join(RAILROAD_DIR,aasm.png)}`
    end
    
  end

end