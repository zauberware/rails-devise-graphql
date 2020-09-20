# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV['DEFAULT_URL']

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post '/graphql', to: 'graphql#execute'
  devise_for :users,
             controllers: {
               confirmations: 'auth/confirmations',
               passwords: 'auth/passwords',
               invitations: 'auth/invitations'
             },
             skip: :registrations # skip registration route

  # Just a blank root path
  root 'pages#blank'
end
