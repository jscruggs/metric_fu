# see http://blog.jayfields.com/2008/02/rake-task-overwriting.html
desc 'override bundler release task'
task :release => ['build'] do
  STDOUT.puts "Running Bundler Release Task Override"
  Rake::Task['checksum'].invoke
end
require 'bundler/gem_tasks'

GEMSPEC = Bundler::GemHelper.gemspec

desc 'Builds and signs a new Gem'
task :signed_build => [:build] do
  name = "#{GEMSPEC.name}-#{GEMSPEC.version}.gem"
  path = File.join(File.expand_path('../../pkg', __FILE__), name)

  sh("gem sign #{path}")

  Rake::Task['checksum'].invoke
end
require 'digest/sha2'

desc 'Creates a SHA512 checksum of the current version'
task :checksum  do
  checksums = File.expand_path('../../checksum', __FILE__)
  name      = "#{GEMSPEC.name}-#{GEMSPEC.version}.gem"
  path      = File.join(File.expand_path('../../pkg', __FILE__), name)

  checksum_name = File.basename(path) + '.sha512'
  checksum      = Digest::SHA512.new.hexdigest(File.read(path))

  File.open(File.join(checksums, checksum_name), 'w') do |handle|
    handle.write(checksum)
  end
end

desc 'Creates a Git tag for the current version'
task :tag do
  version = MetricFu::VERSION

  sh %Q{git tag -a -m "Version #{version}" -s #{version}}
end

desc 'Extracts TODO tags and the likes'
task :todo do
  regex = %w{NOTE: FIXME: TODO: THINK: @todo}.join('|')

  sh "ack '#{regex}' lib"
end
