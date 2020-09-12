# frozen_string_literal: true

# testing all locale files
Dir.glob('config/locales/**/*.yml') do |locale_file|
  RSpec.describe "Locale file #{locale_file}" do
    it_behaves_like 'a valid locale file', locale_file
  end
end
