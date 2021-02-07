# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'amazing_print'
gem 'argon2'
gem 'blueprinter'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'faker'
gem 'has_unique_attribute'
gem 'image_processing'
gem 'mini_magick'
gem 'oj'
gem 'omniauth'
gem 'omniauth-discord'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rails', '~> 6.1.1'
gem 'sass-rails', '>= 6'
gem 'seedbank'
gem 'turbolinks', '~> 5'
gem 'view_component'
gem 'webpacker'

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
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'capybara'
  gem 'rspec-json_expectations'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 4.0'
end

group :production do
  gem 'aws-sdk-s3', require: false
  gem 'redis'
  gem 'resque'
  gem 'resque-heroku-signals'
end
