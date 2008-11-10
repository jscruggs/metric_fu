begin
  DUPLICATION_DIR = File.join(MetricFu::BASE_DIRECTORY, 'duplication')

  def duplication(output, directory)
    mkdir_p(DUPLICATION_DIR, :verbose => false)
    `flay -m=5 #{directory}/**/*.rb > #{DUPLICATION_DIR}/result.txt`
  end

  namespace :metrics do
  
    task :duplication => ['duplication:all'] do
    end
    
    namespace :duplication do
      desc "Delete aggregate duplication data."
      task(:clean) { rm_rf(DUPLICATION_DIR, :verbose => false) }
  
      desc "duplication code in app/models"
      task :models do
        duplication "models", "app/models"
      end

      desc "duplication code in app/controllers"  
      task :controllers do
        duplication "controllers", "app/controllers"
      end

      desc "duplication code in app/helpers"  
      task :helpers do
        duplication "helpers", "app/helpers"
      end

      desc "duplication code in lib"  
      task :lib do
        duplication "lib", "lib"
      end  

      desc "Generate and open duplication report"
      task :all => [:models, :controllers, :helpers, :lib] do
        MetricFu::FlayReporter::Generator.generate_report(DUPLICATION_DIR)
        system("open #{DUPLICATION_DIR}/index.html") if PLATFORM['darwin']
      end
           
    end

  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - flay tasks not available'
  else
    puts 'sudo gem install flay # if you want the flay tasks'
  end
end