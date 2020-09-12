# frozen_string_literal: true

# Handles setting of locale in your controller.
module LocaleWrapper
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
  end

  protected

  def switch_locale(&action)
    locale = params[:locale] || locale_from_http_accept_lang || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def locale_from_http_accept_lang
    return nil if !request || !request.env['HTTP_ACCEPT_LANGUAGE']

    locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    return nil unless locale

    # only if match
    I18n.available_locales.map(&:to_s).include?(locale) ? locale : nil
  end
end
