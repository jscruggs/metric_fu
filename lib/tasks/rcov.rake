require 'fileutils'
 
begin
  require 'rcov'
  require 'rcov/rcovtask'
  require 'spec/rake/spectask'
 
  namespace :metrics do
 
    namespace :rcov do
      desc "Delete aggregate coverage data."
      task(:clean) { rm_rf(MetricFu::Rcov.metric_directory, :verbose => false) }

      # Can't figure out how to get an Rcov::RcovTask to output simple
      # text.  It's easy with rcov, but dunno how to get the RcovTask
      # to do it.
      desc "RCov task to generate report"
      task :do => :clean do 
        Dir.mkdir(MetricFu::Rcov.metric_directory)
        test_files = FileList[*MetricFu.coverage[:test_files]].join(' ')
        rcov_opts = MetricFu.coverage[:rcov_opts].join(' ')
        output = ">> #{MetricFu::Rcov.metric_directory}/rcov.txt"
        `rcov --include-file #{test_files}  #{rcov_opts} #{output}`
      end
    end
 
    desc "Generate and open coverage report"
    task :rcov => ['rcov:do'] do
      MetricFu.generate_rcov_report
    end
  end

rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - rcov tasks not available'
  else
    puts 'sudo gem install rcov # if you want the rcov tasks'
 
  end
end
