source 'https://rubygems.org'

group :development do
  gem 'rake'
end
group :test do
  gem "rspec", '>2'
  gem 'test-construct'
  if ENV['COVERAGE']
    gem 'simplecov'
    # https://github.com/kina/simplecov-rcov-text
    gem 'simplecov-rcov-text'
  end
end
gemspec
