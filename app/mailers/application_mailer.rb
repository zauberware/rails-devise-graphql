# frozen_string_literal: true

# Base class for all application mailer
# :nocov:
class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEVISE_MAILER_FROM']
  layout 'mailer'
end
# :nocov:
