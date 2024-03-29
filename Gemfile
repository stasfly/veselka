# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'active_storage-postgresql', '~> 0.3.0'
gem 'aws-sdk-s3', require: false
gem 'breadcrumbs_on_rails', '~> 4.1.0'
gem 'devise', '~> 4.8'
gem 'factory_bot_rails', '~> 6.2.0'
gem 'faker', '~>3.1.1'
gem 'image_processing', '~> 1.2'
gem 'new_google_recaptcha', '~>1.4.0'
gem 'normalize-rails', '~> 8.0'
gem 'pagy', '~> 6.0'
gem 'pry', '~> 0.14.1'
gem 'pundit', '~> 2.3.0'
gem 'rails-i18n', '~> 7.0.0'
gem 'ransack', '~> 4.0'
gem 'recaptcha', '~> 5.16.0'
gem 'rolify', '~> 6.0.1'
gem 'rubocop', '~> 1.36', require: false
gem 'simple_form', '~> 5.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-rails', '~> 5.1.2'
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'bullet', '~>7.0.7'
  gem 'letter_opener', '~>1.8.1'
  gem 'web-console', '~> 4.2.0'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara', '~> 3.37.1'
  gem 'database_cleaner', '~> 2.0.2'
  gem 'selenium-webdriver', '~> 4.4.0'
  gem 'webdrivers', '~> 5.1.0'
end

gem 'dockerfile-rails', '>= 1.5', group: :development

gem 'sentry-ruby', '~> 5.12'

gem 'sentry-rails', '~> 5.12'
