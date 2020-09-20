# frozen_string_literal: true

module Auth
  # Custom confirmations controller
  class ConfirmationsController < Devise::ConfirmationsController
    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
      else
        redirect_to "http://#{ENV['CLIENT_URL']}?error=#{I18n.t('errors.messages.already_confirmed')}"
      end
    end

    private

    # redirect user to front end app after confirming the email adress.
    def after_confirmation_path_for(_resource_name, _resource)
      "http://#{ENV['CLIENT_URL']}?notice=#{I18n.t('devise.confirmations.confirmed')}"
    end
  end
end
