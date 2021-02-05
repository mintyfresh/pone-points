# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'amazing_print'
gem 'argon2'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'faker'
gem 'oj'
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
  gem 'rspec-rails'
end
