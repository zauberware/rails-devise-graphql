# frozen_string_literal: true

# rubocop:disable Layout/LineLength
module Auth
  # Custom passwords controller
  class PasswordsController < Devise::PasswordsController
    # GET /resource/password/edit?reset_password_token=abcdef
    # redirect user to front end to reset the passwords there
    def edit
      redirect_to "http://#{ENV['CLIENT_URL']}/users/password/edit?reset_password_token=#{params[:reset_password_token]}"
    end
  end
end
# rubocop:enable Layout/LineLength
