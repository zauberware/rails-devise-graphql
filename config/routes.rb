# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV['DEFAULT_URL']

  namespace :api, defaults: { format: 'json' }, path: '/' do
    mount_devise_token_auth_for 'User', at: '/auth'
  end
  devise_for :users, skip: :registrations

  # GraphQL API
  post '/graphql', to: 'graphql#execute'

  # Rails Admin backend
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Just a blank root path
  root 'pages#blank'
end
