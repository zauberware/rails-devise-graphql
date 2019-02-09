class ApplicationController < ActionController::API
  
  # before_filter :redirect_to_root_domain if Rails.env.production?
  # force_ssl if: :ssl_configured? #TODO enable SSL

  private
  # def ssl_configured?
  #   Rails.env.production?
  # end

  # def redirect_to_root_domain
  #   domain_to_redirect_to = ENV['DOMAIN']
  #   domain_exceptions = ['0.0.0.0'] # include 0.0.0.0 oder localhost for locale testing
  #   should_redirect = !(domain_exceptions.include? request.host)
  #   new_url = "#{request.protocol}#{domain_to_redirect_to}#{request.fullpath}"
  #   redirect_to new_url, status: :moved_permanently if should_redirect
  # end
end
