source 'https://rubygems.org'


group :test, :coverage do
  # https://github.com/kina/simplecov-rcov-text
  gem 'simplecov-rcov-text'
end

group :test do
  gem 'test-construct'
  gem 'json'
  gem 'pry'
  gem 'pry-nav'
end

gemspec :path => File.expand_path('..', __FILE__)

# group :development, :test do
#   gem 'devtools', git: 'https://github.com/rom-rb/devtools.git'
# end

# Added by devtools
eval_gemfile File.expand_path('Gemfile.devtools', File.dirname(__FILE__))
