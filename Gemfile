# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'active_storage_validations'
gem 'amazing_print'
gem 'apitome', github: 'mintyfresh/apitome'
gem 'argon2'
gem 'blueprinter'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'faker'
gem 'faraday'
gem 'has_unique_attribute', '~> 0.1.3'
gem 'image_processing'
gem 'json-schema'
gem 'kaminari'
gem 'mini_magick'
gem 'oj'
gem 'omniauth'
gem 'omniauth-discord'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 6.1.1'
gem 'sass-rails', '>= 6'
gem 'seedbank'
gem 'turbolinks', '~> 5'
gem 'view_component'

group :development do
  gem 'annotate'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'rspec_api_documentation'
  gem 'rspec-json_expectations'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 4.0'
  gem 'webmock'
end

group :production do
  gem 'aws-sdk-s3', require: false
  gem 'redis'
  gem 'resque'
  gem 'resque-heroku-signals'
end
