require File.join(File.dirname(__FILE__), '..', 'metricks', 'md5_tracker')
require File.join(File.dirname(__FILE__), '..', 'metricks', 'flog_reporter')

begin
  FLOG_DIR = File.join(Metricks::BASE_DIRECTORY, 'flog')

  def flog(output, directory)
    Dir.glob("#{directory}/**/*.rb").each do |filename|
      output_dir = "#{FLOG_DIR}/#{filename.split("/")[0..-2].join("/")}"
      mkdir_p(output_dir, :verbose => false) unless File.directory?(output_dir)
      `flog #{filename} > #{FLOG_DIR}/#{filename.split('.')[0]}.txt` if Metricks::MD5Tracker.file_changed?(filename, FLOG_DIR)
    end
  end

  namespace :metricks do
  
    task :flog => ['flog:all'] do
    end
    
    namespace :flog do
      desc "Delete aggregate flog data."
      task(:clean) { rm_rf(FLOG_DIR, :verbose => false) }
  
      desc "Flog code in app/models"
      task :models do
        flog "models", "app/models"
      end

      desc "Flog code in app/controllers"  
      task :controllers do
        flog "controllers", "app/controllers"
      end

      desc "Flog code in app/helpers"  
      task :helpers do
        flog "helpers", "app/helpers"
      end

      desc "Flog code in lib"  
      task :lib do
        flog "lib", "lib"
      end  

      desc "Generate and open flog report"
      task :all => [:models, :controllers, :helpers, :lib] do
        Metricks::FlogReporter::Generator.generate_report(FLOG_DIR)
        system("open #{FLOG_DIR}/index.html") if PLATFORM['darwin']
      end
    end

  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - flog tasks not available'
  else
    puts 'sudo gem install flog # if you want the flog tasks'
  end
end