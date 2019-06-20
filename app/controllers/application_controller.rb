class ApplicationController < ActionController::API
  
  force_ssl if: :ssl_configured?

  private
  def ssl_configured?
    Rails.env.production?
  end

end
