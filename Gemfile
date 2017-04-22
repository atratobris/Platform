source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# CORE
gem 'rails', '5.1.0.rc1'
gem 'pg', '~> 0.20'
gem 'puma', '~> 3.8.2'
gem 'sidekiq', '~> 4.2.10'
gem 'redis-namespace'
gem 'rack-cors', require: 'rack/cors'
gem 'administrate', '~> 0.4.0'
gem 'administrate-field-json', '~> 0.0.4'
gem 'bourbon', '~> 4.3.3'
gem 'binding_of_caller'

# API
gem 'active_model_serializers', '~> 0.10.5'

# ASSETS
gem 'turbolinks', '~> 5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 3.1.9'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails', '~> 4.3.1'

# DEPLOYMENT
gem 'morpheus-heroku', '0.2.3'

# MISC
gem 'faraday', '~> 0.11.0'
gem 'twitter', '6.1.0'
gem 'rails_12factor', group: :production

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'spring-commands-rspec'
  gem 'webmock', require: false
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'simplecov', '~> 0.14.1', require: false
end

group :development do
  gem 'annotate', '~> 2.7.1'
  gem 'web-console'
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'awesome_print'
end
