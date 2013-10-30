source 'https://rubygems.org'

gem 'rake'
group :development do

end

group :test, :coverage do
  gem 'simplecov'
  # https://github.com/kina/simplecov-rcov-text
  gem 'simplecov-rcov-text'
end

group :test do
  gem "rspec", '>2'
  gem 'test-construct'
  gem 'json'
  gem 'pry'
  gem 'pry-nav'
end

gemspec :path => File.expand_path('..', __FILE__)
