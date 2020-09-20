# frozen_string_literal: true

GraphQL::Auth.configure do |config|
  config.token_lifespan = 4.hours
  config.jwt_secret_key = ENV['DEVISE_SECRET_KEY']
  config.app_url = ENV['CLIENT_URL']

  config.user_type = '::Types::Users::UserType'

  # Devise allowed actions
  # Don't forget to enable the lockable setting in your Devise user model if you plan on using the lock_account feature
  config.allow_sign_up = true
  config.allow_lock_account = true
  config.allow_unlock_account = true
  config.allow_email_confirmable = true

  # Allow custom mutations for signup and update account
  # config.sign_up_mutation = '::Mutations::Auth::SignUp'
  # config.update_account_mutation = '::Mutations::Auth::UpdateAccount'
end
