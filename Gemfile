source 'https://rubygems.org'

gem 'rails', '4.2.7'
gem 'pg'
gem 'jbuilder', '~> 2.0'
gem 'rack-cors', :require => 'rack/cors'
gem 'kaminari'
gem 'dotenv-rails'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'byebug'
  gem 'spring'
  gem 'thin'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end

group :test do
  gem 'shoulda-matchers', '~> 2.0'
  gem 'factory_girl'
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'database_cleaner'
end
