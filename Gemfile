source 'https://rubygems.org'

gem 'rake'
# alternative graphing gem
gem "googlecharts"
group :development do

end
group :ci do
  gem 'activesupport', '~> 3.2' # for 1.9.2 support because of https://github.com/railsbp/rails_best_practices/blob/master/rails_best_practices.gemspec
end
group :test do
  gem "rspec", '>2'
  gem 'test-construct'
  if ENV['COVERAGE']
    gem 'simplecov'
    # https://github.com/kina/simplecov-rcov-text
    gem 'simplecov-rcov-text'
  end
  gem "fakefs", :require => "fakefs/safe"
end
gemspec
