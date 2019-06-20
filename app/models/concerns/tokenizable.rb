require 'active_support/concern'

module Tokenizable
  extend ActiveSupport::Concern

  included do
    def token
      token, payload = user_encoder.call(
        self, devise_scope, aud_headers
      )
      token
    end

    private def devise_scope
      @devise_scope ||= Devise::Mapping.find_scope!(self)
    end
  end

  private def user_encoder
    Warden::JWTAuth::UserEncoder.new
  end

  private def aud_headers
    token_headers[Warden::JWTAuth.config.aud_header]
  end

  private def token_headers
    { 
      'Accept' => 'application/json', 
      'Content-Type' => 'application/json' 
    }
  end
end