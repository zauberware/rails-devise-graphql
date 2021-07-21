# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.3.2'

# Use postgresql as the database for Active Record
gem 'pg'

gem 'bcrypt', '~> 3.1.7'                    # Use ActiveModel has_secure_password
gem 'cancancan'                             # Defining abilities
gem 'devise'                                # Use devise as authentication module
gem 'devise_invitable', '~> 2.0.0'          # Used to invite users. Allows setting passwords by invited user
gem 'devise_token_auth'
gem 'foreman'
gem 'friendly_id', '5.3.0'                  # Auto generate slugs for resources
gem 'graphql'                               # GraphQL as API
gem 'graphql-pagination'
gem 'image_processing', '~> 1.2'            # Image processing
gem 'mini_magick'                           # Image manipulation with rmagick
gem 'rack-attack'                           # request limiter and ip blocker
gem 'rack-cors'                             # Rack CORS settings
gem 'rails_admin', '~> 2.0.2'               # Admin interface

# I18n
gem 'devise-i18n'                           # Install default translations
gem 'rails_admin-i18n'                      # Use default rails_admin translations
gem 'rails-i18n', '~> 6.0.0'

# gem 'graphiql-rails', group: :development

# Use Puma as the app server
gem 'puma', '~> 3.12'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# gem 'env'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'awesome_print'                       # better console ouput for objects -> ap object.inspect
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'                        # craate a .env file to set local environment variables
  gem 'factory_bot_rails'                   # model mocks with factory bot
  gem 'faker', '~> 1.8'
  gem 'rspec-rails', '~> 3.8'               # used testframework
end

group :test do
  gem 'database_cleaner', '~> 1.6'
  gem 'i18n-spec'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'simplecov', require: false
  gem 'timecop'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop'                             # rubocop for linting ruby code
  gem 'rubocop-performance'                 # speed up rubocop
  gem 'rubocop-rails'                       # rubocop for rails
  gem 'rubocop-rspec'                       # rubocop for rspec
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
