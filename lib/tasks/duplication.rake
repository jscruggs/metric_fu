begin
  DUPLICATION_DIR = File.join(MetricFu::BASE_DIRECTORY, 'duplication')

  namespace :metrics do
  
    task :duplication do
      MetricFu::FlayReporter::Generator.generate_report(DUPLICATION_DIR)
      system("open #{DUPLICATION_DIR}/index.html") if PLATFORM['darwin']
    end
    
  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - flay tasks not available'
  else
    puts 'sudo gem install flay # if you want the flay tasks'
  end
end