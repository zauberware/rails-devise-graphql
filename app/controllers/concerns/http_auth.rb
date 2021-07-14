# frozen_string_literal: true

# Injects http authentication to a controller.
module HttpAuth
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate
  end

  protected

  def http_authenticate
    return true unless ENV['IS_HTTP_AUTH_PROTECTED'] == 'true'

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['HTTP_AUTH_USER'] && password == ENV['HTTP_AUTH_PASSWORD']
    end
  end
end
