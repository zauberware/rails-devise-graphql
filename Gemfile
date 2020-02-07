source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2'

# Use postgresql as the database for Active Record
gem 'pg'

gem 'devise'                                # Use devise as authentication module
gem 'devise-jwt', '~> 0.5.8'                # Use JWT token authentication with devise
gem 'bcrypt', '~> 3.1.7'                    # Use ActiveModel has_secure_password
gem 'graphql'
gem 'graphql-errors'
gem 'rack-cors'
# gem 'graphiql-rails', group: :development

# Use Puma as the app server
gem 'puma', '~> 3.11'
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
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'                        # craate a .env file to set local environment variables
  gem 'awesome_print'                       # better console ouput for objects -> ap object.inspect
  gem 'factory_bot_rails'                   # model mocks with factory bot
  gem 'rspec-rails', '~> 3.8'               # used testframework
end


group :test do
  gem 'database_cleaner', '~> 1.6'
  gem 'faker', '~> 1.8'
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'rails-controller-testing' 
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
