# see http://blog.jayfields.com/2008/02/rake-task-overwriting.html
desc 'override bundler release task'
task :release => ['build'] do
  STDOUT.puts "Running Bundler Release Task Override"
end
require 'bundler/gem_tasks'

GEMSPEC = Bundler::GemHelper.gemspec

# bundler-free alternative
# packaging
# https://github.com/YorickPeterse/ruby-lint/blob/master/Rakefile
# require 'rubygems/package_task'
# GEMSPEC = Gem::Specification.load('metric_fu.gemspec')
#
# Gem::PackageTask.new(GEMSPEC) do |pkg|
#   pkg.need_tar = false
#   pkg.need_zip = false
# end

# gem signing
# desc 'Builds and signs a new Gem'
# task :build => [:gem] do
#   name = "#{GEMSPEC.name}-#{GEMSPEC.version}.gem"
#   path = File.join(File.expand_path('../../pkg', __FILE__), name)
#
#   sh("gem sign #{path}")
#
#   Rake::Task['checksum'].invoke
# end

require 'digest/sha2'

desc 'Creates a SHA512 checksum of the current version'
task :checksum => ['build']  do
  checksums = File.expand_path('../../checksum', __FILE__)
  name      = "#{GEMSPEC.name}-#{GEMSPEC.version}.gem"
  path      = File.join(File.expand_path('../../pkg', __FILE__), name)

  checksum_name = File.basename(path) + '.sha512'
  checksum      = Digest::SHA512.new.hexdigest(File.read(path))

  File.open(File.join(checksums, checksum_name), 'w') do |handle|
    handle.write(checksum)
  end
end
