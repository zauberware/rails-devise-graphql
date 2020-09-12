# frozen_string_literal: true

# Whitelist locales available for the application
I18n.available_locales = %i[en de]

# Set default locale to something other than :en
I18n.default_locale = :en

I18n.load_path += Dir[Rails.root.join('config/locales/**/*yml').to_s]
